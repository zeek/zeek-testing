
DIAG=diag.log
BTEST=../../../aux/btest/btest

all: update-traces
	@rm -f $(DIAG)
	@rm -f .tmp/script-coverage
	@$(BTEST) -f $(DIAG)
	@../../scripts/coverage-calc ".tmp/script-coverage" coverage.log `pwd`

brief: update-traces
	@rm -f $(DIAG)
	@$(BTEST) -b -f $(DIAG)

update-traces:
	../scripts/update-traces Traces
