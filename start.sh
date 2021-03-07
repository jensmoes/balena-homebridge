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

if [[ ! -z "CONFIG_JSON" ]]; then
  echo ${CONFIG_JSON} | cat >> config.json
fi

if [[ ! -z "AUTH_JSON" ]]; then
  echo ${AUTH_JSON} | cat >> auth.json
fi

# Put the homebridge directory in persistent mem
cp /usr/src/*.json /data/homebridge/

echo Starting homebridge
exec homebridge --user-storage-path /data/homebridge/ > /var/log/homebridge.log
