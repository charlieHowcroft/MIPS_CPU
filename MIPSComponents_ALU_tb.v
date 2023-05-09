`include "MIPSComponents.v"

module ALU_tb();
    reg[3:0] control;
    reg[31:0] a, b;
    reg[3:0] si; // Status In
    wire[31:0] out;
    wire[3:0] so; // Status Out

    ALU #(.DATA_WIDTH(32)) alu (control, a, b, si, out, so);

    initial begin
      control = `ALU_AND;
      a = 'hf000000f;
      b = 'hf00000f0;
      si = 0;

      #20 $display("%0h & %0h = %0h; V=%0b, N=%0b, Z=%0b, C=%0b",
                   a, b, out, so[`STATUS_V_BIT], so[`STATUS_N_BIT], so[`STATUS_Z_BIT], so[`STATUS_C_BIT]);

      control = `ALU_OR;
      #20 $display("%0h | %0h = %0h; V=%0b, N=%0b, Z=%0b, C=%0b",
                   a, b, out, so[`STATUS_V_BIT], so[`STATUS_N_BIT], so[`STATUS_Z_BIT], so[`STATUS_C_BIT]);

      control = `ALU_XOR;
      #20 $display("%0h ^ %0h = %0h; V=%0b, N=%0b, Z=%0b, C=%0b",
                   a, b, out, so[`STATUS_V_BIT], so[`STATUS_N_BIT], so[`STATUS_Z_BIT], so[`STATUS_C_BIT]);

      control = `ALU_XNOR;
      #20 $display("!(%0h ^ %0h) = %0h; V=%0b, N=%0b, Z=%0b, C=%0b",
                   a, b, out, so[`STATUS_V_BIT], so[`STATUS_N_BIT], so[`STATUS_Z_BIT], so[`STATUS_C_BIT]);

      control = `ALU_NOR;
      #20 $display("!(%0h | %0h) = %0h; V=%0b, N=%0b, Z=%0b, C=%0b",
                   a, b, out, so[`STATUS_V_BIT], so[`STATUS_N_BIT], so[`STATUS_Z_BIT], so[`STATUS_C_BIT]);

      control = `ALU_NAND;
      #20 $display("!(%0h & %0h) = %0h; V=%0b, N=%0b, Z=%0b, C=%0b",
                   a, b, out, so[`STATUS_V_BIT], so[`STATUS_N_BIT], so[`STATUS_Z_BIT], so[`STATUS_C_BIT]);
      
      control = `ALU_ADD;
      a = 'habc;
      b = 'h123;
      #20 $display("%0h + %0h = %0h; V=%0b, N=%0b, Z=%0b, C=%0b",
                   a, b, out, so[`STATUS_V_BIT], so[`STATUS_N_BIT], so[`STATUS_Z_BIT], so[`STATUS_C_BIT]);

      si[`STATUS_C_BIT] = 1;
      #20 $display("%0h + %0h + 1 = %0h; V=%0b, N=%0b, Z=%0b, C=%0b",
                   a, b, out, so[`STATUS_V_BIT], so[`STATUS_N_BIT], so[`STATUS_Z_BIT], so[`STATUS_C_BIT]);

      control = `ALU_SUB;
      #20 $display("%0h - %0h = %0h; V=%0b, N=%0b, Z=%0b, C=%0b",
                   a, b, out, so[`STATUS_V_BIT], so[`STATUS_N_BIT], so[`STATUS_Z_BIT], so[`STATUS_C_BIT]);
    end
endmodule