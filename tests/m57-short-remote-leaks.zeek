# Needs perftools support.
#
# @TEST-GROUP: leaks
#
# @TEST-REQUIRES: bro --help 2>&1 | grep -q mem-leaks
# 
# @TEST-EXEC: btest-bg-run sender "cat $TRACES/2009-M57-day11-21.trace.gz | gunzip | HEAP_CHECK_DUMP_DIRECTORY=. HEAPCHECK=local bro -r - -m --pseudo-realtime=10000 ../sender.bro %INPUT"
# @TEST-EXEC: sleep 1
# @TEST-EXEC: btest-bg-run receiver HEAP_CHECK_DUMP_DIRECTORY=. HEAPCHECK=local bro -m %INPUT ../receiver.bro
# @TEST-EXEC: btest-bg-wait 30
# 
# Just make sure there's something in the output to confirm the termination
# condition works and remote logging was actually employed.
# 
# @TEST-EXEC: test -e receiver/dns.log
# @TEST-EXEC: test `cat receiver/dns.log | wc -l` -ge 100
# 
# @TEST-EXEC: $SCRIPTS/perftools-adapt-paths .stderr

#####

@TEST-START-FILE sender.bro

@load frameworks/communication/listen

redef Log::enable_local_logging = F;

event remote_connection_established(p: event_peer)
	{
	print "peer connected";
	}

event remote_connection_closed(p: event_peer)
	{
	print "peer terminated";
	terminate();
	}

@TEST-END-FILE

@TEST-START-FILE receiver.bro

redef Communication::nodes += {
    ["foo"] = [$host = 127.0.0.1, $connect=T, $request_logs=T,
	          $events = /DNS::log_dns/]
};

event remote_connection_established(p: event_peer)
	{
	print "connected to peer";
	}

global dns_log_count = 0;

event DNS::log_dns(rec: DNS::Info)
	{
	++dns_log_count;
	print fmt("dns log entry #%s", dns_log_count);

	if ( dns_log_count > 101 )
		{
		print "terminating";
		terminate();
		}
	}

@TEST-END-FILE
