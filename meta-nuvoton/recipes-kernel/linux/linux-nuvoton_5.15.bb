KSRC = "git://github.com/Nuvoton-Israel/linux;protocol=https;branch=${KBRANCH}"
KBRANCH = "NPCM-5.15-OpenBMC"
LINUX_VERSION = "5.15.85"
SRCREV = "0ed7a58e0aebb7b2832391efdf0124e87a00652f"

require linux-nuvoton.inc

SRC_URI:append:nuvoton = " file://enable-usb-legacy.cfg"
SRC_URI:append:nuvoton = " file://0017-drivers-i2c-workaround-for-i2c-slave-behavior.patch"
SRC_URI:append:nuvoton = " file://0001-gcc-plugins-Reorganize-gimple-includes-for-GCC-13.patch"

SRC_URI:append:nuvoton = " file://0001-mctp-avoid-confusion-over-local-peer-dest-source-add.patch"
SRC_URI:append:nuvoton = " file://0002-mctp-make-key-lookups-match-the-ANY-address-on-eithe.patch"
SRC_URI:append:nuvoton = " file://0003-mctp-serial-use-netif_receive_skb-instead-of-netif_r.patch"
