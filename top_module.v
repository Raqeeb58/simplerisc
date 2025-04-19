///////////////////////////////////////////////////////////////////////////////
// SimpleRisc Processor - Single Cycle Implementation
///////////////////////////////////////////////////////////////////////////////
// Implements a 32-bit  processor with 16 registers and basic instruction set
// Key Features:
// - 32-bit data path
// - 16 general-purpose registers
// - 256-instruction memory capacity
// - Arithmetic, logical, branch, and memory operations
module top_module(clk,rst);
input clk,rst;

// Central Data Bus Connections and  Control Signals
wire [31:0]pcplus4_top,pc_next_top,pc_top,instruction_top,immx_top,branch_target_top,rd1_top,rd2_top,b_top,alu_result_top,pc_branch_top,ldresult_out_top,data_top;
wire [3:0]RS1_top,RS2_top,RD_top,ra_top,rs1_ra_top,rs2_rd_top,rd_ra_top;
wire isbranchtaken_top,isRet_top,isSt_top,isWb_top,isImmediate_top,isBeq_top,isBgt_top,isUbranch_top,isLd_top,isCall_top,GT_flag_top,EQ_flag_top;
wire [4:0]alusignals_top;
wire [1:0]flags_top;

// Program Counter update logic using mux: chooses between PC+4 and branch address
mux2x1 m1(.x(pcplus4_top),.z(pc_branch_top),.sel(isbranchtaken_top |isCall_top |isRet_top),.rst(rst),.y(pc_next_top));
// Program Counter register
program_counter pc1(.clk(clk),.rst(rst),.pcnext(pc_next_top),.pc(pc_top));
// Fetch instruction from memory
instruction_memory im1(.address(pc_top),.instruction(instruction_top));
// Calculate PC+4 for next sequential instruction
pc_plus4 pc41(.clk(clk),.pc(pc_top),.pcplus4(pcplus4_top));
// Decode instruction to extract register addresses
instruction_decode id1(.clk(clk),.rst(rst),.instruction(instruction_top),.RS1(RS1_top),.RS2(RS2_top),.RD(RD_top),.ra(ra_top));
// Generate immediate value and branch target from instruction
immediate_generator ig1(.pc(pc_top),.instruction(instruction_top),.immx(immx_top),.branch_target(branch_target_top));
// Select correct PC for branch/return operations
mux2x1 m6(.x(branch_target_top),.z(rd1_top),.sel(isRet_top  ),.rst(rst),.y(pc_branch_top));
// Generate all control signals from instruction
control_unit cu1(.instruction(instruction_top) ,.isRet(isRet_top),.isSt(isSt_top),.isWb(isWb_top),.isImmediate(isImmediate_top),.alusignals(alusignals_top),.isBeq(isBeq_top),.isBgt(isBgt_top),.isUbranch(isUbranch_top),.isLd(isLd_top),.isCall(isCall_top));
// Multiplexers for register file addressing
mux2x1_4bit m2(.x(RS1_top),.z(ra_top),.sel(isRet_top),.rst(rst),.y(rs1_ra_top));

mux2x1_4bit m3(.x(RS2_top),.z(RD_top),.sel(isSt_top),.rst(rst),.y(rs2_rd_top));

mux2x1_4bit m4(.x(RD_top),.z(ra_top),.sel(isCall_top),.rst(rst),.y(rd_ra_top));
// Register file: holds general-purpose registers
register__file rf1(.clk(clk),.rs1(rs1_ra_top),.rs2(rs2_rd_top),.rd_ra(rd_ra_top),.isWb(isWb_top),.data(data_top),.rd1(rd1_top),.rd2(rd2_top));
// Select ALU operand: register or immediate
mux2x1 m5(.x(rd2_top),.z(immx_top),.sel(isImmediate_top),.rst(rst),.y(b_top));
// ALU: performs arithmetic/logic operations
ALU alu1(.a(rd1_top),.b(b_top),.alusignals(alusignals_top),.result(alu_result_top),.flags(flags_top));
// Flag extraction for branch logic
flag f1(.isCMP(alusignals_top),.flags_in(flags_top),.GT_flag(GT_flag_top),.EQ_flag(EQ_flag_top));
// Branch unit: determines if branch should be taken
branch_unit bu1(.EQ_flag(EQ_flag_top),.GT_flag(GT_flag_top),.isBgt(isBgt_top),.isBeq(isBeq_top),.isUbranch(isUbranch_top),.isBranchtaken(isbranchtaken_top));
// Data memory unit: handles load/store
memory_unit mu1(.clk(clk),.isLd(isLd_top),.isSt(isSt_top),.address(alu_result_top),.data_in(rd2_top),.data_out(ldresult_out_top));
// Select data to write back to register file
mux3x1 m7(.in0(alu_result_top),.in1(ldresult_out_top),.in2(pcplus4_top),.sel({isCall_top,isLd_top}), .out(data_top) );

endmodule
