SHELL 		:= /bin/bash

#https://stackoverflow.com/questions/18136918/how-to-get-current-relative-directory-of-your-makefile
BASE_DIR 	:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))

NUM_CORES 	:= 2

.PHONY:  setup
setup:  vivado_part2/vivado_part2.xpr vivado_part3/vivado_part3.xpr
	python3 -m pip install pycryptodome --user
	python3 -m pip install pyserial --user

vivado_part2/vivado_part2.xpr: tcl/setup_part2.tcl
	set -o pipefail && vivado -mode batch -source tcl/setup_part2.tcl | tee setup.log

vivado_part3/vivado_part3.xpr: tcl/setup_part3.tcl
	set -o pipefail && vivado -mode batch -source tcl/setup_part3.tcl | tee setup.log

.PHONY: bitstream
bitstream_part2:  vivado_part2/vivado_part2.xpr tcl/impl_part2.tcl
	set -o pipefail && vivado -mode batch -source tcl/impl_part2.tcl -tclargs ${BASE_DIR} ${NUM_CORES}

bitstream_part3:  vivado_part3/vivado_part3.xpr tcl/impl_part3.tcl
	set -o pipefail && vivado -mode batch -source tcl/impl_part3.tcl -tclargs ${BASE_DIR} ${NUM_CORES}

.PHONY: clean
clean:
	rm -f *.jou *.log *.wdb *.pb *.str *~
	rm -rf xsim.dir .Xil axsim.sh
	rm -rf *_sim.sh
	rm -rf output.txt
	rm -rf *.bz2
	rm -rf *.xpr *.sim *.runs *.hw *.cache *.ip_user_files 
	rm -rf vivado_part2
	rm -rf vivado_part3
