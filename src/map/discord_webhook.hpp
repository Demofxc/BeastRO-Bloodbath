#ifndef RATHENA_WEBHOOK_HPP
#define RATHENA_WEBHOOK_HPP

#include <string>
#include <queue>
#include <mutex>
#include <condition_variable>
#include <thread>
#include <atomic>

// ประเภท webhook
enum class WBType { CONTENT_ONLY, DROP_EMBED, MVP_EMBED, GENERIC_EMBED };

struct WBJob {
    WBType type;
    std::string url;
    std::string user;

    // embed
    std::string title;
    std::string desc;
    int         color = -1;
    std::string image;
    std::string thumb;
    std::string footer;
    int         with_ts = 0;   // 1 = ใส่ timestamp

    // raw fields string: "Name|Value|inline;Name2|Value2|0"
    std::string fields;
};

// init / stop system
void webhook_async_init();
void webhook_async_stop();

// ส่งเข้า queue
void webhook_async_enqueue(const WBJob& job);

#endif // RATHENA_WEBHOOK_HPP
