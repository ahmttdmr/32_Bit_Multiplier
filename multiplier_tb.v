`timescale 1ns/1ps

module multiplier_tb;

    reg         clk;
    reg         reset;
    reg         start;
    reg         load;
    reg  [31:0] multiplicand;
    reg  [31:0] multiplier;

    wire [63:0] product;
    wire        done;
    wire        mult_0;
    wire        add;
    wire        shift;

    control ctrl (
        .clk    (clk),
        .reset  (reset),
        .start  (start),
        .mult_0 (mult_0),
        .add    (add),
        .shift  (shift),
        .done   (done)
    );

    datapath dp (
        .clk          (clk),
        .reset        (reset),
        .load         (load),
        .add          (add),
        .shift        (shift),
        .multiplicand (multiplicand),
        .multiplier   (multiplier),
        .product      (product),
        .mult_0       (mult_0)
    );

    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, multiplier_tb);
    end

    task run_test;
        input [31:0] a;
        input [31:0] b;
        input [63:0] expected;
        input [31:0] test_num;
        begin
            // reset
            reset = 1; start = 0; load = 0;
            @(negedge clk); @(negedge clk);
            reset = 0;

            // load
            @(negedge clk);
            multiplicand = a;
            multiplier   = b;
            load = 1;
            @(posedge clk);
            @(negedge clk);
            load = 0;

            // start
            start = 1;
            @(posedge clk);
            @(negedge clk);
            start = 0;

            // bekle
            repeat(200) @(posedge clk);

            if (product == expected)
                $display("TEST %0d PASSED: %0d x %0d = %0d", test_num, a, b, product);
            else
                $display("TEST %0d FAILED: %0d x %0d = %0d (expected=%0d)", test_num, a, b, product, expected);
        end
    endtask

    initial begin
        reset = 1; start = 0; load = 0;
        multiplicand = 0; multiplier = 0;
        repeat(3) @(posedge clk);

        run_test(13,  11,  143,   1);
        run_test(255, 255, 65025, 2);
        run_test(0,   12,  0,     3);
        run_test(1,   1,   1,     4);

        $display("Simulation completed.");
        $finish;
    end

endmodule
