module uart_top(
    input clk, rst, wr_enb,
    input [7:0] tx_data_in,
    output tx, tx_busy,
    input rx, rdy_clr,
    output [7:0] rx_data_out,
    output rx_rdy
);
    wire tx_enb;
    wire rx_enb;

    baud_rate_generator baud_gen_inst (
        clk,
        tx_enb,
        rx_enb
    );

    transmitter tx_inst (
        clk,
        rst,
        tx_enb,
        wr_enb,
        tx_data_in,
        tx,
        tx_busy
    );

    receiver rx_inst (
        clk,
        rst,
        rx,
        rdy_clr,
        rx_enb,
        rx_data_out,
        rx_rdy
    );
endmodule