#!/usr/bin/env bash
# Tell the container that DBUS should report to Host OS
export DBUS_SYSTEM_BUS_ADDRESS=unix:path=/host/run/dbus/system_bus_socket

# Set hostname default
if [[ -z "$DEVICE_HOSTNAME" ]]; then
  DEVICE_HOSTNAME=HomeBridge
fi

printf "%s\n" "Setting device hostname to: $DEVICE_HOSTNAME"

curl -X PATCH --header "Content-Type:application/json" \
    --data '{"network": {"hostname": "'"${DEVICE_HOSTNAME}"'"}}' \
    "$BALENA_SUPERVISOR_ADDRESS/v1/device/host-config?apikey=$BALENA_SUPERVISOR_API_KEY"

# Mount the backup destination. TODO: make this automount
mkdir -p /mnt/storage
mount -t cifs //PecanPi.lan/Storage/Homebridge /mnt/storage -o rw,username=Guest,password=
# Put the homebridge directory in persistent mem
mkdir -p /data/homebridge/
cp /usr/src/*.json /data/homebridge/

echo Starting homebridge
exec homebridge --user-storage-path /data/homebridge/ > /var/log/homebridge.log
