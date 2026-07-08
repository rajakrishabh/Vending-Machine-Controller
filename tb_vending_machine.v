// tb_vending_machine.v
// test 1: 10 + 5 = 15 exact, should dispense with 0 change
// test 2: 10 + 10 = 20, should dispense with 5 change

`timescale 1ns/1ps

module tb_vending_machine;

    reg clk, reset;
    reg coin5, coin10;
    wire dispense;
    wire [4:0] change_amount;

    vending_machine dut (
        .clk(clk),
        .reset(reset),
        .coin5(coin5),
        .coin10(coin10),
        .dispense(dispense),
        .change_amount(change_amount)
    );

    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        reset = 1; coin5 = 0; coin10 = 0;
        #12 reset = 0;

        // test 1
        #10 coin10 = 1; #10 coin10 = 0;
        #10 coin5 = 1;  #10 coin5 = 0;

        #30;

        // test 2
        #10 coin10 = 1; #10 coin10 = 0;
        #10 coin10 = 1; #10 coin10 = 0;

        #50 $finish;
    end

    always @(posedge clk)
        if (dispense)
            $display("t=%0t -> DISPENSED, change = %0d", $time, change_amount);

endmodule
