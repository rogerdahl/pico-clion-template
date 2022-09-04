cmake_minimum_required(VERSION 3.12)

set(CMAKE_C_STANDARD 11)
set(CMAKE_CXX_STANDARD 17)

set(PICO_BOARD pico_w)

# Pull in SDK (must be before project)
include(pico_sdk_import.cmake)

project(pico_examples C CXX ASM)

if (PICO_SDK_VERSION_STRING VERSION_LESS "1.3.0")
  message(
      FATAL_ERROR
      "Raspberry Pi Pico SDK version 1.3.0 (or later) required. Your version is ${PICO_SDK_VERSION_STRING}"
  )
endif ()

# initialize pico-sdk from GIT
# (note this can come from environment, CMake cache etc)
#set(PICO_SDK_FETCH_FROM_GIT on)

#set(PICO_EXAMPLES_PATH ${PROJECT_SOURCE_DIR})

# Initialize the SDK
pico_sdk_init()

add_executable(
    blink
    main.c
)

#target_include_directories(
#    blink
#    PRIVATE
#    ${CMAKE_CURRENT_LIST_DIR}
#    ...
#)

# pull in common dependencies
target_link_libraries(
    blink
    pico_stdlib
    pico_cyw43_arch_none # we need Wifi to access the GPIO, but we don't need anything else
    # pico_cyw43_arch_lwip_threadsafe_background
)

# create map/bin/hex file etc.
pico_add_extra_outputs(blink)

#pico_enable_stdio_usb(blink 1)
#pico_enable_stdio_uart(blink 1)

# add url via pico_set_program_url
#include(example_auto_set_url.cmake)
#example_auto_set_url(blink)

add_compile_options(
    -Wall
    -Wno-format          # int != int32_t as far as the compiler is concerned because gcc has int32_t as long int
    -Wno-unused-function # we have some for the docs that aren't called
    -Wno-maybe-uninitialized
)

#if (PICO_CYW43_SUPPORTED) # set by BOARD=pico-w
#    if (NOT TARGET pico_cyw43_arch)
#        message("Skipping Pico W examples as support is not available")
#    else()
#        set(WIFI_SSID "${WIFI_SSID}" CACHE INTERNAL "WiFi SSID for examples")
#        set(WIFI_PASSWORD "${WIFI_PASSWORD}" CACHE INTERNAL "WiFi password for examples")
#
#        add_subdirectory(blink)
#        add_subdirectory(wifi_scan)
#        add_subdirectory(access_point)
#
#        if ("${WIFI_SSID}" STREQUAL "")
#            message("Skipping some Pico W examples as WIFI_SSID is not defined")
#        elseif ("${WIFI_PASSWORD}" STREQUAL "")
#            message("Skipping some Pico W examples as WIFI_PASSWORD is not defined")
#        else()
#            add_subdirectory(iperf)
#            add_subdirectory(ntp_client)
#            add_subdirectory(tcp_client)
#            add_subdirectory(tcp_server)
#            add_subdirectory(freertos)
#        endif()
#    endif()
#endif()
