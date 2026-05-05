module control (
    input clk,
    input reset,
    input start,
    input mult_0,
    output add,
    output shift,
    output reg done
);

    reg [1:0] state;
    reg [5:0] count;
    reg       phase;
    reg       add_reg;
    reg       shift_reg;

    // add and shift combinational -- no delay
    assign add   = (state == 2'b01 && phase == 0) ? mult_0 : 1'b0;
    assign shift = (state == 2'b01 && phase == 1) ? 1'b1   : 1'b0;

    localparam IDLE    = 2'b00;
    localparam COMPUTE = 2'b01;
    localparam DONE    = 2'b10;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            count <= 0;
            phase <= 0;
            done  <= 0;
        end
        else begin
            case (state)

                IDLE: begin
                    done  <= 0;
                    count <= 0;
                    phase <= 0;
                    if (start)
                        state <= COMPUTE;
                end

                COMPUTE: begin
                    if (phase == 0) begin
                        phase <= 1;
                    end else begin
                        phase <= 0;
                        count <= count + 1;
                        if (count == 31)
                            state <= DONE;
                    end
                end

                DONE: begin
                    done <= 1;
                end

            endcase
        end
    end
endmodule
