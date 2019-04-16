# @TEST-EXEC: cat $TRACES/2009-M57-day11-18.trace.gz | gunzip | bro -r - %INPUT
# @TEST-EXEC: TEST_DIFF_CANONIFIER=${SCRIPTS_LOCAL}/diff-canonify-special-cases $SCRIPTS/diff-all '*.log'
#
# @TEST-MEASURE-TIME

@load test-all-policy
@load testing-setup
