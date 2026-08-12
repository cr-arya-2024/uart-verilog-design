module transmitter(
    input clk,rst,enb, wr_enb,
    input [7:0] data_in,
    output reg tx,
    output busy
);
    parameter IDLE_STATE  = 2'b00;
    parameter START_STATE = 2'b01;
    parameter DATA_STATE  = 2'b10;
    parameter STOP_STATE  = 2'b11;

    reg [7:0] data;
    reg [2:0] index;
    reg [1:0] state = IDLE_STATE;

    always @(posedge clk) begin
        if (rst) begin
            state <= IDLE_STATE;
            tx    <= 1'b1;
            data  <= 8'b0;
            index <= 3'b0;
        end else begin
            case (state)
                IDLE_STATE: begin
                    tx <= 1'b1;
                    if (wr_enb) begin
                        state <= START_STATE;
                        data  <= data_in;
                        index <= 3'h0;
                    end
                end

                START_STATE: begin
                    if (enb) begin
                        tx    <= 1'b0;
                        state <= DATA_STATE;
                    end
                end

                DATA_STATE: begin
                    if (enb) begin
                        tx <= data[index];
                        if (index == 3'h7) begin
                            state <= STOP_STATE;
                        end else begin
                            index <= index + 1'b1;
                        end
                    end
                end

                STOP_STATE: begin
                    if (enb) begin
                        tx    <= 1'b1;
                        state <= IDLE_STATE;
                    end
                end

                default: begin
                    state <= IDLE_STATE;
                    tx    <= 1'b1;
                end
            endcase
        end
    end

    assign busy = (state != IDLE_STATE);
endmodule