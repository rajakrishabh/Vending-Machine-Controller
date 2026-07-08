// vending_machine.v
// item costs 15 rupees, only takes 5 and 10 rupee coins (one coin per cycle)
// dispenses once you've put in 15 or more, and gives change back if you overpaid

module vending_machine (
    input clk,
    input reset,
    input coin5,      // pulse high for 1 cycle when a 5 rupee coin goes in
    input coin10,      
    output reg dispense,
    output reg [4:0] change_amount
);

    parameter PRICE = 15;

    // states just track how much money we've got so far
    parameter S_0  = 0;
    parameter S_5  = 1;
    parameter S_10 = 2;
    parameter S_15 = 3;  // hit or crossed the price, dispense next cycle

    reg [2:0] state;
    reg [4:0] total;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= S_0;
            total <= 0;
            dispense <= 0;
            change_amount <= 0;
        end
        else begin
            dispense <= 0;
            change_amount <= 0;

            case(state)
                S_0: begin
                    if (coin10) begin total <= 10; state <= S_10; end
                    else if (coin5) begin total <= 5; state <= S_5; end
                end

                S_5: begin
                    if (coin10) begin total <= total + 10; state <= S_15; end
                    else if (coin5) begin total <= total + 5; state <= S_10; end
                end

                S_10: begin
                    // either coin here is enough to cross 15
                    if (coin10) begin total <= total + 10; state <= S_15; end
                    else if (coin5) begin total <= total + 5; state <= S_15; end
                end

                S_15: begin
                    dispense <= 1;
                    change_amount <= total - PRICE;
                    total <= 0;
                    state <= S_0;
                end

                default: state <= S_0;
            endcase
        end
    end

endmodule
