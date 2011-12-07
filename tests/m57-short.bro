# @TEST-EXEC: cat $TRACES/2009-M57-day11-21.trace.gz | gunzip | bro -r - %INPUT
# @TEST-EXEC: $SCRIPTS/diff-all '*.log'

@load testing-setup
@load test-all-policy

