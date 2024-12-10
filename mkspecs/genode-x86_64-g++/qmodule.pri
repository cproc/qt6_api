host_build {
    QT_CPU_FEATURES.x86_64 = 
} else {
    QT_CPU_FEATURES. = 
}
QT.global_private.enabled_features = reduce_exports alloca gui network printsupport sql testlib widgets xml dlopen cross_compile force_debug_info largefile
QT.global_private.disabled_features = use_bfd_linker use_gold_linker use_lld_linker use_mold_linker android-style-assets gc_binaries developer-build private_tests debug no_direct_extern_access x86intrin sse2 sse3 ssse3 sse4_1 sse4_2 avx f16c avx2 avx512f avx512er avx512cd avx512pf avx512dq avx512bw avx512vl avx512ifma avx512vbmi avx512vbmi2 aesni vaes rdrnd rdseed shani mips_dsp mips_dspr2 neon arm_crc32 arm_crypto posix_fallocate alloca_h alloca_malloc_h stack-protector-strong system-zlib stdlib-libcpp dbus dbus-linked libudev openssl relocatable intelcet
CONFIG += cross_compile force_debug_info largefile
QT_COORD_TYPE = double
QT_BUILD_PARTS = libs

