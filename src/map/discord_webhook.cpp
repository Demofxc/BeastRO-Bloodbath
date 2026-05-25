#include "discord_webhook.hpp"
#include <common/showmsg.hpp>

#ifdef HAVE_CURL
#include <curl/curl.h>
#endif

#include <iostream>
#include <windows.h>

static std::queue<WBJob> wb_queue;
static std::mutex wb_mutex;
static std::condition_variable wb_cv;
static std::thread wb_thread;
static std::atomic<bool> wb_running(false);


// Escape string สำหรับ JSON (รองรับ UTF-8, emoji, ภาษาไทย)
static std::string json_escape_u8(const std::string& input) {
    std::string out;
    out.reserve(input.size() * 2);

    for (size_t i = 0; i < input.size(); i++) {
        unsigned char c = static_cast<unsigned char>(input[i]);
        switch (c) {
            case '\"': out += "\\\""; break;
            case '\\': out += "\\\\"; break;
            case '/':  out += "\\/";  break;
            case '\b': out += "\\b";  break;
            case '\f': out += "\\f";  break;
            case '\n': out += "\\n";  break;
            case '\r': out += "\\r";  break;
            case '\t': out += "\\t";  break;
            default:
                if (c < 0x20) {
                    // control character อื่นๆ → escape แบบ \u00XX
                    char buf[7];
                    snprintf(buf, sizeof(buf), "\\u%04x", c);
                    out += buf;
                } else {
                    // ปล่อย UTF-8 byte เดิม เช่น ภาษาไทย / emoji
                    out += input[i];
                }
        }
    }

    return out;
}

static std::string tis620_to_utf8(const std::string& in) {
    if (in.empty()) return std::string();
#ifdef _WIN32
    // CP 874 = Thai (Windows) ใกล้เคียง TIS-620 ที่ใช้ใน rAthena
    int wlen = MultiByteToWideChar(874 /*CP_TH*/, 0, in.c_str(), (int)in.size(), NULL, 0);
    if (wlen <= 0) return std::string();

    std::wstring w(wlen, L'\0');
    MultiByteToWideChar(874, 0, in.c_str(), (int)in.size(), &w[0], wlen);

    int u8len = WideCharToMultiByte(CP_UTF8, 0, w.c_str(), wlen, NULL, 0, NULL, NULL);
    if (u8len <= 0) return std::string();

    std::string out(u8len, '\0');
    WideCharToMultiByte(CP_UTF8, 0, w.c_str(), wlen, &out[0], u8len, NULL, NULL);
    return out;
#else
    // ถ้าไม่ได้คอมไพล์บนวินโดวส์ ให้ส่งกลับเดิม (สมมุติว่าเป็น UTF-8 อยู่แล้ว)
    return in;
#endif
}

static std::string tis620_to_utf8(const char* s) {
    if (!s) return {};
    std::string out;
    for (const unsigned char* p = (const unsigned char*)s; *p; ++p) {
        unsigned char c = *p;
        if (c < 0x80) {
            out.push_back(c); // ASCII µ��§µÑ��
        } else if (c >= 0xA1 && c <= 0xFB) {
            unsigned cp = 0x0E01 + (c - 0xA1); // Unicode Thai block U+0E01-U+0E5B
            out.push_back(0xE0 | ((cp >> 12) & 0x0F));
            out.push_back(0x80 | ((cp >> 6) & 0x3F));
            out.push_back(0x80 | (cp & 0x3F));
        } else {
            out.push_back('?'); // ¶éÒä��èãªè TIS620 range
        }
    }
    return out;
}

std::string to_utf8(const char* tis) {
    return tis620_to_utf8(tis ? tis : "");
}

//static std::string json_escape_u8(const std::string& in) { /* ตัวที่คุณใช้อยู่ */ }
// helper แบ่งสตริง
static std::vector<std::string> split_kv(const std::string& s, char sep) {
    std::vector<std::string> out; std::string cur;
    for (char c: s) {
        if (c==sep) { out.push_back(cur); cur.clear(); }
        else cur.push_back(c);
    }
    out.push_back(cur);
    return out;
}

static std::string iso8601_utc_now() {
    time_t t = time(nullptr);
    tm g;
#ifdef _WIN32
    gmtime_s(&g, &t);
#else
    gmtime_r(&t, &g);
#endif
    char buf[32];
    strftime(buf, sizeof(buf), "%Y-%m-%dT%H:%M:%S.000Z", &g);
    return std::string(buf);
}

#ifdef HAVE_CURL
// escape JSON
static std::string json_escape(const std::string& s) {
    std::string out;
    for (unsigned char c : s) {
        switch (c) {
            case '\\': out += "\\\\"; break;
            case '\"': out += "\\\""; break;
            case '\n': out += "\\n"; break;
            case '\r': out += "\\r"; break;
            case '\t': out += "\\t"; break;
            default:
                if (c < 0x20) {
                    char buf[8];
                    sprintf(buf,"\\u%04x",c);
                    out += buf;
                } else {
                    out += c;
                }
        }
    }
    return out;
}

