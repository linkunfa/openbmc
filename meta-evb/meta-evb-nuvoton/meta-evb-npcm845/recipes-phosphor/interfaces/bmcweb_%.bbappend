# Enable Redfish BMC Journal support
EXTRA_OEMESON_append_evb-npcm845  = " -Dredfish-bmc-journal=enabled"

# Enable DBUS log service
EXTRA_OEMESON_append_evb-npcm845  = " -Dredfish-dbus-log=enabled"

# Enable TFTP
EXTRA_OEMESON_append_evb-npcm845  = " -Dinsecure-tftp-update=enabled"

# Increase body limit for FW size
EXTRA_OEMESON_append_evb-npcm845  = " -Dhttp-body-limit=65"
