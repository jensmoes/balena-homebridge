#!/usr/bin/env bash
# Tell the container that DBUS should report to Host OS
export DBUS_SYSTEM_BUS_ADDRESS=unix:path=/host/run/dbus/system_bus_socket

# Start services
service dbus start
service autofs start
# Set hostname default
if [[ -z "$DEVICE_HOSTNAME" ]]; then
  DEVICE_HOSTNAME=HomeBridge
fi

printf "%s\n" "Setting device hostname to: $DEVICE_HOSTNAME"

curl -X PATCH --header "Content-Type:application/json" \
    --data '{"network": {"hostname": "'"${DEVICE_HOSTNAME}"'"}}' \
    "$BALENA_SUPERVISOR_ADDRESS/v1/device/host-config?apikey=$BALENA_SUPERVISOR_API_KEY"

# The content of the config.json containing the homebridge configuration and the various plugins used
if [[ ! -z "CONFIG_JSON" ]]; then
  echo ${CONFIG_JSON} | cat > config.json
fi

# The content of the auth.json controlling access to the admin interface
if [[ ! -z "AUTH_JSON" ]]; then
  echo ${AUTH_JSON} | cat > auth.json
fi

# The user storage path for homebridge to use as it's persistent storage
# Defaults to the data partition on the SD card
if [[ -z "$STORAGE_PATH" ]]; then
  STORAGE_PATH=/data/homebridge
fi

# Link to the config files from persistent area. 
# Unfortunately HB needs a persistent storage to store it's state.
# This should ideally be a proper storage device, not an SD card. But in case it is, this will prevent a write to the card everytime the container restarts
ln -s /usr/src/config.json ${STORAGE_PATH}/config.json
ln -s /usr/src/auth.json ${STORAGE_PATH}/auth.json

echo "Starting homebridge in ${STORAGE_PATH}"
exec homebridge --user-storage-path ${STORAGE_PATH} > /var/log/homebridge.log
