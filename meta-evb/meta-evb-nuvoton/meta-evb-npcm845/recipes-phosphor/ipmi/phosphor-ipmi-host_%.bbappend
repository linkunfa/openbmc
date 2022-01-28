SRC_URI_remove_evb-npcm845 = "git://github.com/openbmc/phosphor-host-ipmid"
SRC_URI_prepend_evb-npcm845 = "git://github.com/Nuvoton-Israel/phosphor-host-ipmid"

FILESEXTRAPATHS_append_evb-npcm845 := "${THISDIR}/${PN}:"

SRCREV := "e45ee7f50d70d20b6c7a6f3f5656a0f37e6efb85"

DEPENDS_append_evb-npcm845 = " evb-npcm845-yaml-config"

EXTRA_OECONF_evb-npcm845 = " \
    --with-journal-sel \
    SENSOR_YAML_GEN=${STAGING_DIR_HOST}${datadir}/evb-npcm845-yaml-config/ipmi-sensors.yaml \
    FRU_YAML_GEN=${STAGING_DIR_HOST}${datadir}/evb-npcm845-yaml-config/ipmi-fru-read.yaml \
    "

SRC_URI_append_evb-npcm845 = " file://0001-Support-bridging-commands.patch"
SRC_URI_append_evb-npcm845 = " file://0002-add-oem-command-get-bios-post-code.patch"
