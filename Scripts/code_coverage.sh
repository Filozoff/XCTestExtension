#!/bin/sh

set -Eeuo pipefail

source "$(dirname "$0")"/common.sh

# CONSTANTS

readonly COVERAGE_DIR_NAME=".coverage"
readonly BIN_PATH="$(swift build --show-bin-path)"
readonly SWIFT_BUILD_DIR_NAME=".build"
readonly PROFDATA_PATH="$SWIFT_BUILD_DIR_NAME/debug/codecov/default.profdata"
readonly XCTEST_PATH="$(find ${BIN_PATH} -name '*.xctest')"

COV_BIN=$XCTEST_PATH

# PRECONDITION

if [[ "$OSTYPE" == "darwin"* ]]; then
    f="$(basename $XCTEST_PATH .xctest)"
    COV_BIN="${COV_BIN}/Contents/MacOS/$f"
fi

function print_code_coverage() {
    xcrun llvm-cov report \
        "${COV_BIN}" \
        -instr-profile="$PROFDATA_PATH" \
        -ignore-filename-regex=".build|Tests" \
        -use-color
}

function export_code_coverage() {
    local -r package_name=$(swift_package_name)
    local -r bin_path="$SWIFT_BUILD_DIR_NAME/debug/${package_name}PackageTests.xctest/Contents/MacOS/${package_name}PackageTests"
    local -r coverage_report_path="$COVERAGE_DIR_NAME/$package_name.lcov"

    mkdir -p "$COVERAGE_DIR_NAME"

    xcrun llvm-cov export \
        -format="lcov" "$bin_path" \
        -instr-profile="$PROFDATA_PATH" \
        -ignore-filename-regex=".build|Tests" \
        > "$coverage_report_path"
}

# ENTRY POINT

print_code_coverage
export_code_coverage
