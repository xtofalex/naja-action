#!/bin/bash
set -e

ROOT="/github/workspace"
MODE="$1"
DESIGN_HOME="$2"
DESIGN_CONFIG="$3"

export YOSYS_EXE="/yosys/bin/yosys"
export DESIGN_HOME="$ROOT/$DESIGN_HOME"
export DESIGN_CONFIG="$ROOT/$DESIGN_CONFIG"

echo "Installing tools..."
apk add curl
echo "::endgroup::"

if [ "$MODE" == "orfs" ]; then
    echo "::group::Naja-ORFS"
    echo "Naja ORFS mode selected"
    LIBERTY_FILE="/najaeda-or/flow/objects/nangate45/bp/base/lib/*.lib"
    VERILOG_FILE="/najaeda-or/flow/results/nangate45/bp/base/1_synth.v"
    cd /najaeda-or/flow && make synth
    echo "Liberty file: $LIBERTY_FILE"
    echo "$(ls /najaeda-or/flow/objects/nangate45/bp/base/lib)"
    echo "Verilog file: $VERILOG_FILE"
    echo "::endgroup::"

    echo "::group::Launching-Najaeda"
    python3 /najaeda_scripts/count_leaves.py --primitives_mode="liberty" --liberty "$LIBERTY_FILE" --verilog "$VERILOG_FILE" 
    echo "::endgroup::"
else
    echo "::group::Naja-Direct-Yosys"
    echo "Naja Direct Yosys mode selected"
    echo "Yosys executable: $YOSYS_EXE"
    echo "Yosys version: $($YOSYS_EXE -V)"
    echo "Design config: $DESIGN_CONFIG"
    mkdir naja-run
    cd naja-run
    #export SYNTH_ROOT="$ROOT/najaeda-or/flow"
    #export SYNTH_ROOT="$ROOT/$SYNTH_ROOT"
    $YOSYS_EXE -c "$DESIGN_CONFIG"
    VERILOG_FILE="naja_netlist.v"
    echo "Verilog file: $VERILOG_FILE"
    echo "::endgroup::"

    echo "::group::Launching-Najaeda"
    python3 /najaeda_scripts/count_leaves.py --primitives_mode="xilinx" --verilog "$VERILOG_FILE"
    echo "::endgroup::"
fi
