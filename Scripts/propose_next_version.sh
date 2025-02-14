#!/usr/bin/env bash

set -Eeuo pipefail
trap 'error_handler ${FUNCNAME-main context} ${LINENO} $?' ERR

# CONSTANTS

readonly CALL_DIR="$PWD"
readonly SCRIPT_NAME=$(basename -s ".sh" "$0")
readonly TEMP_DIRECTORY="tmp$RANDOM"

# FUNCTIONS

function error_handler() {
    echo "$SCRIPT_NAME.sh: in '$1()', line $2: error: $3"
    reset
    exit 1
}

# Scans git history, starting from active branch HEAD, to find latest pushed tag version.
# Version has to be represented in plain semver format, e.g. '1.0.1'.
# Modify regex for different version patter scan.
function get_current_version_tag_name() {
    local current_branch_name
    local last_reference_tag_name

    current_branch_name=$(git rev-parse --abbrev-ref HEAD)
    last_reference_tag_name=$(git tag --merged="$current_branch_name" --list --sort=-version:refname "[0-9]*.[0-9]*.[0-9]*" | head -n 1)
    cat <<< "$last_reference_tag_name"
}

function build_public_interface() {
    xcodebuild \
        -archivePath "$ARCHIVE_PATH" \
        -derivedDataPath "$DERIVED_DATA_PATH" \
        -destination "$DESTINATION" \
        -scheme "$SCHEME" \
        BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
        SKIP_INSTALL=NO \
        OTHER_SWIFT_FLAGS="-no-verify-emitted-module-interface" \
        archive | xcbeautify
}

function make_public_interface() {
    local package_products
    local packages_public_interface_path

    if ! { error=$(build_public_interface 2>&1); }; then
        echo "$error"
        echo "Cannot complete the build due to the compile error. Check logs above."
        exit 1
    fi

    packages_public_interface_path="./$DERIVED_DATA_PATH/public_interface.swiftinterface"
    rm -rf "$packages_public_interface_path"

    package_products=$(swift_package_products)

    for package_product in $package_products
    do
        cat "$(find "./$DERIVED_DATA_PATH/" -name "${package_product}.swiftinterface")" >> "$packages_public_interface_path"
    done

    MAKE_PUBLIC_INTERFACE="$packages_public_interface_path"
}

function swift_package_products() {
    swift package describe --type json | jq -r '.products.[].name'
}

function main() {
    local current_branch_name
    local current_public_interface_path
    local has_breaking_changes
    local has_additive_changes
    local temp_version_directory
    local version_public_interface_path
    local version_tag

    local -r semantic_version_regex='([0-9]+).([0-9]+).([0-9]+)'

    current_branch_name=$(git rev-parse --abbrev-ref HEAD)
    version_tag=$(get_current_version_tag_name)
    temp_version_directory="$TEMP_DIRECTORY"

    # Clean up derived data directory to prevent of any cached files usage.
    rm -rf "$DERIVED_DATA_PATH"

    # Copy change tagged with given version tag to 'tmp{random}' directory by using clone of local repo and checkouting to version tag.
    git clone "$CALL_DIR" "$temp_version_directory" --quiet
    cd "$temp_version_directory"
    git checkout "tags/$version_tag" --force --quiet --recurse-submodules

    # Get public interface from the change marked with version tag.
    make_public_interface
    version_public_interface_path="$temp_version_directory/$MAKE_PUBLIC_INTERFACE"

    # Go back to the project root.
    cd "$CALL_DIR"

    # Get public interface from the current change.
    make_public_interface
    current_public_interface_path="$MAKE_PUBLIC_INTERFACE"

    # Make public interfaces diffs
    has_breaking_changes=$(diff "$version_public_interface_path" "$current_public_interface_path" | grep -c -i "^<" || true)
    has_additive_changes=$(diff "$version_public_interface_path" "$current_public_interface_path" | grep -c -i "^>" || true)

    # Create version based on diff output
    if [[ ! $version_tag =~ $semantic_version_regex ]]; then
        cat <<< "$version_tag"
    else
        local major="${BASH_REMATCH[1]}"
        local minor="${BASH_REMATCH[2]}"
        local patch="${BASH_REMATCH[3]}"

        if [[ $has_breaking_changes -gt 0 ]]; then
            major=$((major+1))
            minor=0
            patch=0
        elif [[ $has_additive_changes -gt 0 ]]; then
            minor=$((minor+1))
            patch=0
        else
            patch=$((patch+1))
        fi

        cat <<< "${major}.${minor}.${patch}"
    fi

    reset
}

function reset() {
    cd "$CALL_DIR"
    rm -rf "$TEMP_DIRECTORY" > /dev/null
}

# ENTRY POINT

while [[ $# -gt 0 ]]; do
    case $1 in
        # Device for which public interface is created. Use value supported by `-destination` argument in `xcodebuild archive`.
        # E.g. `platform=iOS Simulator,name=iPhone 14,OS=17.0`.
        -d|--device)
            DESTINATION=${2}
            shift 2
        ;;
        # Derived data path (optional).
        -r|--derived-data-path)
            DERIVED_DATA_PATH=${2}
            ARCHIVE_PATH="$DERIVED_DATA_PATH/archive"
            shift 2
        ;;
        # Package scheme name. For packages with multiple targets, it may be required to add `-Package` suffix.
        # Example: your package is named `ClientService` and has two targets inside: `ClientServiceDTOs` and `ClientServiceAPI`.
        # Then, your target would be `ClientService-Package`.
        -s|--scheme)
            SCHEME=${2}
            shift 2
        ;;
        *)
            echo "Unknown parameter: '${1}'. Please use supported parameters: '-d|--device', '-r|--derived-data-path', '-s|--scheme'."
            exit 1
        ;;
    esac
done

main
