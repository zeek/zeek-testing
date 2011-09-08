@TEST-EXEC: zcat $TRACES/2009-M57-day11-18.trace.gz | bro -r - test-all-policy
@TEST-EXEC: $SCRIPTS/diff-all *.log
