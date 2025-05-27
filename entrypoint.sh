#!/bin/bash
set -e

ROOT="/github/workspace"
YOSYS_SCRIPT="$1"
SYNTH_ROOT="$2"

echo "Running Yosys on: $ROOT/$YOSYS_SCRIPT"
echo "Design root: $ROOT/$SYNTH_ROOT"

ls -l "$YOSYS_SCRIPT"
ls -l "$SYNTH_ROOT"

/yosys-install/bin/yosys "$YOSYS_SCRIPT"