// ส่ง webhook จริง
static long discord_send_embed(const WBJob& job) {
    if (job.url.empty()) return -1;

    auto enc = [](const std::string& s) -> std::string {
        // แปลง TIS-620/CP874 -> UTF-8 แล้วค่อย escape สำหรับ JSON
        return json_escape_u8(tis620_to_utf8(s));
    };

    std::string payload = "{";
    payload += "\"username\":\"" + enc(job.user.empty() ? "rAthena" : job.user) + "\"";

    if (job.type == WBType::CONTENT_ONLY && !job.desc.empty()) {
        payload += ",\"content\":\"" + enc(job.desc) + "\"";
    } else {
        payload += ",\"embeds\":[{";
        bool first = true;

        if (!job.title.empty()) { payload += "\"title\":\"" + enc(job.title) + "\""; first=false; }
        if (!job.desc.empty())  { if(!first) payload+=','; payload += "\"description\":\"" + enc(job.desc) + "\""; first=false; }
        if (job.color >= 0)     { if(!first) payload+=','; payload += "\"color\":" + std::to_string(job.color); first=false; }
        if (!job.footer.empty()){ if(!first) payload+=','; payload += "\"footer\":{\"text\":\"" + enc(job.footer) + "\"}"; first=false; }
        if (!job.image.empty()) { if(!first) payload+=','; payload += "\"image\":{\"url\":\"" + json_escape_u8(job.image) + "\"}"; first=false; }
        if (!job.thumb.empty()) { if(!first) payload+=','; payload += "\"thumbnail\":{\"url\":\"" + json_escape_u8(job.thumb) + "\"}"; first=false; }

        // fields: "Name|Value|inline;Name2|Value2|0"
        if (!job.fields.empty()) {
            if(!first) payload+=','; first=false;
            payload += "\"fields\":[";
            bool f = true;
            auto rows = split_kv(job.fields, ';');
            for (auto &row : rows) {
                if (row.empty()) continue;
                auto cols = split_kv(row, '|');
                std::string name  = enc(cols.size()>0 ? cols[0] : "");
                std::string value = enc(cols.size()>1 ? cols[1] : "");
                std::string inl   = (cols.size()>2 ? cols[2] : "0");
                if (name.empty() && value.empty()) continue;
                if (!f) payload += ',';
                payload += "{\"name\":\""+name+"\",\"value\":\""+value+"\",\"inline\":"+
                           ((inl=="1"||inl=="true"||inl=="TRUE")?"true":"false")+"}";
                f = false;
            }
            payload += "]";
        }

        if (job.with_ts) {
            if(!first) payload+=',';
            payload += "\"timestamp\":\"" + iso8601_utc_now() + "\"";
        }

        payload += "}]";
    }

    payload += "}";
    //ShowDebug("[Webhook] Payload = %s\n", payload.c_str());

    // ส่งด้วย libcurl (เหมือนเดิม)
    CURL* curl = curl_easy_init();
    if (!curl) return -2;
    struct curl_slist* headers = NULL;
    headers = curl_slist_append(headers, "Content-Type: application/json; charset=utf-8");
    curl_easy_setopt(curl, CURLOPT_URL, job.url.c_str());
    curl_easy_setopt(curl, CURLOPT_POST, 1L);
    curl_easy_setopt(curl, CURLOPT_HTTPHEADER, headers);
    curl_easy_setopt(curl, CURLOPT_POSTFIELDS, payload.c_str());
    curl_easy_setopt(curl, CURLOPT_POSTFIELDSIZE, (long)payload.size());
    curl_easy_setopt(curl, CURLOPT_TIMEOUT, 7L);
    curl_easy_setopt(curl, CURLOPT_USERAGENT, "rAthena-DiscordWebhook/1.0");

    long code = 0; CURLcode res = curl_easy_perform(curl);
    if (res == CURLE_OK) curl_easy_getinfo(curl, CURLINFO_RESPONSE_CODE, &code);
    else code = -3;

    curl_slist_free_all(headers);
    curl_easy_cleanup(curl);
    return code; // 204 = OK
}
#endif // HAVE_CURL

// worker loop
static void webhook_async_worker() {
    while (wb_running) {
        std::unique_lock<std::mutex> lock(wb_mutex);
        wb_cv.wait(lock, []{ return !wb_queue.empty() || !wb_running; });

        while (!wb_queue.empty()) {
            WBJob job = wb_queue.front();
            wb_queue.pop();
            lock.unlock();

        #ifdef HAVE_CURL
            long http = discord_send_embed(job);
            std::cout << "[Webhook] Sent (HTTP " << http << ") title=" << job.title << "\n";
        #else
            std::cout << "[Webhook] (Skipped, built without libcurl)\n";
        #endif

            lock.lock();
        }
    }
}

void webhook_async_init() {
    wb_running = true;
    wb_thread = std::thread(webhook_async_worker);
}

void webhook_async_stop() {
    {
        std::lock_guard<std::mutex> lock(wb_mutex);
        wb_running = false;
    }
    wb_cv.notify_one();
    if (wb_thread.joinable()) wb_thread.join();
}

void webhook_async_enqueue(const WBJob& job) {
    {
        std::lock_guard<std::mutex> lock(wb_mutex);
        wb_queue.push(job);
    }
    wb_cv.notify_one();
}
