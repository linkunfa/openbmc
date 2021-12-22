HOMEPAGE = "https://github.com/Nuvoton-Israel/u-boot"
SECTION = "bootloaders"
DEPENDS += "flex-native bison-native"

LICENSE = "GPLv2+"
LIC_FILES_CHKSUM = "file://Licenses/README;md5=30503fd321432fc713238f582193b78e"
LIC_FILES_CHKSUM_npcm8xx = "file://Licenses/README;md5=5a7450c57ffe5ae63fd732446b988025"

UBRANCH = "npcm7xx-v2019.01"
SRCREV = "dea06330cfdc1e61f3567039fb6b90e61268dc35"

UBRANCH_npcm8xx = "npcm-v2021.04"
SRCREV_npcm8xx = "be078ee12f591a4dab8776bb021f7c22704fa73c"

SRC_URI = "git://github.com/Nuvoton-Israel/u-boot.git;branch=${UBRANCH}"

S = "${WORKDIR}/git"

PV .= "+${UBRANCH}+"
