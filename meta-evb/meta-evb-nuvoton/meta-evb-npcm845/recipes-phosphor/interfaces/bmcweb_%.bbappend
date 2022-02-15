inherit entity-utils

# Enable Redfish BMC Journal support
EXTRA_OEMESON_append_evb-npcm845  = " -Dredfish-bmc-journal=enabled"

# Enable Redfish DBUS log/Journal support
EXTRA_OECMAKE_append_evb-npcm845 = " ${@entity_enabled(d, '-Dredfish-bmc-journal=enabled', '-Dredfish-dbus-log=enabled')}"

# Enable TFTP
EXTRA_OEMESON_append_evb-npcm845  = " -Dinsecure-tftp-update=enabled"

# Increase body limit for FW size
EXTRA_OEMESON_append_evb-npcm845  = " -Dhttp-body-limit=65"
