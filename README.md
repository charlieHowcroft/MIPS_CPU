# MIPS_CPU
The repository has the following layout.

├── VIVADO_IMPLEMENTATION                  # Folder with all VIVADO performance files 
├── MIPSCOMPONENTS.v                    # ALU, Overflow, Register file, Register, Sign-extend modules
├──  MIPSCOMPONENTS_ALU_tb,v                    # Modified test bench for ALU
├── MIPSSINGLECYCLE.v                    # MIPS Datapath implementation
├── MIPSSINGLECYCLE_tb.v                    # Test bench for MIPS datapath
├── machine_code_generator.asm                    # Assembly file to create machine code with MARS
├── schematic.pdf                    # PDF schematic of VIVADO implementation of our MIPS Datapath (this is excluding the testbenches)
└── …			#All other files (Verilog out etc. Fairly sure you can ignore these)
