#!/usr/bin/env bash

set -Eeuo pipefail

source "$(dirname "$0")"/common.sh

# FUNCTIONS

function main() {
    local profdata
    local ignore_regex
    local test_targets

    IFS=',' read -r -a test_targets <<< "$TEST_TARGETS"
    profdata=$(find "$DERIVED_DATA_PATH" -name "Coverage.profdata")
    ignore_regex=".build|Tests"

    mkdir -p "$OUTPUT_DIR"

    for test_target in "${test_targets[@]}"; do
        local coverage_report_path
        local binary_path
        local xctest_path

        coverage_report_path="$OUTPUT_DIR/$test_target.lcov"

        printf '\n\nPreparing code coverage for %s...\n' "$test_target"

        xctest_path=$(find "$DERIVED_DATA_PATH" -name "$test_target.xctest")
        if [[ -z "$xctest_path" ]]; then
            echo "Error: XCTest bundle not found for target '$test_target'"
            exit 1
        fi

        binary_path="$xctest_path/$test_target"

        # Print coverage
        xcrun llvm-cov report "$binary_path" \
            -ignore-filename-regex="$ignore_regex" \
            -instr-profile="$profdata" \
            -use-color

        # Export coverage
        xcrun llvm-cov show "$binary_path" \
            -ignore-filename-regex="$ignore_regex" \
            -instr-profile="$profdata" \
            > "$coverage_report_path"
    done
}

# ENTRY POINT

while [[ $# -gt 0 ]]; do
    case $1 in
    -p| --derived-data-path)
        DERIVED_DATA_PATH=${2}
        shift 2
    ;;
    -o| --output)
        OUTPUT_DIR=${2}
        shift 2
    ;;
    -t| --test-targets)
        TEST_TARGETS=${2}
        shift 2
    ;;
    *)
        echo "Unknown argument: '${1}'"
        exit 1
    ;;
    esac
done

main
