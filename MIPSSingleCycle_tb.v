`include "MIPSSingleCycle.v"

module MIPSSingleCycle_tb();
    // Clock:
    reg clock;
    task tick;
        begin
            clock = 0;
            #20 clock = 1;
            #20 clock = 0;
        end
    endtask

    // Display results:
    task printHeader;
        begin
            $display("pc, nextPC, $at, $a0, $v0, $t0, $t1, $t2, $s0, $s1, $s2, $s3, $s4, $s5, $s6, $s7, $ra, $sp, opcode, rs, rt, rd, shiftAmount, funct, immediate, jumpAddress, aluOut, mem[0], mem[4], mem[8], mem[c], mem[10], mem[14], stk[3ec], stk[3f0], stk[3f4], stk[3f8], stk[3fc], V, N, Z, C, EPC, cause, instruction");
        end
    endtask

    task printRow;
        begin
            $display("0x%0h, 0x%0h, %0h, %0h, %0h, %0h, %0h, %0h, %0h, %0h, %0h, %0h, %0h, %0h, %0h, %0h, %0h, %0h, %0h, %0h, %0h, %0h, %0h, %0h, %0h, %0h, %0h, %0h, %0h, %0h, %0h, %0h, %0h, %0h, %0h, %0h, %0h, %0h, %0b, %0b, %0b, %0b, %0h, %0h, %s", 
                ss.pc, 
                ss.nextPC, 
                
                ss.rf.data[`at],
                ss.rf.data[`a0],
                ss.rf.data[`v0],
                ss.rf.data[`t0],
                ss.rf.data[`t1],
                ss.rf.data[`t2],
                ss.rf.data[`s0],
                ss.rf.data[`s1],
                ss.rf.data[`s2],
                ss.rf.data[`s3],
                ss.rf.data[`s4],
                ss.rf.data[`s5],
                ss.rf.data[`s6],
                ss.rf.data[`s7],
                ss.rf.data[`ra],
                ss.rf.data[`sp],
                
                ss.opcode,
                ss.rs, 
                ss.rt, 
                ss.rd,
                ss.shiftAmount,
                ss.funct,
                ss.immediate,
                ss.jumpAddress,

                ss.aluOut,

                dataMemory[0],
                dataMemory[4],
                dataMemory[8],
                dataMemory['hc],
                dataMemory['h10],
                dataMemory['h14],

                dataMemory['h3ec],
                dataMemory['h3f0],
                dataMemory['h3f4],
                dataMemory['h3f8],
                dataMemory['h3fc],

                ss.nextStatus[`STATUS_V_BIT],
                ss.nextStatus[`STATUS_N_BIT],
                ss.nextStatus[`STATUS_Z_BIT],
                ss.nextStatus[`STATUS_C_BIT],

                ss.epc,
                ss.nextCause,

                instruction[ss.pc - 'h00400000]
            );
        end
    endtask

    // Memory:
    reg[31:0] dataMemory[0:1023]; // 1k data memory
    reg[31:0] instructionMemory[0:1023]; // 1k instruction memory

    wire[31:0] insMemAddress, dataMemAddress; 
    reg[31:0] insReadValue, dataReadValue;
    wire[31:0] dataWriteValue;
    
    wire insMemRead, dataMemRead, dataMemWrite;

    always @(insMemAddress, insMemRead) begin
        if(insMemRead == 1)
            insReadValue <= instructionMemory[insMemAddress - 'h00400000]; // .text starts at 0x00400000
    end

    always @(dataMemAddress, dataMemRead, dataMemWrite, dataWriteValue) begin
        if(dataMemRead)
            dataReadValue <= dataMemory[dataMemAddress - 'h10010000]; // .data starts at 0x10010000
    end
    always @(posedge clock) begin
        if(dataMemWrite) begin
            dataMemory[dataMemAddress - 'h10010000] <= dataWriteValue;
        end
    end

    // Data Path:
    SingleCycleDataPath ss(clock, insReadValue, dataReadValue, insMemAddress, insMemRead, dataMemAddress, dataMemRead, dataMemWrite, dataWriteValue);

    // Test:
    integer i;
    reg[255:0] instruction[1023:0];
    initial begin
        printHeader();

        // Test register data:
        ss.rf.data[0]  <= 0; // $zero

        // Machine Code:
        instructionMemory['h00] <= 'h24090034;
        instructionMemory['h04] <= 'h24080000;
        instructionMemory['h08] <= 'h11090005;
        instructionMemory['h0c] <= 'h3c011001;
        instructionMemory['h10] <= 'h00280821;
        instructionMemory['h14] <= 'hac200000;
        instructionMemory['h18] <= 'h21080004;
        instructionMemory['h1c] <= 'h1000fffa;
        instructionMemory['h20] <= 'h24040002;
        instructionMemory['h24] <= 'h0c100013;
        instructionMemory['h28] <= 'h24040003;
        instructionMemory['h2c] <= 'h0c100013;
        instructionMemory['h30] <= 'h24040004;
        instructionMemory['h34] <= 'h0c100013;
        instructionMemory['h38] <= 'h24040005;
        instructionMemory['h3c] <= 'h0c100013;
        instructionMemory['h40] <= 'h24040006;
        instructionMemory['h44] <= 'h0c100013;
        instructionMemory['h48] <= 'h10000027;
        instructionMemory['h4c] <= 'h20010010;
        instructionMemory['h50] <= 'h03a1e822;
        instructionMemory['h54] <= 'hafa40000;
        instructionMemory['h58] <= 'hafbf0004;
        instructionMemory['h5c] <= 'hafb40008;
        instructionMemory['h60] <= 'hafb7000c;
        instructionMemory['h64] <= 'h14040002;
        instructionMemory['h68] <= 'h24020000;
        instructionMemory['h6c] <= 'h10000018;
        instructionMemory['h70] <= 'h20010001;
        instructionMemory['h74] <= 'h14240002;
        instructionMemory['h78] <= 'h24020001;
        instructionMemory['h7c] <= 'h10000014;
        instructionMemory['h80] <= 'h0004b880;
        instructionMemory['h84] <= 'h3c011001;
        instructionMemory['h88] <= 'h00370821;
        instructionMemory['h8c] <= 'h8c280000;
        instructionMemory['h90] <= 'h1500000c;
        instructionMemory['h94] <= 'h20010001;
        instructionMemory['h98] <= 'h00812022;
        instructionMemory['h9c] <= 'h0c100013;
        instructionMemory['ha0] <= 'h0040a020;
        instructionMemory['ha4] <= 'h20010001;
        instructionMemory['ha8] <= 'h00812022;
        instructionMemory['hac] <= 'h0c100013;
        instructionMemory['hb0] <= 'h00406820;
        instructionMemory['hb4] <= 'h028d7020;
        instructionMemory['hb8] <= 'h3c011001;
        instructionMemory['hbc] <= 'h00370821;
        instructionMemory['hc0] <= 'hac2e0000;
        instructionMemory['hc4] <= 'h3c011001;
        instructionMemory['hc8] <= 'h00370821;
        instructionMemory['hcc] <= 'h8c220000;
        instructionMemory['hd0] <= 'h8fa40000;
        instructionMemory['hd4] <= 'h8fbf0004;
        instructionMemory['hd8] <= 'h8fb40008;
        instructionMemory['hdc] <= 'h8fb7000c;
        instructionMemory['he0] <= 'h23bd0010;
        instructionMemory['he4] <= 'h03e00008;
        instructionMemory['he8] <= 'h1000ffff;

        instructionMemory['h1e0] <= 'h08000078;

        // Assembly:
        instruction['h00] <= "addiu $9,$0,0x00000034";
        instruction['h04] <= "addiu $8,$0,0x00000000";
        instruction['h08] <= "beq $8,$9,0x00000005  ";
        instruction['h0c] <= "lui $1,0x00001001     ";
        instruction['h10] <= "addu $1,$1,$8         ";
        instruction['h14] <= "sw $0,0x00000000($1)  ";
        instruction['h18] <= "addi $8,$8,0x00000004 ";
        instruction['h1c] <= "beq $0,$0,0xfffffffa  ";
        instruction['h20] <= "addiu $4,$0,0x00000002";
        instruction['h24] <= "jal 0x0040004c        ";
        instruction['h28] <= "addiu $4,$0,0x00000003";
        instruction['h2c] <= "jal 0x0040004c        ";
        instruction['h30] <= "addiu $4,$0,0x00000004";
        instruction['h34] <= "jal 0x0040004c        ";
        instruction['h38] <= "addiu $4,$0,0x00000005";
        instruction['h3c] <= "jal 0x0040004c        ";
        instruction['h40] <= "addiu $4,$0,0x00000006";
        instruction['h44] <= "jal 0x0040004c        ";
        instruction['h48] <= "beq $0,$0,0x00000027  ";
        instruction['h4c] <= "addi $1,$0,0x00000010 ";
        instruction['h50] <= "sub $29,$29,$1        ";
        instruction['h54] <= "sw $4,0x00000000($29) ";
        instruction['h58] <= "sw $31,0x00000004($29)";
        instruction['h5c] <= "sw $20,0x00000008($29)";
        instruction['h60] <= "sw $23,0x0000000c($29)";
        instruction['h64] <= "bne $0,$4,0x00000002  ";
        instruction['h68] <= "addiu $2,$0,0x00000000";
        instruction['h6c] <= "beq $0,$0,0x00000018  ";
        instruction['h70] <= "addi $1,$0,0x00000001 ";
        instruction['h74] <= "bne $1,$4,0x00000002  ";
        instruction['h78] <= "addiu $2,$0,0x00000001";
        instruction['h7c] <= "beq $0,$0,0x00000014  ";
        instruction['h80] <= "sll $23,$4,0x00000002 ";
        instruction['h84] <= "lui $1,0x00001001     ";
        instruction['h88] <= "addu $1,$1,$23        ";
        instruction['h8c] <= "lw $8,0x00000000($1)  ";
        instruction['h90] <= "bne $8,$0,0x0000000c  ";
        instruction['h94] <= "addi $1,$0,0x00000001 ";
        instruction['h98] <= "sub $4,$4,$1          ";
        instruction['h9c] <= "jal 0x0040004c        ";
        instruction['ha0] <= "add $20,$2,$0         ";
        instruction['ha4] <= "addi $1,$0,0x00000001 ";
        instruction['ha8] <= "sub $4,$4,$1          ";
        instruction['hac] <= "jal 0x0040004c        ";
        instruction['hb0] <= "add $13,$2,$0         ";
        instruction['hb4] <= "add $14,$20,$13       ";
        instruction['hb8] <= "lui $1,0x00001001     ";
        instruction['hbc] <= "addu $1,$1,$23        ";
        instruction['hc0] <= "sw $14,0x00000000($1) ";
        instruction['hc4] <= "lui $1,0x00001001     ";
        instruction['hc8] <= "addu $1,$1,$23        ";
        instruction['hcc] <= "lw $2,0x00000000($1)  ";
        instruction['hd0] <= "lw $4,0x00000000($29) ";
        instruction['hd4] <= "lw $31,0x00000004($29)";
        instruction['hd8] <= "lw $20,0x00000008($29)";
        instruction['hdc] <= "lw $23,0x0000000c($29)";
        instruction['he0] <= "addi $29,$29,0x0000001";
        instruction['he4] <= "jr $31                ";
        instruction['he8] <= "beq $0,$0,0xffffffff  ";

        // Run:
        for(i = 0; i < 512; i++) begin
            tick();
            printRow();
        end
        tick();
        printRow();
    end
endmodule