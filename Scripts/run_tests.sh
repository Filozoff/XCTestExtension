#!/usr/bin/env bash

set -Eeuo pipefail

source "$(dirname "$0")"/common.sh

# CONSTANTS

readonly SCRIPT_ABS_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd -P)"

# FUNCTIONS

function package_clean() {
    echo "Cleaning up SPM build artifacts"
    swift package clean
}

function swift_test() {
    swift test 2>&1 | xcpretty
}

# ENTRY POINT

package_clean
swift_test
