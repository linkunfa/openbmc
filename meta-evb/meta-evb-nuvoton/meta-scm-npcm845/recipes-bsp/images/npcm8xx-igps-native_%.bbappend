FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:append = " file://UbootHeader_PTR.xml"

do_install:append() {
	install -d ${DEST}
	install -m 0644 ${WORKDIR}/UbootHeader_PTR.xml ${DEST}/UbootHeader_${DEVICE_GEN}.xml 
}
