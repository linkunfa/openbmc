HOMEPAGE = "https://github.com/Nuvoton-Israel/u-boot"
SECTION = "bootloaders"
DEPENDS += "flex-native bison-native"

LICENSE = "GPLv2+"
LIC_FILES_CHKSUM = "file://Licenses/README;md5=30503fd321432fc713238f582193b78e"

UBRANCH = "npcm7xx-v2019.01"
SRCREV = "dea06330cfdc1e61f3567039fb6b90e61268dc35"

UBRANCH_npcm8xx = "npcm8mnx-v2019.01_tmp"
SRCREV_npcm8xx = "2f464ee246720c908906277ba7f03a2403c6177c"

SRC_URI = "git://github.com/Nuvoton-Israel/u-boot.git;branch=${UBRANCH}"

S = "${WORKDIR}/git"

PV .= "+${UBRANCH}+"
