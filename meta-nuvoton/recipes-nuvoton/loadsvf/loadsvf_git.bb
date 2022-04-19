DESCRIPTION = "CPLD/FPGA Programmer"
PR = "r1"

LICENSE = "GPL-2.0-only"
LIC_FILES_CHKSUM = "file://COPYING;md5=b234ee4d69f5fce4486a80fdaf4a4263"

SRC_URI = "git://github.com/Nuvoton-Israel/loadsvf.git;branch=master;protocol=https"
SRCREV = "aba0e177c6c7ca58e240d384892f452c5aec6a21"
S = "${WORKDIR}/git"

inherit autotools pkgconfig

DEPENDS += "autoconf-archive-native"

