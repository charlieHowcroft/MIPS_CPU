// `include "1_bit_MUX.v"
// `include "2_bit_MUX.v"
// `include "adder.v"

module ALU(input a, input b, input b_inv, input c_in, input [1:0] operation, 
    output result, output carry_out, output a_out, output b_out, output sum_out);

    wire a_out, b_out, sum_out;
    assign a_out = a;

    wire [1:0] in;
    assign in = {~b,b};
    MUX_1_bit MUX_1_bit_b_inv(.in(in), .choose(b_inv), .z_out(b_out));

    wire carry_out;
    adder adder_alu(.s(sum_out), .c0(carry_out), .a(a), .b(b_out), .c(c_in));


    wire [3:0] final_MUX_input;
    assign final_MUX_input[0] = sum_out;  
    assign final_MUX_input[1] = 0;
    assign final_MUX_input[2] = 0;
    assign final_MUX_input[3] = 0;
    MUX_2_bit MUX_2_bit_operation(.in(final_MUX_input), .choose(operation), .z_out(result));

endmodule