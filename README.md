# 32-bit Shift-and-Add Multiplier

A synchronous digital circuit that multiplies a 32-bit multiplicand by a 32-bit multiplier to calculate a 64-bit product. Implemented in Verilog using a Control/Datapath architecture with an FSM-based control unit.

## Project Files

- `control.v` — FSM control unit (IDLE → COMPUTE → DONE). Generates `add` and `shift` signals.
- `datapath.v` — Datapath unit. Manages the multiplicand, multiplier, and 64-bit product registers.
- `multiplier_tb.v` — Testbench that verifies the design with multiple test cases.

## Prerequisites

- **Icarus Verilog** — for compiling the Verilog code
- **GTKWave** — for viewing simulation waveforms

## Simulation

**Step 1: Compile**
```bash
iverilog -o sim control.v datapath.v multiplier_tb.v
```

**Step 2: Run**
```bash
vvp sim
```

**Step 3: View waveforms**
```bash
gtkwave dump.vcd
```

Expected output:
```
TEST 1 PASSED: 13 x 11 = 143
TEST 2 PASSED: 255 x 255 = 65025
TEST 3 PASSED: 0 x 12 = 0
TEST 4 PASSED: 1 x 1 = 1
Simulation completed.
```
