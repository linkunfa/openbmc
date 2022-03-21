HOMEPAGE = "https://github.com/Nuvoton-Israel/u-boot"
SECTION = "bootloaders"
DEPENDS += "flex-native bison-native"

LICENSE = "GPLv2+"
LIC_FILES_CHKSUM = "file://Licenses/README;md5=5a7450c57ffe5ae63fd732446b988025"

UBRANCH = "npcm-v2021.04"
SRCREV = "c44e31c4e3405699bc48152adc9370eb02332b2e"

SRC_URI = "git://github.com/Nuvoton-Israel/u-boot.git;branch=${UBRANCH}"

S = "${WORKDIR}/git"

PV .= "+${UBRANCH}+"
