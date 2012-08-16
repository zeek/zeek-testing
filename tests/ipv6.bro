# @TEST-EXEC: cat $TRACES/ipv6.trace.gz | gunzip | bro -r - %INPUT
# @TEST-EXEC: $SCRIPTS/diff-all '*.log'

@load test-all-policy
@load testing-setup
