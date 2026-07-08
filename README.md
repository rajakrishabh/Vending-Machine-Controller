# Vending Machine Controller (Verilog)

A Moore FSM that tracks coins inserted into a vending machine and
dispenses an item once enough money has gone in, returning change if
you overpaid.

## Files

- `vending_machine.v` — the design
- `tb_vending_machine.v` — testbench with two purchase scenarios

## How it works

Item price is fixed at 15 (rupees, or whatever unit you want to call
it). Machine accepts two coin types: 5 and 10. Each coin input
(`coin5` / `coin10`) is a one-cycle pulse when a coin goes in.

States just track how much money has been inserted so far:

```
S_0  -> 0 inserted
S_5  -> 5 inserted
S_10 -> 10 inserted
S_15 -> 15 or more inserted -> dispense next cycle
```

From `S_15`, the machine dispenses the item, computes
`change = total - price`, and resets back to `S_0`.

## Verified output

Ran two purchase scenarios through simulation:

```
10 + 5  = 15  -> DISPENSED, change = 0
10 + 10 = 20  -> DISPENSED, change = 5
```

Both came out correct.

## How to run in Vivado

1. Create a new RTL project.
2. Add `vending_machine.v` as a **Design Source**.
3. Add `tb_vending_machine.v` as a **Simulation Source**.
4. Flow Navigator → Simulation → **Run Simulation → Run Behavioral
   Simulation**.
5. Add `dispense` and `change_amount` to the waveform, then run/restart.
6. Tcl console prints the dispense events shown above.

## Possible extensions

- Support more coin denominations (1, 2, 20...)
- Support multiple items at different prices (item select input)
- Add a "coin return" button to cancel a transaction and refund
- Add a "sold out" state per item
