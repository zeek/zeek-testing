
DIAG=diag.log
BTEST=../../../auxil/btest/btest -j 3
SCRIPT_COV=.tmp/script-coverage

all: update-traces cleanup btest-verbose coverage
leaks: update-traces cleanup btest-verbose-leaks coverage

btest-verbose:
	@$(BTEST) -f $(DIAG)

btest-verbose-leaks:
	@$(BTEST) -f $(DIAG) -g leaks

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
