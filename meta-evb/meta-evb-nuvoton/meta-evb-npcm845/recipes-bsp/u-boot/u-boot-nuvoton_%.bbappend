FILESEXTRAPATHS:prepend:evb-npcm845 := "${THISDIR}/u-boot-nuvoton:"

SRC_URI:append:evb-npcm845 = " file://emmc.cfg"
SRC_URI:append:evb-npcm845 = " file://env.cfg"
SRC_URI:append:evb-npcm845 = " file://0001-uimage_flash_addr_0x80400000.patch"
