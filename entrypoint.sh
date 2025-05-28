#!/bin/bash
set -e

ROOT="/github/workspace"
SETTINGS_PATH="$1"
#LIBERTY_FILE="$ROOT/$SYNTH_ROOT/libs/NangateOpenCellLibrary_typical.lib"
VERILOG_FILE="synth.v"

#echo "Running Yosys on: $ROOT/$YOSYS_SCRIPT"
#echo "Design root: $ROOT/$SYNTH_ROOT"
#echo "Liberty file: $LIBERTY_FILE"
#echo "Verilog file: $VERILOG_FILE"

#export SYNTH_ROOT="$ROOT/$SYNTH_ROOT"
#/yosys-install/bin/yosys "$YOSYS_SCRIPT"
cp "$ROOT/$SETTINGS_PATH" /najaeda-or/flow/settings.mk
cd /najaeda-or/flow && make

#python3 $ROOT/scripts/count_leaves.py --liberty "$LIBERTY_FILE" --verilog "$VERILOG_FILE" 