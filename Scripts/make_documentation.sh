#!/usr/bin/env bash

set -Eeuo pipefail

source "$(dirname "$0")"/common.sh

# CONSTANTS

readonly DOCS_PATH="./docs"
readonly PACKAGE_NAME=$(swift_package_name)

# FUNCTIONS

function create_documentation() {
    local -r docs_index_path="$DOCS_PATH/index.html"
    local -r package_path_element=$(lowercase "$PACKAGE_NAME")

    echo "$package_path_element"
    swift package \
        --allow-writing-to-directory "$DOCS_PATH" \
        generate-documentation \
        --disable-indexing \
        --hosting-base-path "$PACKAGE_NAME" \
        --include-extended-types \
        --output-path "$DOCS_PATH" \
        --target "$PACKAGE_NAME" \
        --transform-for-static-hosting

    echo "<script>window.location.href += \"/documentation/$package_path_element\"</script>" > "$docs_index_path"
}

# ENTRY POINT

create_documentation
