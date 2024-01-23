# Procedures used to generate a bitstream

proc synthesize {dcp_directory report_directory project_name} {
    puts "Synthesize design"
    synth_design -top $project_name
    write_checkpoint -force $dcp_directory/post_synth.dcp
    report_timing_summary -file $report_directory/post_synth_timing_summary.rpt
    report_power -file $report_directory/post_synth_power.rpt
    write_verilog -force $dcp_directory/post_synth_netlist.v
}

proc place {dcp_directory report_directory} {
    puts "Optimize and place design"
    opt_design
    place_design
    phys_opt_design
    write_checkpoint -force $dcp_directory/post_place.dcp
    report_timing_summary -file $report_directory/post_place_timing_summary.rpt
}

proc route {dcp_directory report_directory build_directory} {
    puts "Route design"
    route_design
    write_checkpoint -force $dcp_directory/post_route.dcp
    report_timing_summary -file $report_directory/post_route_timing_summary.rpt
    report_timing -sort_by group -max_paths 100 -path_type summary -file $report_directory/post_route_timing.rpt
    report_clock_utilization -file $report_directory/clock_util.rpt
    report_utilization -file $report_directory/post_route_util.rpt
    report_power -file $report_directory/post_route_power.rpt
    report_drc -file $report_directory/post_imp_drc.rpt
    write_verilog -force $build_directory/post_route_netlist.v
    write_xdc -no_fixed_only -force $build_directory/post_route_netlist.xdc
}

proc generate_bitstream {build_directory project_name} {
    puts "Generate bitstream"
    write_sdf -force $build_directory/$project_name.sdf
    write_bitstream -force $build_directory/$project_name.bit
}

source ./tcl/blink_project_setup.tcl

foreach rtl_file $rtl {
    set split_file [split $rtl_file .]
    set file_type [lindex $split_file 1]

    if { [string equal $file_type "sv"] } {
        puts "Importing: $rtl_file"
        read_verilog -sv $rtl_file
    } elseif { [string equal $file_type "v"] } {
        puts "Importing: $rtl_file"
        read_verilog $rtl_file
    } elseif { [string equal $file_type "vhd"] } {
        puts "Importing: $rtl_file"
        read_vhdl $rtl_file
    } else {
        puts "$rtl_file is not a RTL file."
    }
}

synthesize $dcp_dir $rep_dir $top_design
place $dcp_dir $rep_dir
route $dcp_dir $rep_dir $build_dir
generate_bitstream $build_dir $proj_name

exit
