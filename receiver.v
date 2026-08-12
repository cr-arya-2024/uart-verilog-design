module receiver(
    input clk,rst,rx,rdy_clr,enb,
    output reg [7:0] data_out,
    output reg rdy
);
    parameter START_STATE    = 2'b00;
    parameter DATA_OUT_STATE = 2'b01;
    parameter STOP_STATE     = 2'b10;

    reg [1:0] state = START_STATE;
    reg [3:0] sample = 0;
    reg [3:0] index = 0;
    reg [7:0] temp_reg = 0;

    always @(posedge clk) begin
        if (rst) begin
            state    <= START_STATE;
            sample   <= 4'b0;
            index    <= 4'b0;
            temp_reg <= 8'b0;
            data_out <= 8'b0;
            rdy      <= 1'b0;
        end else begin
            if (rdy_clr)
                rdy <= 1'b0;

            if (enb) begin
                case (state)
                    START_STATE: begin
                        if (rx == 1'b0 || sample != 0) begin
                            sample <= sample + 1'b1;
                        end
                        
                        if (sample == 4'd15) begin
                            state    <= DATA_OUT_STATE;
                            sample   <= 4'b0;
                            index    <= 4'b0;
                            temp_reg <= 8'b0;
                        end
                    end

                    DATA_OUT_STATE: begin
                        sample <= sample + 1'b1;
                        if (sample == 4'h8) begin
                            temp_reg[index[2:0]] <= rx;
                            index <= index + 1'b1;
                        end
                        if (index == 4'd8 && sample == 4'd15) begin
                            state  <= STOP_STATE;
                            sample <= 4'b0;
                        end
                    end

                    STOP_STATE: begin
                        if (sample == 4'd15) begin
                            state    <= START_STATE;
                            data_out <= temp_reg;
                            rdy      <= 1'b1;
                            sample   <= 4'b0;
                        end else begin
                            sample <= sample + 1'b1;
                        end
                    end

                    default: begin
                        state <= START_STATE;
                    end
                endcase
            end
        end
    end
endmodule