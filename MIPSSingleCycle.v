`include "MIPSComponents.v"

/* Instructions: */
/* Mnemonic  Meaning                               Type  Opcode Funct */
/* add       Add                                      R  0x00   0x20  */
/* addi      Add Immediate                            I  0x08   NA    */
/* addiu     Add Unsigned Immediate                   I  0x09   NA    */
/* addu      Add Unsigned                             R  0x00   0x21  */
/* and       Bitwise AND                              R  0x00   0x24  */
/* andi      Bitwise AND Immediate                    I  0x0C   NA    */
/* beq       Branch if Equal                          I  0x04   NA    */
/* blez      Branch if Less Than or Equal to Zero     I  0x06   NA    */
/* bne       Branch if Not Equal                      I  0x05   NA    */
/* bgtz      Branch on Greater Than Zero              I  0x07   NA    */
/* div       Divide                                   R  0x00   0x1A  */
/* divu      Unsigned Divide                          R  0x00   0x1B  */
/* j         Jump to Address                          J  0x02   NA    */
/* jal       Jump and Link                            J  0x03   NA    */
/* jr        Jump to Address in Register              R  0x00   0x08  */
/* lb        Load Byte                                I  0x20   NA    */
/* lbu       Load Byte Unsigned                       I  0x24   NA    */
/* lhu       Load Halfword Unsigned                   I  0x25   NA    */
/* lui       Load Upper Immediate                     I  0x0F   NA    */
/* lw        Load Word                                I  0x23   NA    */
/* mfhi      Move from HI Register                    R  0x00   0x10  */
/* mthi      Move to HI Register                      R  0x00   0x11  */
/* mflo      Move from LO Register                    R  0x00   0x12  */
/* mtlo      Move to LO Register                      R  0x00   0x13  */
/* mfc0      Move from Coprocessor 0                  R  0x10   NA    */
/* mult      Multiply                                 R  0x00   0x18  */
/* multu     Unsigned Multiply                        R  0x00   0x19  */
/* nor       Bitwise NOR (NOT-OR)                     R  0x00   0x27  */
/* xor       Bitwise XOR (Exclusive-OR)               R  0x00   0x26  */
/* or        Bitwise OR                               R  0x00   0x25  */
/* ori       Bitwise OR Immediate                     I  0x0D   NA    */
/* sb        Store Byte                               I  0x28   NA    */
/* sh        Store Halfword                           I  0x29   NA    */
/* slt       Set to 1 if Less Than                    R  0x00   0x2A  */
/* slti      Set to 1 if Less Than Immediate          I  0x0A   NA    */
/* sltiu     Set to 1 if Less Than Unsigned Immediate I  0x0B   NA    */
/* sltu      Set to 1 if Less Than Unsigned           R  0x00   0x2B  */
/* sll       Logical Shift Left                       R  0x00   0x00  */
/* srl       Logical Shift Right (0-extended)         R  0x00   0x02  */
/* sra       Arithmetic Shift Right (sign-extended)   R  0x00   0x03  */
/* sub       Subtract                                 R  0x00   0x22  */
/* subu      Unsigned Subtract                        R  0x00   0x23  */
/* sw        Store Word                               I  0x2B   NA    */

/* Registers */
`define zero  0 
`define at    1
`define v0    2
`define v1    3
`define a0    4
`define a1    5
`define a2    6
`define a3    7
`define t0    8
`define t1    9
`define t2    10
`define t3    11
`define t4    12
`define t5    13
`define t6    14
`define t7    15
`define s0    16
`define s1    17
`define s2    18
`define s3    19
`define s4    20
`define s5    21
`define s6    22
`define s7    23
`define t8    24
`define t9    25
`define k0    26
`define k1    27
`define gp    28
`define sp    29
`define fp    30
`define ra    31

// Status Register Bits:
`define STATUS_I_BIT 7 

