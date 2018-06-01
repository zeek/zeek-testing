
DIAG=diag.log
BTEST=../../../aux/btest/btest -j 3
SCRIPT_COV=.tmp/script-coverage

all: update-traces cleanup btest-verbose coverage

btest-verbose:
	@$(BTEST) -f $(DIAG)

brief: update-traces cleanup btest-brief coverage

btest-brief:
	@$(BTEST) -b -f $(DIAG)

coverage:
	@../../scripts/coverage-calc "$(SCRIPT_COV)/*" coverage.log `pwd`/../../../scripts

update-timing:
	@$(BTEST) -T

update-traces:
	@../scripts/update-traces Traces

cleanup:
	@rm -f $(DIAG)
	@rm -rf $(SCRIPT_COV)*

.PHONY: all btest-verbose brief btest-brief coverage update-traces cleanup
