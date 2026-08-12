`timescale 1ns / 1ps

module tb_uart_top;

    reg        clk, rst, wr_enb;
    reg  [7:0] tx_data_in;
    wire       tx, tx_busy;
    wire       rx, rx_rdy;
    reg        rdy_clr;
    wire [7:0] rx_data_out;

    assign rx = tx;

    uart_top uut (clk, rst, wr_enb, tx_data_in, tx, tx_busy, rx, rdy_clr, rx_data_out, rx_rdy);

    always #10 clk = ~clk;

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_uart_top);
    end

    initial begin
        clk        = 0;
        rst        = 1;
        wr_enb     = 0;
        tx_data_in = 8'h00;
        rdy_clr    = 0;

        #100;
        rst = 0;
        #100;

        send_byte(8'hA5);
        wait(rx_rdy);
        #100;
        clear_rdy();

        #1000;
        send_byte(8'h3C);
        wait(rx_rdy);
        #100;
        clear_rdy();

        #5000;
        $finish;
    end

    task send_byte(input [7:0] data);
        begin
            @(posedge clk);
            tx_data_in = data;
            wr_enb     = 1'b1;
            @(posedge clk);
            wr_enb     = 1'b0;
        end
    endtask

    task clear_rdy();
        begin
            @(posedge clk);
            rdy_clr = 1'b1;
            @(posedge clk);
            rdy_clr = 1'b0;
        end
    endtask

endmodule