# Needs perftools support.
#
# @TEST-GROUP: leaks
#
# @TEST-REQUIRES: bro --help 2>&1 | grep -q mem-leaks
# 
# @TEST-EXEC: btest-bg-run sender "cat $TRACES/2009-M57-day11-21.trace.gz | gunzip | HEAP_CHECK_DUMP_DIRECTORY=. HEAPCHECK=local bro -r - -m --pseudo-realtime=10000 ../sender.bro"
# @TEST-EXEC: sleep 1
# @TEST-EXEC: btest-bg-run receiver HEAP_CHECK_DUMP_DIRECTORY=. HEAPCHECK=local bro -m %INPUT ../receiver.bro
# @TEST-EXEC: sleep 1
# @TEST-EXEC: btest-bg-wait -k 10
# 
# Just make sure there's something in the output. Because we abort it rather
# randomly, it unpredictable how much gets written.
# 
# @TEST-EXEC: test -e receiver/dns.log
# @TEST-EXEC: test `cat receiver/dns.log | wc -l` -ge 100
# 
# @TEST-EXEC: $SCRIPTS/perftools-adapt-paths .stderr

#####

@TEST-START-FILE sender.bro

@load frameworks/communication/listen

redef Log::enable_local_logging = F;

@TEST-END-FILE

@TEST-START-FILE receiver.bro

redef Communication::nodes += {
    ["foo"] = [$host = 127.0.0.1, $connect=T, $request_logs=T]
};

@TEST-END-FILE
