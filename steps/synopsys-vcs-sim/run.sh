#!/bin/sh

ARGS="-R -sverilog -timescale=1ns/1ps"
ARGS="$ARGS -hsopt"

ARGS="$ARGS -top $testbench_name"
ARGS="$ARGS inputs/adk/stdcells.v"
ARGS="$ARGS +vcs+dumpvars+outputs/design.vpd"

for f in inputs/*.v; do
    [ -e "$f" ] || continue
    ARGS="$ARGS $f"
done

for f in inputs/*.sv; do
    [ -e "$f" ] || continue
    ARGS="$ARGS $f"
done

if [ -f "inputs/design.args" ]; then
    ARGS="$ARGS -f inputs/design.args"
fi

(
    set -x;
    vcs $ARGS
)
