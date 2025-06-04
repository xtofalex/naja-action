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
else
    echo "Running in direct yosys mode"
    export SYNTH_ROOT="$ROOT/najaeda-or/flow"
    #export SYNTH_ROOT="$ROOT/$SYNTH_ROOT"
    $YOSYS_EXE $DESIGN_CONFIG
fi

#python3 $ROOT/scripts/count_leaves.py --liberty "$LIBERTY_FILE" --verilog "$VERILOG_FILE" 