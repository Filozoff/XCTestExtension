#!/usr/bin/env bash

set -Eeuo pipefail

source "$(dirname "$0")"/common.sh

# FUNCTIONS

function main() {
    local -r docs_index_path="$OUTPUT_DIR/index.html"
    local -r package_path_element=$(lowercase "$SCHEME")
    local docc_archive_path

    echo "Creating doccarchive..."
    xcodebuild \
        -derivedDataPath "$DERIVED_DATA_PATH" \
        -destination "$DESTINATION" \
        -scheme "$SCHEME" \
        docbuild | xcbeautify
    echo "Done!"

    docc_archive_path=$(find "$DERIVED_DATA_PATH" -name "$SCHEME.doccarchive")
    echo "DocC archive found at path '$docc_archive_path'."

    echo "Converting doccarchive to static HTML..."
    "$(xcrun --find docc)" process-archive transform-for-static-hosting "$docc_archive_path" \
        --hosting-base-path "$HOSTING_BASE_PATH" \
        --output-path "$OUTPUT_DIR"

    echo "<script>window.location.href += \"/documentation/$package_path_element\"</script>" > "$docs_index_path"
    echo "Done!"
}

# ENTRY POINT

while [[ $# -gt 0 ]]; do
    case $1 in
    -b| --hosting-base-path)
        HOSTING_BASE_PATH=${2}
        shift 2
    ;;
    -d| --device)
        DESTINATION=${2}
        shift 2
    ;;
    -p| --derived-data-path)
        DERIVED_DATA_PATH=${2}
        shift 2
    ;;
    -o| --output)
        OUTPUT_DIR=${2}
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

main
