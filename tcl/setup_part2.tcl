
set MYFILE [file normalize [info script]]
set MYDIR  [file dirname ${MYFILE}]
set BASEDIR ${MYDIR}/../
set SRCDIR ${MYDIR}/../vsrc/
set TESTDIR ${MYDIR}/../vtests/
set XDCDIR ${MYDIR}/../xdc/

# create project
create_project -force vivado_part2.xpr ${BASEDIR}/vivado_part2 -part xc7a35ticpg236-1L
#create_project -force vivado_part3.xpr ${BASEDIR}/vivado_part3 -part xc7a35ticpg236-1L

# add source files
add_files [glob ${SRCDIR}/*.sv]

#set the top for synthesis
set_property top part2 [current_fileset]
#set_property top part3 [current_fileset]

# add constraints
add_files -fileset constrs_1 ${XDCDIR}/Basys3_Master_part2.xdc
#add_files -fileset constrs_1 ${XDCDIR}/Basys3_Master_part3.xdc

# set all *.sv to SystemVerilog mode
set_property file_type SystemVerilog [get_files *.sv]
#set_property file_type SystemVerilog [get_files *.v]

#make sims run longer by default
set_property -name {xsim.simulate.runtime} -value {1000us} -objects [get_filesets sim_*]
