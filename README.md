```markdown
# UART Controller in Verilog

A complete, fully synthesizable Universal Asynchronous Receiver-Transmitter (UART) core written in Verilog. This design features an integrated baud rate generator, a state-machine-driven transmitter, and a 16x oversampling receiver for robust serial data transfer.

## Project Structure

```text
.
├── baud_rate_generator.v   # Clock divider generating TX and RX tick pulses
├── transmitter.v           # FSM-driven transmitter module
├── receiver.v              # FSM-driven receiver module with mid-bit sampling
├── uart_top.v              # Top-level integration module
└── tb_uart_top.v           # Testbench with loopback verification

```

## System Architecture

* **Frame Format:** 8 Data Bits, 1 Start Bit, 1 Stop Bit (8N1).
* **Transmitter:** Utilizes an active-high `wr_enb` signal to latch incoming parallel data onto the serial `tx` line and asserts a `busy` status flag during transmission.
* **Receiver:** Uses 16x oversampling to detect the start bit transition and samples data bits at the midpoint (8th clock pulse) for reliable reception under frequency drift.
* **Control Handshaking:** `rx_rdy` flags newly received parallel data, which remains asserted until cleared via the `rdy_clr` input pulse.

## Top Module Interface (`uart_top`)

| Signal Name | Direction | Bit-Width | Description |
| --- | --- | --- | --- |
| `clk` | Input | 1 | Master system clock |
| `rst` | Input | 1 | Synchronous reset (active high) |
| `wr_enb` | Input | 1 | Pulse high to initiate transmission |
| `tx_data_in` | Input | 8 | Parallel data byte to transmit |
| `tx` | Output | 1 | Serial transmit output |
| `tx_busy` | Output | 1 | High while transmission is in progress |
| `rx` | Input | 1 | Serial receive input |
| `rdy_clr` | Input | 1 | Pulse high to acknowledge and clear `rx_rdy` |
| `rx_data_out` | Output | 8 | Parallel data byte received |
| `rx_rdy` | Output | 1 | High when valid byte is received |





```

```