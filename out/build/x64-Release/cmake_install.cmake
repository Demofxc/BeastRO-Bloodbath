# Install script for directory: C:/Users/Awake/Desktop/Beast-HiClass

# Set the install prefix
if(NOT DEFINED CMAKE_INSTALL_PREFIX)
  set(CMAKE_INSTALL_PREFIX "C:/Users/Awake/Desktop/Beast-HiClass/out/build/x64-Release/install")
endif()
string(REGEX REPLACE "/$" "" CMAKE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")

# Set the install configuration name.
if(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)
  if(BUILD_TYPE)
    string(REGEX REPLACE "^[^A-Za-z0-9_]+" ""
           CMAKE_INSTALL_CONFIG_NAME "${BUILD_TYPE}")
  else()
    set(CMAKE_INSTALL_CONFIG_NAME "RelWithDebInfo")
  endif()
  message(STATUS "Install configuration: \"${CMAKE_INSTALL_CONFIG_NAME}\"")
endif()

# Set the component getting installed.
if(NOT CMAKE_INSTALL_COMPONENT)
  if(COMPONENT)
    message(STATUS "Install component: \"${COMPONENT}\"")
    set(CMAKE_INSTALL_COMPONENT "${COMPONENT}")
  else()
    set(CMAKE_INSTALL_COMPONENT)
  endif()
endif()

# Is this installation the result of a crosscompile?
if(NOT DEFINED CMAKE_CROSSCOMPILING)
  set(CMAKE_CROSSCOMPILING "FALSE")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Runtime_base" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/." TYPE FILE FILES
    "C:/Users/Awake/Desktop/Beast-HiClass/athena-start"
    "C:/Users/Awake/Desktop/Beast-HiClass/LICENSE"
    "C:/Users/Awake/Desktop/Beast-HiClass/README.md"
    "C:/Users/Awake/Desktop/Beast-HiClass/dbghelp.dll"
    "C:/Users/Awake/Desktop/Beast-HiClass/libmysql.dll"
    "C:/Users/Awake/Desktop/Beast-HiClass/pcre3.dll"
    "C:/Users/Awake/Desktop/Beast-HiClass/zlib1.dll"
    "C:/Users/Awake/Desktop/Beast-HiClass/tools/charserv.bat"
    "C:/Users/Awake/Desktop/Beast-HiClass/tools/logserv.bat"
    "C:/Users/Awake/Desktop/Beast-HiClass/tools/mapserv.bat"
    "C:/Users/Awake/Desktop/Beast-HiClass/tools/runserver.bat"
    "C:/Users/Awake/Desktop/Beast-HiClass/tools/serv.bat"
    )
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Runtime_base" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/conf" TYPE DIRECTORY FILES "C:/Users/Awake/Desktop/Beast-HiClass/conf/" REGEX "/[\\\\.]svn$" EXCLUDE REGEX "/conf\\/import\\-tmpl$" EXCLUDE)
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Runtime_base" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/db" TYPE DIRECTORY FILES "C:/Users/Awake/Desktop/Beast-HiClass/db/" REGEX "/[\\\\.]svn$" EXCLUDE REGEX "/conf\\/import\\-tmpl$" EXCLUDE)
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Runtime_base" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/doc" TYPE DIRECTORY FILES "C:/Users/Awake/Desktop/Beast-HiClass/doc/" REGEX "/[\\\\.]svn$" EXCLUDE REGEX "/conf\\/import\\-tmpl$" EXCLUDE)
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Runtime_base" OR NOT CMAKE_INSTALL_COMPONENT)
  file(MAKE_DIRECTORY "${ENV}${CMAKE_INSTALL_PREFIX}/log")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Runtime_base" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/npc" TYPE DIRECTORY FILES "C:/Users/Awake/Desktop/Beast-HiClass/npc/" REGEX "/[\\\\.]svn$" EXCLUDE REGEX "/conf\\/import\\-tmpl$" EXCLUDE)
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Runtime_base" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/sql-files" TYPE DIRECTORY FILES "C:/Users/Awake/Desktop/Beast-HiClass/sql-files/" REGEX "/[\\\\.]svn$" EXCLUDE REGEX "/conf\\/import\\-tmpl$" EXCLUDE)
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Runtime_base" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/tools" TYPE DIRECTORY FILES "C:/Users/Awake/Desktop/Beast-HiClass/tools/" REGEX "/[\\\\.]svn$" EXCLUDE REGEX "/conf\\/import\\-tmpl$" EXCLUDE)
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Runtime_templates" OR NOT CMAKE_INSTALL_COMPONENT)
  include("C:/Users/Awake/Desktop/Beast-HiClass/out/build/x64-Release/InstallTemplates.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for each subdirectory.
  include("C:/Users/Awake/Desktop/Beast-HiClass/out/build/x64-Release/3rdparty/cmake_install.cmake")
  include("C:/Users/Awake/Desktop/Beast-HiClass/out/build/x64-Release/src/cmake_install.cmake")

endif()

string(REPLACE ";" "\n" CMAKE_INSTALL_MANIFEST_CONTENT
       "${CMAKE_INSTALL_MANIFEST_FILES}")
if(CMAKE_INSTALL_LOCAL_ONLY)
  file(WRITE "C:/Users/Awake/Desktop/Beast-HiClass/out/build/x64-Release/install_local_manifest.txt"
     "${CMAKE_INSTALL_MANIFEST_CONTENT}")
endif()
if(CMAKE_INSTALL_COMPONENT)
  if(CMAKE_INSTALL_COMPONENT MATCHES "^[a-zA-Z0-9_.+-]+$")
    set(CMAKE_INSTALL_MANIFEST "install_manifest_${CMAKE_INSTALL_COMPONENT}.txt")
  else()
    string(MD5 CMAKE_INST_COMP_HASH "${CMAKE_INSTALL_COMPONENT}")
    set(CMAKE_INSTALL_MANIFEST "install_manifest_${CMAKE_INST_COMP_HASH}.txt")
    unset(CMAKE_INST_COMP_HASH)
  endif()
else()
  set(CMAKE_INSTALL_MANIFEST "install_manifest.txt")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  file(WRITE "C:/Users/Awake/Desktop/Beast-HiClass/out/build/x64-Release/${CMAKE_INSTALL_MANIFEST}"
     "${CMAKE_INSTALL_MANIFEST_CONTENT}")
endif()
