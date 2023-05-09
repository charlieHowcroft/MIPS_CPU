/**
 * -- Status --
 *     3: V - Overflow
 *     2: N - Negative
 *     1: Z - Zero
 *     0: C - Carry
 */
`define STATUS_V_BIT 3
`define STATUS_N_BIT 2
`define STATUS_Z_BIT 1
`define STATUS_C_BIT 0

/**
 * -- Control --
 *     bits: invert a, invert b, operation[2:0]
 *     operation: 0=and, 1=or, 2=add, 3=SLT, 4=SLL, 5=SRL
 */
`define AND  'b00000
`define OR   'b00001
`define ADD  'b00010
`define SUB  'b01010
`define SLT  'b01011
`define NOR  'b11000
`define NAND 'b11001
`define SLL  'b00100
`define SRL  'b00101

module ALU
    #(parameter DATA_WIDTH = 32)
    (control, a, b, shiftAmount, statusIn, out, statusOut);

    input[4:0] control;
    input[DATA_WIDTH-1:0] a, b;
    input[4:0] shiftAmount;
    input[3:0] statusIn;

    output reg[DATA_WIDTH-1:0] out;
    output[3:0] statusOut;

    // TODO

endmodule

/**
 * Basic clocked register.
 * D is clocked through to Q on a rising edge.
 */
module Register
    #(parameter DATA_WIDTH=32)
    (input [DATA_WIDTH-1:0] D, input clock, output reg [DATA_WIDTH-1:0] Q);

    // TODO

endmodule

/**
 * Register file with two read ports and one write port.
 * Any change in a read address will immediately result in the update of
 * the output.
 * Any change in the write address or write data will result
 * in the update to the stored data at the write address on the rising edge of the clock.
 */
module RegisterFile
    #(parameter ADDRESS_WIDTH = 5, parameter DATA_WIDTH = 32)
    (clock, address1, address2, writeAddress, writeData, regWrite, outData1, outData2);

    input clock;
    input[ADDRESS_WIDTH-1:0] address1, address2, writeAddress;
    input[DATA_WIDTH-1:0] writeData;
    input regWrite;
    output [DATA_WIDTH-1:0] outData1, outData2;

    reg[DATA_WIDTH-1:0] data[2**ADDRESS_WIDTH:0];

    assign outData1 = data[address1];
    assign outData2 = data[address2];

    always @(posedge clock) begin
        if(regWrite) begin
            data[writeAddress] <= writeData;
        end
    end

endmodule

module SignExtend
    #(parameter FROM_WIDTH = 16, parameter TO_WIDTH = 32)
    (input [FROM_WIDTH-1:0] unextended, output [TO_WIDTH-1:0] extended);

    assign extended = $signed(unextended);

endmodule