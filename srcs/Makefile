# ====================================================================
# Makefile for UVM Compilation and Regression using Synopsys VCS
# ====================================================================

# --- Variables ---
VCS       = vcs
SIM       = ./simv
TB_TOP    = axi_tb_top.sv
VCS_OPTS  = -sverilog -full64 -ntb_opts uvm -timescale=1ns/1ns
COV_OPTS  = -cm line+cond+fsm+tgl+branch+assert
COV_DIR   = regression.vdb

# Default run arguments
TESTNAME  ?= base_test
VERBOSITY ?= UVM_HIGH

# List of tests to run in regression (space-separated)
TEST_LIST = base_test rewr_test rewr_valid_test write_in_read_only read_in_write_only

# --- Targets ---
.PHONY: help compile run regression clean report $(TEST_LIST)

help:
	@echo "Usage:"
	@echo "  make compile            - Compiles the SV/UVM testbench with coverage"
	@echo "  make run TESTNAME=test1 - Runs a single test with coverage"
	@echo "  make regression         - Compiles, runs all tests, and merges coverage"
	@echo "  make report             - Generates the HTML coverage report manually"
	@echo "  make clean              - Removes simulation artifacts"

# 1. Compilation
compile:
	$(VCS) $(VCS_OPTS) $(COV_OPTS) -cm_dir $(COV_DIR) $(TB_TOP) -o simv

# 2. Run a single test
run: compile
	$(SIM) +UVM_TESTNAME=$(TESTNAME) +UVM_VERBOSITY=$(VERBOSITY) $(COV_OPTS) -cm_dir $(COV_DIR) -cm_name $(TESTNAME) -l $(TESTNAME)_sim.log

# 3. Run regression (iterates through TEST_LIST, then generates report)
regression: compile $(TEST_LIST) report

# Execution rule for the regression tests
$(TEST_LIST):
	@echo "========================================"
	@echo "Running UVM Test: $@"
	@echo "========================================"
	$(SIM) +UVM_TESTNAME=$@ +UVM_VERBOSITY=$(VERBOSITY) $(COV_OPTS) -cm_dir $(COV_DIR) -cm_name $@ -l $@_regr.log

# 4. Generate Coverage Report
report:
	@echo "========================================"
	@echo "Generating Cumulative Coverage Report..."
	@echo "========================================"
	urg -dir $(COV_DIR) -report urgReport
	@echo "Report generated! Open urgReport/dashboard.html in a browser."

# 5. Clean simulation artifacts
clean:
	rm -rf simv csrc simv.daidir *.log *.key vc_hdrs.h DVEfiles *.vpd *.vdb urgReport ucli.key .vlogansetup.args $(COV_DIR)
