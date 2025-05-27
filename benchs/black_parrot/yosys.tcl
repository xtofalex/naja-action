yosys -import

read_liberty -lib $::env(SYNTH_ROOT)/libs/NangateOpenCellLibrary_typical.lib
read_liberty -lib $::env(SYNTH_ROOT)/libs/fakeram45_64x7.lib
read_liberty -lib $::env(SYNTH_ROOT)/libs/fakeram45_64x15.lib
read_liberty -lib $::env(SYNTH_ROOT)/libs/fakeram45_64x96.lib
read_liberty -lib $::env(SYNTH_ROOT)/libs/fakeram45_256x95.lib
read_liberty -lib $::env(SYNTH_ROOT)/libs/fakeram45_512x64.lib 
read_verilog $::env(SYNTH_ROOT)/black_parrot.v $::env(SYNTH_ROOT)/macros.v
keep_hierarchy

synth -run :fine 

# Get rid of indigestibles
chformal -remove
delete t:\$print

# rename registers to have the verilog register name in its name
# of the form \regName$_DFF_P_. We should fix yosys to make it the reg name.
# At least this is predictable.
renames -wire

log_cmd abc

# Optimize the design
opt -purge

# Replace undef values with defined constants
setundef -zero

# Splitting nets resolves unwanted compound assign statements in netlist (assign {..} = {..})
splitnets

# Technology mapping of adders
#if {[env_var_exists_and_non_empty ADDER_MAP_FILE]} {
  # extract the full adders
  extract_fa
  # map full adders
  #techmap -map $::env(ADDER_MAP_FILE)
  techmap -map $::env(SYNTH_ROOT)/cells_adders.v 
  techmap
  # Quick optimization
  opt -fast -purge
#}

# Technology mapping of latches
#if {[env_var_exists_and_non_empty LATCH_MAP_FILE]} {
  #techmap -map $::env(LATCH_MAP_FILE)
  techmap -map $::env(SYNTH_ROOT)/cells_latch.v
#}

dfflibmap -liberty $::env(SYNTH_ROOT)/libs/NangateOpenCellLibrary_typical.lib

# Remove unused cells and wires
opt_clean -purge

write_verilog -nohex -nodec synth.v