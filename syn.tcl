# Setting environment
sh mkdir -p Netlist
sh mkdir -p Report

set_host_options -max_cores 6

# Import Design
set DESIGN "CHIP_All"

define_design_lib WORK -path ./work

# read_file -format sverilog  "../RgbdVoAsic_All/$DESIGN.sv"

analyze -format sverilog -vcs "-f rtl_verilog.f"
elaborate CHIP_All

current_design [get_designs $DESIGN]
link

source -echo -verbose ./CHIP_All.sdc

# Compile Design
current_design [get_designs ${DESIGN}]

check_design > Report/check_design.txt
check_timing > Report/check_timing.txt
#set high_fanout_net_threshold 0

uniquify
set_fix_multiple_port_nets -all -buffer_constants [get_designs *]
compile_ultra -timing -retime > ./15_compile.txt

# Report Output
current_design [get_designs ${DESIGN}]
report_timing > "./Report/${DESIGN}_syn.timing"
report_area > "./Report/${DESIGN}_syn.area"

# Output Design
current_design [get_designs ${DESIGN}]

remove_unconnected_ports -blast_buses [get_cells -hierarchical *]
set verilogout_higher_designs_first true
write -format ddc     -hierarchy -output "./Netlist/${DESIGN}_syn.ddc"
write -format verilog -hierarchy -output "./Netlist/${DESIGN}_syn.v"
write_sdf -version 2.1  -context verilog -load_delay cell ./Netlist/${DESIGN}_syn.sdf
write_sdc  ./Netlist/${DESIGN}_syn.sdc -version 1.8

report_timing
report_area
check_design
exit
