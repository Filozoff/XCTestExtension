build_dir := ./.build
derived_data_dir := $(build_dir)/derived_data
destination_device := platform=iOS Simulator,name=iPhone 16
scheme := XCTestExtension
scripts_dir := ./Scripts
test_coverage_report_dir := $(build_dir)/coverage_reports
test_output_dir := $(build_dir)/test_output
test_targets := XCTestExtensionTests

test:
	echo "Testing..."
	sh "$(scripts_dir)/run_tests.sh" \
		--derived-data-path "$(derived_data_dir)" \
		--device "$(destination_device)" \
		--output "$(test_output_dir)" \
		--scheme "$(scheme)"

code-coverage:
	echo "Gathering code coverage..."
	sh "$(scripts_dir)/code_coverage.sh" \
		--derived-data-path "$(derived_data_dir)" \
		--output "$(test_coverage_report_dir)" \
		--test-targets $(test_targets)
