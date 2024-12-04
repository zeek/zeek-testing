# Does not work with spicy SSL, due to it raising errors when connection ends in the middle of a
# message.
# @TEST-REQUIRES: ! grep -q "#define ENABLE_SPICY_SSL" $BUILD/zeek-config.h

# @TEST-REQUIRES: have-spicy
# @TEST-EXEC: cat $TRACES/CTU-SME-11-Experiment-VM-Microsoft-Windows7AD-1-malicious-filtered.pcap.gz | gunzip | zeek -r - %INPUT
# @TEST-EXEC: $SCRIPTS/diff-all '*.log'
#
# @TEST-MEASURE-TIME

@load test-all-policy
@load testing-setup
