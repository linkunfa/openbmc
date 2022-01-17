SRC_URI_remove_evb-npcm845 = "git://github.com/openbmc/phosphor-host-ipmid"
SRC_URI_prepend_evb-npcm845 = "git://github.com/Nuvoton-Israel/phosphor-host-ipmid"

SRCREV := "e45ee7f50d70d20b6c7a6f3f5656a0f37e6efb85"

DEPENDS_append_evb-npcm845 = " evb-npcm845-yaml-config"

EXTRA_OECONF_evb-npcm845 = " \
    --with-journal-sel \
    SENSOR_YAML_GEN=${STAGING_DIR_HOST}${datadir}/evb-npcm845-yaml-config/ipmi-sensors.yaml \
    FRU_YAML_GEN=${STAGING_DIR_HOST}${datadir}/evb-npcm845-yaml-config/ipmi-fru-read.yaml \
    "

