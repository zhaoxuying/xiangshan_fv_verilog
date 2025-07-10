// Copyright (c) Stanford University
// 
// This source code is patent protected and being made available under the
// terms explained in the ../LICENSE-Academic and ../LICENSE-GOV files.
//
// Author: Mario J Srouji
// Email: msrouji@stanford.edu

module qed (
// Outputs
instruction_out,
vld_out,
// Inputs
clk,
instruction_in,
rst,
ena,
exec_dup,
inst_ren,inst_raddr);

  input clk;
  input [31:0] instruction_in;
  input rst;
  input ena;
  input exec_dup;
  input inst_ren;
  input [63:0] inst_raddr;

  output [31:0] instruction_out;
  output vld_out;
  wire [6:0] funct7;
  wire [2:0] funct3;
  wire [4:0] rd;
  wire [4:0] rs1;
  wire [4:0] rs2;
  wire [6:0] opcode;
  wire [4:0] shamt;
  wire [11:0] imm12;
  wire [6:0] imm7;
  wire [4:0] imm5;

  wire IS_R;
  wire IS_I;
  wire IS_LW;
  wire IS_SW;

  wire [31:0] qed_instruction;
  wire [31:0] qic_instruction;
  wire exec_dup_r;

  qed_decoder dec (.qic_instruction(qic_instruction),
                   .funct7(funct7),
                   .funct3(funct3),
                   .rd(rd),
                   .rs1(rs1),
                   .rs2(rs2),
                   .opcode(opcode),
                   .shamt(shamt),
                   .imm12(imm12),
                   .imm7(imm7),
                   .imm5(imm5),
                   .IS_R(IS_R),
                   .IS_I(IS_I),
                   .IS_LW(IS_LW),
                   .IS_SW(IS_SW));

  modify_instruction minst (.qed_instruction(qed_instruction),
                            .qic_instruction(qic_instruction),
                            .funct7(funct7),
                            .funct3(funct3),
                            .rd(rd),
                            .rs1(rs1),
                            .rs2(rs2),
                            .opcode(opcode),
                            .shamt(shamt),
                            .imm12(imm12),
                            .imm7(imm7),
                            .imm5(imm5),
                            .IS_R(IS_R),
                            .IS_I(IS_I),
                            .IS_LW(IS_LW),
                            .IS_SW(IS_SW));

  qed_instruction_mux imux (.instruction_out(instruction_out),
                            .qic_instruction(qic_instruction),
                            .qed_instruction(qed_instruction),
                            .exec_dup(exec_dup_r),
                            .ena(ena));

  qed_i_cache qic (.qic_instruction(qic_instruction),
                   .vld_out(vld_out),
                   .exec_dup_r(exec_dup_r),
                   .clk(clk),
                   .rst(rst),
                   .exec_dup(exec_dup),
                   .inst_ren(inst_ren),
                   .inst_raddr(inst_raddr),
                   .instruction_in(instruction_in));

endmodule
