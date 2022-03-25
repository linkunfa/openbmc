FILESEXTRAPATHS:prepend:olympus-nuvoton := "${THISDIR}/${PN}:"

SMBUS_BINDING = "pcie"

SRC_URI:olympus-nuvoton = "git://github.com/Nuvoton-Israel/pmci.git;protocol=https;branch=master"

SRCREV:olympus-nuvoton = "757e8129230516d61262603c6cd93248064ee030"

SRC_URI:append:olympus-nuvoton = " file://mctp_config.json"

do_install:append:olympus-nuvoton() {
    install -m 0644 -D ${WORKDIR}/mctp_config.json \
        ${D}${datadir}/mctp/mctp_config.json
}
