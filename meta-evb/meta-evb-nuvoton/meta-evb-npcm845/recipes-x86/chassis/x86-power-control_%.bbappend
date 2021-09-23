FILESEXTRAPATHS_prepend_evb-npcm845 := "${THISDIR}/${PN}:"

SRC_URI_append_evb-npcm845 = " file://power-config-host0.json"

FILES_${PN} += " ${datadir}/x86-power-control/power-config-host0.json \"

do_install_append_evb-npcm845() {
    install -d ${D}${datadir}/x86-power-control
    install -m 0644 -D ${WORKDIR}/power-config-host0.json \
        ${D}${datadir}/x86-power-control/power-config-host0.json
}
