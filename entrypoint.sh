#!/bin/bash
set -e

ROOT="/github/workspace"
DESIGN_HOME="$1"
DESIGN_CONFIG="$2"
#LIBERTY_FILE="$ROOT/$SYNTH_ROOT/libs/NangateOpenCellLibrary_typical.lib"
VERILOG_FILE="synth.v"

#echo "Running Yosys on: $ROOT/$YOSYS_SCRIPT"
#echo "Design root: $ROOT/$SYNTH_ROOT"
#echo "Liberty file: $LIBERTY_FILE"
#echo "Verilog file: $VERILOG_FILE"

#export SYNTH_ROOT="$ROOT/$SYNTH_ROOT"
#/yosys-install/bin/yosys "$YOSYS_SCRIPT"
export DESIGN_HOME="$ROOT/$DESIGN_HOME"
export DESIGN_CONFIG="$ROOT/$DESIGN_CONFIG"
python3 -c "import yaml; print(yaml.__version__)"
python -c "import yaml; print(yaml.__version__)"
cd /najaeda-or/flow && make

#python3 $ROOT/scripts/count_leaves.py --liberty "$LIBERTY_FILE" --verilog "$VERILOG_FILE" 