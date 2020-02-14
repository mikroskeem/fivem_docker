#!/bin/sh
set -e

available_builds="$(curl -s https://runtime.fivem.net/artifacts/fivem/build_proot_linux/master/ | grep '<a *class="panel-block.*"*href=".*fx\.tar\.xz".*>$')"

dirname "$(printf '%s' "${available_builds}" | sed 's/.\+href="\(.\+\)"\s\+style.*>/\1/g' | head -1 | tail -c +3)"
