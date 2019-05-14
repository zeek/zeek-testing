# Needs perftools support.
#
# @TEST-GROUP: leaks
# @TEST-PORT: BROKER_PORT
#
# @TEST-REQUIRES: zeek --help 2>&1 | grep -q mem-leaks
#
# @TEST-EXEC: HEAP_CHECK_DUMP_DIRECTORY=. HEAPCHECK=local btest-bg-run sender "cat $TRACES/2009-M57-day11-21.trace.gz | gunzip | ( zeek --pseudo-realtime=10000 -r - -m ../sender.zeek %INPUT ; dd of=/dev/null )"
# @TEST-EXEC: sleep 1
# @TEST-EXEC: HEAP_CHECK_DUMP_DIRECTORY=. HEAPCHECK=local btest-bg-run receiver "zeek -m %INPUT ../receiver.zeek"
# @TEST-EXEC: btest-bg-wait 90
# 
# Just make sure there's something in the output to confirm the termination
# condition works and remote logging was actually employed.
# 
# @TEST-EXEC: test -e receiver/dns.log
# @TEST-EXEC: test `cat receiver/dns.log | wc -l` -ge 100
# 
# @TEST-EXEC: $SCRIPTS/perftools-adapt-paths .stderr

#####

@TEST-START-FILE sender.zeek

redef Log::enable_local_logging = F;

event zeek_init()
	{
	suspend_processing();
	Broker::auto_publish("test", DNS::log_dns);
	Broker::listen("127.0.0.1", to_port(getenv("BROKER_PORT")));
	}

event Broker::peer_added(endpoint: Broker::EndpointInfo, msg: string)
	{
	print "peer connected";
	continue_processing();
	}

event Broker::peer_lost(endpoint: Broker::EndpointInfo, msg: string)
	{
	print "peer terminated";
	terminate();
	}

global dns_log_count = 0;

event DNS::log_dns(rec: DNS::Info)
	{
	++dns_log_count;
	print fmt("dns log entry #%s", dns_log_count);
	}

@TEST-END-FILE

@TEST-START-FILE receiver.zeek

event zeek_init()
	{
	Broker::subscribe("test");
	Broker::subscribe(Broker::default_log_topic_prefix);
	Broker::peer("127.0.0.1", to_port(getenv("BROKER_PORT")));
	}

event Broker::peer_added(endpoint: Broker::EndpointInfo, msg: string)
	{
	print "connected to peer";
	}

event Broker::peer_lost(endpoint: Broker::EndpointInfo, msg: string)
	{
	terminate();
	}

event die()
	{
	print "terminated";
	terminate();
	}

global dns_log_count = 0;

event DNS::log_dns(rec: DNS::Info)
	{
	++dns_log_count;
	print fmt("dns log entry #%s", dns_log_count);

	if ( dns_log_count == 101 )
		{
		print "terminating";
		Broker::flush_logs();
		schedule 1sec { die() };
		}
	}

@TEST-END-FILE
