#!/bin/bash
set -e

YOSYS_SCRIPT="$1"
SYNTH_ROOT="$2"

echo "Running Yosys on: $YOSYS_SCRIPT"
echo "Design root: $SYNTH_ROOT"

ls /
ls /yosys-install
ls /yosys-install/yosys

/yosys-install/yosys "$YOSYS_SCRIPT"