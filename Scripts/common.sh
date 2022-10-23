#!/usr/bin/env bash

set -Eeuo pipefail

# FUNCTIONS

function lowercase {
    echo "$1" | awk '{print tolower($0)}'
}

function swift_package_name() {
    swift package describe | awk '/Name:/ { print $2; exit; }'
}
