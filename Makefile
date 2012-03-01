
DIAG=diag.log
BTEST=../../../aux/btest/btest

all: update-traces cleanup btest-verbose coverage

btest-verbose:
	@$(BTEST) -f $(DIAG)

brief: update-traces cleanup btest-brief coverage

btest-brief:
	@$(BTEST) -b -f $(DIAG)

coverage:
	@../../scripts/coverage-calc ".tmp/script-coverage*" coverage.log `pwd`/../../../scripts

update-traces:
	@../scripts/update-traces Traces

cleanup:
	@rm -f $(DIAG)
	@rm -f .tmp/script-coverage*

.PHONY: all btest-verbose brief btest-brief coverage update-traces cleanup
