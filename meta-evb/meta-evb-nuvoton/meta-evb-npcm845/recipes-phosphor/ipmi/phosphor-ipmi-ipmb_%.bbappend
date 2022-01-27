FILESEXTRAPATHS_prepend_evb-npcm845 := "${THISDIR}/${PN}:"

SRC_URI_append_evb-npcm845 = " file://ipmb-channels.json"
FILES_${PN}_append_evb-npcm845 = " ${datadir}/ipmbbridge/ipmb-channels.json"

do_install_append_evb-npcm845() {
    install -d ${D}${datadir}/ipmbbridge
    install -m 0644 -D ${WORKDIR}/ipmb-channels.json \
        ${D}${datadir}/ipmbbridge/ipmb-channels.json
}

