#!/usr/bin/with-contenv bashio

export AMB_MQTT_USERNAME=$(bashio::config 'mqtt_username')
export AMB_MQTT_PASSWORD=$(bashio::config 'mqtt_password')
export AMB_MQTT_BROKER_HOST=$(bashio::config 'mqtt_server')
export AMB_MQTT_BROKER_PORT=$(bashio::config 'mqtt_port')
export AMB_HASS_DISCOVERY_TOPIC=$(bashio::config 'mqtt_discovery_data_topic')
export AMB_MQTT_BASE_TOPIC=$(bashio::config 'mqtt_data_root_topic')


# Try Hassio MQTT Auto-Configuration
if ! bashio::services.available "mqtt" && ! bashio::config.exists 'mqtt_server'; then
    bashio::exit.nok "No internal MQTT service found and no MQTT server defined. Please install Mosquitto broker or specify your own."
else
    bashio::log.info "MQTT available, fetching server detail ..."
    if ! bashio::config.exists 'mqtt_server'; then
        bashio::log.info "MQTT server settings not configured, trying to auto-discovering ..."
        # MQTT_PREFIX="mqtt://"
        # if [ $(bashio::services mqtt "ssl") = true ]; then
        #     MQTT_PREFIX="mqtts://"
        # fi
        # MQTT_SERVER="$MQTT_PREFIX$(bashio::services mqtt "host"):$(bashio::services mqtt "port")"
        export AMB_MQTT_BROKER_HOST=$(bashio::services mqtt "host")
        export AMB_MQTT_BROKER_PORT=$(bashio::services mqtt "port")
        bashio::log.info "Configuring '$MQTT_HOST' mqtt server"
    fi
    if ! bashio::config.exists 'mqtt_username'; then
        bashio::log.info "MQTT credentials not configured, trying to auto-discovering ..."
        export AMB_MQTT_USERNAME=$(bashio::services mqtt "username")
        export AMB_MQTT_PASSWORD=$(bashio::services mqtt "password")
        bashio::log.info "Configuring '$MQTT_USERNAME' mqtt user"
    fi
fi

# Default values for optional fields
if ! bashio::config.exists 'mqtt_discovery_data_topic'; then
        export MQTT_DISCOVERY_DATA_TOPIC="homeassistant"
fi
if ! bashio::config.exists 'mqtt_data_root_topic'; then
        export AMB_MQTT_BASE_TOPIC="akwatek"
fi

/app/akwatek-mqtt-bridge
