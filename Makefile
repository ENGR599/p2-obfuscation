CUR_DIR         := project_2

RTL_DIR         := rtl/
CONSTRAINTS     := master.xdc
TCL             := tcl/design_build.tcl

VIVADO          := /tools/Xilinx/Vivado/2023.2/bin/vivado

BASYS3          := xc7a35tcpg236-1

BLINK_TOP       := blink
STATE_TOP       := p3

blink_build: blink_project_setup.tcl
	@mkdir build
	@mkdir build/dcps
	@mkdir build/reports
	$(VIVADO) -mode tcl -source $(TCL) -nojou -nolog -notrace

blink_project_setup.tcl:
	@echo "set_part $(BASYS3)" >> blink_project_setup.tcl
	@echo "set build_dir build" >> blink_project_setup.tcl
	@echo "set dcp_dir build/dcps" >> blink_project_setup.tcl
	@echo "set rep_dir build/reports" >> blink_project_setup.tcl
	@echo "set rtl [glob -directory $(RTL_DIR) *]" >> blink_project_setup.tcl
	@echo "read_xdc $(CONSTRAINTS)" >> blink_project_setup.tcl
	@echo "set top_design $(BLINK_TOP)" >> blink_project_setup.tcl
	@echo "set proj_name $(CUR_DIR)" >> blink_project_setup.tcl
	@mv blink_project_setup.tcl ./tcl/

clean:
	@rm -rf build
