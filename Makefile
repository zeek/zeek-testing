
DIAG=diag.log
BTEST=../../../aux/btest/btest

all: update-traces cleanup
	@$(BTEST) -f $(DIAG)
	@../../scripts/coverage-calc ".tmp/script-coverage" coverage.log `pwd`/../../../scripts

brief: update-traces cleanup
	@rm -f $(DIAG)
	@$(BTEST) -b -f $(DIAG)
	@../../scripts/coverage-calc ".tmp/script-coverage" coverage.log `pwd`/../../../scripts

update-traces:
	../scripts/update-traces Traces

cleanup:
	@rm -f $(DIAG)
	@rm -f .tmp/script-coverage
