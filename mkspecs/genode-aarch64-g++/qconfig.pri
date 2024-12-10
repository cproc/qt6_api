host_build {
    QT_ARCH = x86_64
    QT_BUILDABI = x86_64-little_endian-lp64
    QT_TARGET_ARCH = 
    QT_TARGET_BUILDABI = 
} else {
    QT_ARCH = 
    QT_BUILDABI = 
    QT_LIBCPP_ABI_TAG = 
}
QT.global.enabled_features = shared cross_compile rpath c++20 c++2a signaling_nan thread future concurrent shared cross_compile shared rpath c++20 c++2a reduce_exports
QT.global.disabled_features = static pkg-config debug_and_release separate_debug_info appstore-compliant simulator_and_device force_asserts framework c++2b c++2b reduce_relocations wasm-simd128 wasm-exceptions zstd dbus openssl-linked opensslv11 opensslv30
QT.global.disabled_features += release build_all
QT_CONFIG += shared no-pkg-config rpath c++20 c++2a reduce_exports release
CONFIG +=  shared cross_compile plugin_manifest
QT_VERSION = 6.6.2
QT_MAJOR_VERSION = 6
QT_MINOR_VERSION = 6
QT_PATCH_VERSION = 2

QT_GCC_MAJOR_VERSION = 12
QT_GCC_MINOR_VERSION = 3
QT_GCC_PATCH_VERSION = 0
QT_EDITION = Open Source
