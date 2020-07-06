#!/bin/sh
set -e

CONFIG_FILE="/data/server.cfg"

# Check if license key is set
if [ -z "${FIVEM_LICENSE_KEY}" ] || [ "${FIVEM_LICENSE_KEY}" = "unset" ]; then
    echo ">>> FiveM license key is not set, exiting!"
    exit 1
fi

# Check if server configuration is present
if [ ! -f "${CONFIG_FILE}" ]; then
    echo ">>> Server configuration file '${CONFIG_FILE}' is not present, exiting!"
    exit 1
fi

# Check if resources directory exists
if [ ! -d "/data/resources" ]; then
    echo ">>> /data/resources directory does not exist"
    exit 1
fi

exec sh /home/fivem/server/run.sh +sv_licenseKey "${FIVEM_LICENSE_KEY}" "${@}" +exec "${CONFIG_FILE}"
