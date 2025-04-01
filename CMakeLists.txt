cmake_minimum_required(VERSION 3.20)

project(ErikOS LANGUAGES C ASM)

# Require out-of-source builds
if(${CMAKE_SOURCE_DIR} STREQUAL ${CMAKE_BINARY_DIR})
    message(FATAL_ERROR "In-source builds are not allowed. Use a separate build directory.")
endif()

# You can pass -DTARGET_ARCH=<arch> to select an architecture
if(NOT DEFINED TARGET_ARCH)
    set(TARGET_ARCH "x86_64") # Default architecture
endif()

include(${TARGET_ARCH}.cmake OPTIONAL)

# Define the install path for libraries, headers, etc.
# This should point to your sysroot
set(CMAKE_INSTALL_PREFIX "${CMAKE_BINARY_DIR}/sysroot")

# Helpful message
message(STATUS "Target architecture: ${TARGET_ARCH}")
message(STATUS "Install prefix set to ${CMAKE_INSTALL_PREFIX}")

# === Dependencies / Submodules ===

add_subdirectory(boot)
add_subdirectory(kernel)

add_subdirectory(bus)
add_subdirectory(libc)
add_subdirectory(init)

# === Installation Target ===

include(GNUInstallDirs)
install(CODE "message(STATUS \"All components installed to: ${CMAKE_INSTALL_PREFIX}\")")
