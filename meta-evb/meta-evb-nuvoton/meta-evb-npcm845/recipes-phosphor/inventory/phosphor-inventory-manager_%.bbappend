FILESEXTRAPATHS_prepend_evb-npcm845 := "${THISDIR}/${PN}:"
PACKAGECONFIG_append_evb-npcm845 = " associations"
SRC_URI_append_evb-npcm845 = " file://associations.json"
DEPENDS_append_evb-npcm845 = " evb-npcm845-inventory-cleanup"

do_install_append_evb-npcm845() {
    install -d ${D}${base_datadir}
    install -m 0755 ${WORKDIR}/associations.json ${D}${base_datadir}/associations.json
}