// Exceptions and interrupts:
`define INT_ADDRESS 'h000001e0

// Control bits:
`define CONTROL_WIDTH   19
`define INT_CAUSE_BIT1  18 
`define INT_CAUSE_BIT2  17
`define CAUSE_WRITE_BIT 16
`define EPC_WRITE_BIT   15
`define ENABLE_INT_BIT  14
`define REG_DST_BIT1    13
`define REG_DST_BIT2    12
`define BEQ_BIT         11
`define BNE_BIT         10
`define JUMP_BIT        9
`define MEM_READ_BIT    8
`define TO_REG_BIT1     7
`define TO_REG_BIT2     6
`define ALU_OP_BIT1     5
`define ALU_OP_BIT2     4
`define ALU_OP_BIT3     3
`define MEM_WRITE_BIT   2
`define ALU_SRC_BIT     1
`define REG_WRITE_BIT   0

`define INT_EXT         'b0000000000000000000
`define INT_IBUS        'b0100000000000000000
`define INT_OVF         'b1000000000000000000
`define INT_SYSCALL     'b1100000000000000000
`define CAUSE_WRITE     'b0010000000000000000
`define EPC_WRITE       'b0001000000000000000
`define ENABLE_INT      'b0000100000000000000
`define DST_RT          'b0000000000000000000
`define DST_RD          'b0000001000000000000
`define DST_RA          'b0000010000000000000
`define BEQ             'b0000000100000000000
`define BNE             'b0000000010000000000
`define JUMP            'b0000000001000000000
`define MEM_READ        'b0000000000100000000
`define ALU_TO_REG      'b0000000000000000000
`define MEM_TO_REG      'b0000000000001000000
`define PC_TO_REG       'b0000000000010000000
`define IMM_L16_TO_REG  'b0000000000011000000
`define ALU_ADD         'b0000000000000000000
`define ALU_SUB         'b0000000000000001000
`define ALU_AND         'b0000000000000010000
`define ALU_OR          'b0000000000000011000
`define ALU_FUNCT       'b0000000000000100000
`define MEM_WRITE       'b0000000000000000100
`define ALU_SRC_REG     'b0000000000000000000
`define ALU_SRC_IMM     'b0000000000000000010
`define REG_WRITE       'b0000000000000000001

module Control(input[5:0] opcode, output reg[`CONTROL_WIDTH-1:0] control);
    
    always @(opcode) begin
        case (opcode)
            /* R-Type */ 'b000000: control <= `DST_RD | `ALU_TO_REG | `ALU_FUNCT | `ALU_SRC_REG | `REG_WRITE | `ENABLE_INT;
            /* LW */     // TODO
            /* SW */     // TODO
            /* BEQ */    // TODO
            /* J */      // TODO
            /* addi  */  // TODO

            default: control <= `EPC_WRITE | `CAUSE_WRITE |`INT_IBUS;

        endcase
    end

endmodule

module ALUControl(input[2:0] aluOp, input[5:0] funct, output reg[4:0] operation, output jr);

    // TODO

endmodule

module SingleCycleDataPath
    #(
        parameter ADDRESS_WIDTH=32, 
        parameter DATA_WIDTH=32
    )
    (clock, instruction, data, insMemAddress, insMemRead, dataMemAddress, dataMemRead, dataMemWrite, dataWriteValue);

    input clock;
    input[31:0] instruction;
    input[DATA_WIDTH-1:0] data;

    output[ADDRESS_WIDTH-1:0] insMemAddress, dataMemAddress;
    output reg insMemRead;
    output dataMemRead, dataMemWrite;
    output[DATA_WIDTH-1:0] dataWriteValue;

    // TODO: Specify all wiring.

    // Program Counter:
    Register
        #(.DATA_WIDTH(ADDRESS_WIDTH))
        pcRegister(nextPC, clock, pc);

    initial begin
        nextPC <= 'h00400000;
        insMemRead <= 1;
    end

    assign pcPlus4 = pc + 4;

    // TODO: Create and wire the ALU

    // Register File:
    RegisterFile 
        #(.ADDRESS_WIDTH(5), .DATA_WIDTH(DATA_WIDTH))
        rf(clock, rs, rt, writeRegAddress, writeRegData, regWrite, a, rtValue);

    initial begin
        rf.data[`sp] = 'h100103fc;
    end

    // TODO: Other logic, e.g. decode instruction, control, sign extend, wiring and logic for the register file

endmodule
