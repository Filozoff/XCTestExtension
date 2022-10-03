#!/usr/bin/env bash

set -Eeuo pipefail

# FUNCTIONS

function swift_package_name() {
    swift package describe | awk '/Name:/ { print $2; exit; }'
}
