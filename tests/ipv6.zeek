# @TEST-EXEC: cat $TRACES/ipv6.trace.gz | gunzip | zeek -r - %INPUT
# @TEST-EXEC: $SCRIPTS/diff-all '*.log'
#
# @TEST-MEASURE-TIME

@load test-all-policy
@load testing-setup
