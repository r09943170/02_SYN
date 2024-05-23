# operating conditions and boundary conditions #
# modify your clock cycle here #
set cycle  5.0 

create_clock -name sdc_clk -period $cycle [get_ports i_clk]
set_dont_touch_network      [get_clocks sdc_clk]
set_fix_hold                [get_clocks sdc_clk]
set_ideal_network           [get_ports i_clk]
set_clock_uncertainty  0.1  [get_clocks sdc_clk]
set_clock_latency      0.5  [get_clocks sdc_clk]


set_input_delay  0.5    -clock sdc_clk [remove_from_collection [all_inputs] [get_ports i_clk]]
set_output_delay 0.5    -clock sdc_clk [all_outputs] 
set_load         0.05     [all_outputs]

set_operating_conditions  -max_library sc9_cln40g_base_lvt_ss_typical_max_0p81v_125c -max ss_typical_max_0p81v_125c
# set_wire_load_model -name tsmc13_wl10 -library slow

set_max_fanout 20 [all_inputs]
