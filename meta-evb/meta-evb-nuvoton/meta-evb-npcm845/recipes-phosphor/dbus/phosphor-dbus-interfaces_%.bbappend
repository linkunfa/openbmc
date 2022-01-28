FILESEXTRAPATHS_prepend_evb-npcm845 := "${THISDIR}/${PN}:"

SRC_URI_append_evb-npcm845 = " file://0001-update-NMISource-interface-from-intel-dbus-interface.patch"
