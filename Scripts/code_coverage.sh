#!/usr/bin/env bash

set -Eeuo pipefail

source "$(dirname "$0")"/common.sh

# CONSTANTS

readonly COVERAGE_DIR_NAME=".coverage"
readonly SWIFT_BUILD_DIR_NAME=".build"
readonly PACKAGE_NAME=$(swift_package_name)
readonly PROFDATA_PATH="${SWIFT_BUILD_DIR_NAME}/debug/codecov/default.profdata"
readonly BIN_PATH="${SWIFT_BUILD_DIR_NAME}/debug/${PACKAGE_NAME}PackageTests.xctest/Contents/MacOS/${PACKAGE_NAME}PackageTests"

# FUNCTIONS

function print_code_coverage() {
    xcrun llvm-cov report \
        "$BIN_PATH" \
        -instr-profile="$PROFDATA_PATH" \
        -ignore-filename-regex=".build|Tests" \
        -use-color
}

function export_code_coverage() {
    local -r coverage_report_path="$COVERAGE_DIR_NAME/$PACKAGE_NAME.lcov"

    mkdir -p "$COVERAGE_DIR_NAME"

    xcrun llvm-cov export \
        -format="lcov" "$BIN_PATH" \
        -instr-profile="$PROFDATA_PATH" \
        -ignore-filename-regex=".build|Tests" \
        > "$coverage_report_path"
}

# ENTRY POINT

print_code_coverage
export_code_coverage
