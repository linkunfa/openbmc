SUMMARY  = "A collection of tools, libraries and tests for shader compilation"
DESCRIPTION = "The Shaderc library provides an API for compiling GLSL/HLSL \
source code to SPIRV modules. It has been shipping in the Android NDK since version r12b."
SECTION = "graphics"
HOMEPAGE = "https://github.com/google/shaderc"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=86d3f3a95c324c9479bd8986968f4327"

SRCREV = "067e008c80c323b1cd1ab1e547b38f9a5f52269e"
SRC_URI = "git://github.com/google/shaderc.git;protocol=https;branch=main \
           file://0001-cmake-disable-building-external-dependencies.patch \
           file://0002-libshaderc_util-fix-glslang-header-file-location.patch \
           file://0001-CMakeLists.txt-drop-OSDependent-OGLCompiler-from-lis.patch \
           "
UPSTREAM_CHECK_GITTAGREGEX = "^v(?P<pver>\d+(\.\d+)+)$"
S = "${WORKDIR}/git"

inherit cmake python3native pkgconfig

DEPENDS = "spirv-headers spirv-tools glslang"

EXTRA_OECMAKE = " \
    -DCMAKE_BUILD_TYPE=Release \
    -DBUILD_EXTERNAL=OFF \
    -DSHADERC_SKIP_TESTS=ON \
    -DSHADERC_SKIP_EXAMPLES=ON \
    -DSHADERC_SKIP_COPYRIGHT_CHECK=ON \
"

BBCLASSEXTEND = "native nativesdk"
