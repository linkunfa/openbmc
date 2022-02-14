inherit entity-utils

EXTRA_OECMAKE_append_evb-npcm845 = " -DSEL_LOGGER_MONITOR_WATCHDOG_EVENTS=ON"
EXTRA_OECMAKE_append_evb-npcm845 = " ${@entity_enabled(d, '', '-DSEL_LOGGER_SEND_TO_LOGGING_SERVICE=ON')}"
EXTRA_OECMAKE_append_evb-npcm845 = " ${@entity_enabled(d, '', '-DSEL_LOGGER_MONITOR_THRESHOLD_ALARM_EVENTS=ON')}"
EXTRA_OECMAKE_append_evb-npcm845 = " ${@entity_enabled(d, '-DSEL_LOGGER_MONITOR_THRESHOLD_EVENTS=ON', '')}"
