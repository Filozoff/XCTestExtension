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
    xcodebuild \
        -default-test-execution-time-allowance 5 \
        -derivedDataPath "${DERIVED_DATA_PATH}" \
        -destination "${DESTINATION}" \
        -enableCodeCoverage "YES" \
        -jobs 4 \
        -parallel-testing-enabled "YES" \
        -resultBundlePath "${OUTPUT}" \
        -scheme "${SCHEME}" \
        -test-timeouts-enabled "YES" \
        test | xcbeautify
}

# ENTRY POINT

while [[ $# -gt 0 ]]; do
    case $1 in
    -d| --device)
        DESTINATION=${2}
        shift 2
    ;;
    -o| --output)
        OUTPUT=${2}
        shift 2
    ;;
    -p| --derived-data-path)
        DERIVED_DATA_PATH=${2}
        shift 2
    ;;
    -s| --scheme)
        SCHEME=${2}
        shift 2
    ;;
    *)
        echo "Unknown argument: '${1}'"
        exit 1
    ;;
    esac
done

package_clean
swift_test
