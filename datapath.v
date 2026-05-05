module datapath (
    input         clk,
    input         reset,
    input         load,
    input         add,
    input         shift,
    input  [31:0] multiplicand,
    input  [31:0] multiplier,
    output [63:0] product,
    output        mult_0
);

    reg [31:0] multiplicand_reg;
    reg [31:0] multiplier_reg;
    reg [63:0] product_reg;

    assign product = product_reg;
    assign mult_0  = multiplier_reg[0];

    always @(posedge clk) begin
        if (reset) begin
            multiplicand_reg <= 32'b0;
            multiplier_reg   <= 32'b0;
            product_reg      <= 64'b0;
        end
        else if (load) begin
            multiplicand_reg <= multiplicand;
            multiplier_reg   <= multiplier;
            product_reg      <= 64'b0;
        end
        else begin
            if (add) begin
                product_reg <= {product_reg[63:32] + multiplicand_reg,
                                product_reg[31:0]};
            end
            else if (shift) begin
                product_reg    <= {1'b0, product_reg[63:1]};
                multiplier_reg <= {1'b0, multiplier_reg[31:1]};
            end
        end
    end
endmodule
