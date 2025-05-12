SimpleRISC Processor – Single Cycle Implementation
This project implements a 32-bit single-cycle RISC processor in Verilog, designed as part of a learning exercise in computer architecture and digital logic design. The processor is modeled after a reduced instruction set computing (RISC) architecture and includes support for arithmetic, logic, memory, and control flow instructions.

🚀 Features
32-bit data path

16 general-purpose registers

Single-cycle instruction execution

256-instruction memory space

Support for:

Arithmetic and logical operations

Load/store instructions

Branch and jump instructions (including unconditional and conditional branches)

Function calls and returns

Modular and scalable design using Verilog

🧩 Top-Level Architecture
The design consists of the following key components:

Module	Description
top_module	Integrates all processor components and connects the datapath and control logic

program_counter	Updates the instruction address each clock cycle

instruction_memory	Stores instructions to be executed (256-instruction capacity)

instruction_decode	Extracts opcode and operands from fetched instruction

immediate_generator	Generates immediate values and branch targets

register__file	16-register general-purpose register file

ALU	Performs all arithmetic and logic operations

memory_unit	Implements data memory for load/store instructions

control_unit	Generates control signals based on the instruction opcode

branch_unit	Determines branch decisions based on flags

flag	Extracts comparison flags (EQ, GT) from ALU output

mux2x1, mux3x1, mux2x1_4bit	Various multiplexers used for datapath selection

pc_plus4	Computes the next sequential PC (PC + 4)
