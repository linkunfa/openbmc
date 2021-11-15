KBRANCH ?= "NPCM-5.10-OpenBMC"
LINUX_VERSION ?= "5.10.67"

SRCREV="9ecbd27ae90c936dd828ed148c94313bcb4e2073"

require linux-nuvoton.inc

SRC_URI_append_nuvoton = " file://0002-add-tps53622-and-tps53659.patch"
SRC_URI_append_nuvoton = " file://0003-i2c-nuvoton-npcm750-runbmc-integrate-the-slave-mqueu.patch"
SRC_URI_append_nuvoton = " file://0004-driver-ncsi-replace-del-timer-sync.patch"
SRC_URI_append_nuvoton = " file://0008-WAR-skip-clear-fault-for-flexpower.patch"
SRC_URI_append_nuvoton = " file://0015-driver-misc-nuvoton-vdm-support-openbmc-libmctp.patch"
SRC_URI_append_nuvoton = " file://0001-driver-remoteproc-Arbel-remoteproc-driver-support.patch"

# Not verified yet.
# SRC_URI_append_nuvoton = " file://0017-drivers-i2c-workaround-for-i2c-slave-behavior.patch"

# V4L2 VCD driver
#SRC_URI_append_nuvoton = " file://v4l2.cfg"
#SRC_URI_append_nuvoton = " file://1111-driver-video-nuvoton-add-video-driver.patch"

# New Arch VDMX/VDMA driver
#SRC_URI_append_nuvoton = " file://2222-driver-misc-add-nuvoton-vdmx-vdma-driver.patch"
