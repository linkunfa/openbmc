FILESEXTRAPATHS_prepend := "${THISDIR}/linux-nuvoton:"

SRC_URI_append_evb-npcm845 = " file://evb-npcm845.cfg"
SRC_URI_append_evb-npcm845 = " file://0001-dts-nuvoton-evb-npcm845-support-openbmc-partition.patch"
#SRC_URI_append_evb-npcm845 = " file://0002-dts-nuvoton-evb-npcm845-boot-from-fiu0-cs1.patch"
SRC_URI_append_evb-npcm845 = " file://0003-dts-meta-evb-npcm845-update-pin-configuration-for-SP.patch"
SRC_URI_append_evb-npcm845 = " file://0004-dts-nuvoton-evb-npcm845-add-SPD-i3c-devices-on-bus2.patch"
