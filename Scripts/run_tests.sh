#!/usr/bin/env bash

set -Eeuo pipefail

# CONSTANTS

readonly SCRIPT_ABS_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd -P)"
readonly SWIFT_BUILD_DIR_NAME=".build"

# FUNCTIONS

function package_clean() {
    echo "Cleaning up SPM build artifacts"
    swift package clean
}

function swift_test() {
    swift test
}

# ENTRY POINT

package_clean
swift_test
