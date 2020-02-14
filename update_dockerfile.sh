#!/bin/sh

current_version="$(cat Dockerfile | grep '^ENV FIVEM_BUILD=' | sed '/^ENV FIVEM_BUILD=/s/.*=\(.\+\)$/\1/')"
latest_version="$(./get_latest_build.sh)"

# Normalize NUM-HASH into something more comparable
current_version_norm="$(printf '%s' "${current_version}" | sed 's/-.*//')"
latest_version_norm="$(printf '%s' "${latest_version}" | sed 's/-.*//')"

echo ">>> Current build in Dockerfile: ${current_version}"
echo ">>> Latest version available from build server: ${latest_version}"

if [ "${latest_version_norm}" -gt "${current_version_norm}" ]; then
    echo ">>> ... Which means it's time for an update!"
    sed -i '/^ENV FIVEM_BUILD=/s/=.\+$/='"${latest_version}"'/' Dockerfile
else
    echo ">>> Up to date"
fi
