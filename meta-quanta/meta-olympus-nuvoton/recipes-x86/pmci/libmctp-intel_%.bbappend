FILESEXTRAPATHS:prepend:olympus-nuvoton := "${THISDIR}/${PN}:"

SRC_URI:olympus-nuvoton := "git://github.com/Nuvoton-Israel/libmctp.git;protocol=https;branch=master"
SRCREV:olympus-nuvoton := "177c9d8517afcd88c4b108267e63dff377ce1ede"

TARGET_CFLAGS:append:olympus-nuvoton = " -DMCTP_HAVE_FILEIO"


