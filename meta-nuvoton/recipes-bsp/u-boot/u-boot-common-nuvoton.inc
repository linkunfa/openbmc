HOMEPAGE = "https://github.com/Nuvoton-Israel/u-boot"
SECTION = "bootloaders"
DEPENDS += "flex-native bison-native"

LICENSE = "GPLv2+"
LIC_FILES_CHKSUM = "file://Licenses/README;md5=5a7450c57ffe5ae63fd732446b988025"

UBRANCH = "npcm-v2021.04"
SRC_URI = "git://github.com/Nuvoton-Israel/u-boot.git;branch=${UBRANCH};protocol=https"
SRCREV = "b514058044acf3996226c8c00fcde9c4d23a7749"

S = "${WORKDIR}/git"

PV .= "+${UBRANCH}+"
