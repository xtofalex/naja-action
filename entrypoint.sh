#!/bin/bash
set -e

ROOT="/github/workspace"
MODE="$1"
DESIGN_HOME="$2"
DESIGN_CONFIG="$3"

export YOSYS_EXE="/yosys/bin/yosys"
export DESIGN_CONFIG="$ROOT/$DESIGN_CONFIG"

if [ "$MODE" == "orfs" ]; then
    echo "Running in ORFS mode"
    export DESIGN_HOME="$ROOT/$DESIGN_HOME"
    LIBERTY_FILE="/najaeda-or/flow/objects/nangate45/bp/base/lib/*.lib"
    VERILOG_FILE="/najaeda-or/flow/results/nangate45/bp/base/1_synth.v"
    cd /najaeda-or/flow && make synth
    echo "Liberty file: $LIBERTY_FILE"
    echo "$(ls /najaeda-or/flow/objects/nangate45/bp/base/lib)"
    echo "Verilog file: $VERILOG_FILE"

    python3 /najaeda_scripts/count_leaves.py --primitives_mode="liberty" --liberty "$LIBERTY_FILE" --verilog "$VERILOG_FILE" 
else
    echo "Running in direct yosys mode"
    echo "Yosys executable: $YOSYS_EXE"
    echo "Yosys version: $($YOSYS_EXE -V)"
    echo "Design home: $DESIGN_HOME"
    echo "Design config: $DESIGN_CONFIG"
    #export SYNTH_ROOT="$ROOT/najaeda-or/flow"
    #export SYNTH_ROOT="$ROOT/$SYNTH_ROOT"
    cd $DESIGN_HOME && $YOSYS_EXE -c $DESIGN_CONFIG
    VERILOG_FILE="naja_netlist.v"
    echo "Verilog file: $VERILOG_FILE"

    python3 /najaeda_scripts/count_leaves.py --primitives_mode="xilinx" --verilog "$VERILOG_FILE" 
fi
