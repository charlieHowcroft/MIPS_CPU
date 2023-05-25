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
            $display("pc, nextPC, $at, $a0, $v0, $t0, $t1, $t2, $s0, $s1, $s2, $s3, $s4, $s5, $s6, $s7, $ra, $sp, opcode, rs, rt, rd, shamt, funct, extended, aluOut, mem[0], mem[4], mem[8], mem[c], mem[10], mem[14], stk[3ec], stk[3f0], stk[3f4], stk[3f8], stk[3fc], V, N, Z, C, instruction");
        end
    endtask

    task printRow;
        begin
            $display("0x%0h, 0x%0h, %0h, %0h, %0h, %0h, %0h, %0h, %0h, %0h, %0h, %0h, %0h, %0h, %0h, %0h, %0h, %0h, %0h, %0h, %0h, %0h, %0h, %0h, %0h, %0h, %0h, %0h, %0h, %0h, %0h, %0h, %0h, %0h, %0h, %0b, %0b, %0b, %0b, %0h, %0h, %s", 
                ss.pc, 
                ss.reg_nextPC, 
                
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
                ss.shamt,
                ss.funct,
                ss.extended,
                // ss.jumpAddress,

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

                ss.status_reg[`STATUS_V_BIT],
                ss.status_reg[`STATUS_N_BIT],
                ss.status_reg[`STATUS_Z_BIT],
                ss.status_reg[`STATUS_C_BIT],

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
        ss.rf.data[1]  <= 0; // $zero
        ss.rf.data[2]  <= 0; // $zero
        ss.rf.data[3]  <= 0; // $zero
        ss.rf.data[4]  <= 0; // $zero
        ss.rf.data[5]  <= 0; // $zero
        ss.rf.data[6]  <= 0; // $zero
        ss.rf.data[7]  <= 0; // $zero
        ss.rf.data[8]  <= 0; // $zero
        ss.rf.data[9]  <= 0; // $zero
        ss.rf.data[10]  <= 0; // $zero
        ss.rf.data[11]  <= 0; // $zero
        ss.rf.data[12]  <= 0; // $zero
        ss.rf.data[13]  <= 0; // $zero
        ss.rf.data[14]  <= 0; // $zero
        ss.rf.data[15]  <= 0; // $zero
        ss.rf.data[16]  <= 0; // $zero
        ss.rf.data[17]  <= 0; // $zero
        ss.rf.data[18]  <= 0; // $zero
        

        // Machine Code:
        instructionMemory['h00] <= 'h24090064;
        instructionMemory['h04] <= 'h240a00c8;
        instructionMemory['h08] <= 'h012a5820;


        // Assembly: for visual testbench
        instruction['h00] <= "addiu $9,$0,0x00000034";
        instruction['h04] <= "addiu $8,$0,0x00000000";
        instruction['h08] <= "beq $8,$9,0x00000005  ";

        // Run:
        for(i = 0; i < 3; i++) begin
            tick();
            printRow();
        end
        tick();
        printRow();
    end
endmodule