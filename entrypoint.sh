#!/bin/bash
set -e

ROOT="/github/workspace"
YOSYS_SCRIPT="$1"
SYNTH_ROOT="$2"

echo "Running Yosys on: $ROOT/$YOSYS_SCRIPT"
echo "Design root: $ROOT/$SYNTH_ROOT"

export SYNTH_ROOT="$ROOT/$SYNTH_ROOT"
/yosys-install/bin/yosys "$YOSYS_SCRIPT"

python3 $ROOT/scripts/count_leaves.py