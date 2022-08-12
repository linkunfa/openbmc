FILESEXTRAPATHS:prepend:scm-npcm845  := "${THISDIR}/files:"

SRC_URI:append:scm-npcm845 = " file://bmc_health_config.json"
SRC_URI:append:scm-npcm845 = " file://0001-change-the-cpu-sensor-name-from-CPU-to-CPU_Utilizati.patch"

SRCREV:scm-npcm845 = "f8d797372088ec0a9b2356de21496b0bc7fce95d"

do_install:append:scm-npcm845() {
    install -d ${D}/${sysconfdir}/healthMon/
    install -m 0644 ${WORKDIR}/bmc_health_config.json ${D}/${sysconfdir}/healthMon/
}