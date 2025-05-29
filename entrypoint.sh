#!/bin/bash
set -e

ROOT="/github/workspace"
DESIGN_HOME="$1"
DESIGN_CONFIG="$2"
#LIBERTY_FILE="$ROOT/$SYNTH_ROOT/libs/NangateOpenCellLibrary_typical.lib"
VERILOG_FILE="/results/nangate45/bp/base/1_synth.v"

#echo "Running Yosys on: $ROOT/$YOSYS_SCRIPT"
#echo "Design root: $ROOT/$SYNTH_ROOT"
#echo "Liberty file: $LIBERTY_FILE"
#echo "Verilog file: $VERILOG_FILE"

#export SYNTH_ROOT="$ROOT/$SYNTH_ROOT"
#/yosys-install/bin/yosys "$YOSYS_SCRIPT"
export DESIGN_HOME="$ROOT/$DESIGN_HOME"
export DESIGN_CONFIG="$ROOT/$DESIGN_CONFIG"
export YOSYS_EXE="/yosys/bin/yosys"
cd /najaeda-or/flow && make synth

python3 $ROOT/scripts/count_leaves.py --liberty "$LIBERTY_FILE" --verilog "$VERILOG_FILE" 