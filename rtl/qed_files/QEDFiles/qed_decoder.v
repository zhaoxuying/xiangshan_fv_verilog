// Copyright (c) Stanford University
// 
// This source code is patent protected and being made available under the
// terms explained in the ../LICENSE-Academic and ../LICENSE-GOV files.
//
// Author: Mario J Srouji
// Email: msrouji@stanford.edu

module qed_decoder (
// Outputs
funct7,
funct3,
rd,
rs1,
rs2,
opcode,
shamt,
imm12,
imm7,
imm5,
IS_R,
IS_I,
IS_LW,
IS_SW,
// Inputs
qic_instruction);

  input [31:0] qic_instruction;

  output [6:0] funct7;
  output [2:0] funct3;
  output [4:0] rd;
  output [4:0] rs1;
  output [4:0] rs2;
  output [6:0] opcode;
  output [4:0] shamt;
  output [11:0] imm12;
  output [6:0] imm7;
  output [4:0] imm5;
  output IS_R;
  output IS_I;
  output IS_LW;
  output IS_SW;

  assign funct7 = qic_instruction[31:25];
  assign funct3 = qic_instruction[14:12];
  assign rd = qic_instruction[11:7];
  assign rs1 = qic_instruction[19:15];
  assign rs2 = qic_instruction[24:20];
  assign opcode = qic_instruction[6:0];
  assign shamt = qic_instruction[24:20];
  assign imm12 = qic_instruction[31:20];
  assign imm7 = qic_instruction[31:25];
  assign imm5 = qic_instruction[11:7];

//  assign IS_R = (opcode == 7'b0110011);
//  assign IS_I = (opcode == 7'b0010011);
  assign IS_LW = (opcode == 7'b0000011) && (funct3 == 3'b010);
  assign IS_SW = (opcode == 7'b0100011) && (funct3 == 3'b010);
  assign IS_R = 
  ((opcode == 7'b0110011) && (funct3 == 3'b000) && (funct7 == 7'b0000000)) ||
  ((opcode == 7'b0110011) && (funct3 == 3'b000) && (funct7 == 7'b0100000)) ||
  ((opcode == 7'b0110011) && (funct3 == 3'b001) && (funct7 == 7'b0000000)) ||
  ((opcode == 7'b0110011) && (funct3 == 3'b010) && (funct7 == 7'b0000000)) ||
  ((opcode == 7'b0110011) && (funct3 == 3'b011) && (funct7 == 7'b0000000)) ||
  ((opcode == 7'b0110011) && (funct3 == 3'b100) && (funct7 == 7'b0000000)) ||
  ((opcode == 7'b0110011) && (funct3 == 3'b101) && (funct7 == 7'b0000000)) ||
  ((opcode == 7'b0110011) && (funct3 == 3'b101) && (funct7 == 7'b0100000)) ||
  ((opcode == 7'b0110011) && (funct3 == 3'b110) && (funct7 == 7'b0000000)) ||
  ((opcode == 7'b0110011) && (funct3 == 3'b111) && (funct7 == 7'b0000000)) ||
  ((opcode == 7'b0110011) && (funct3 == 3'b000) && (funct7 == 7'b0000001)) ||
  ((opcode == 7'b0110011) && (funct3 == 3'b001) && (funct7 == 7'b0000001)) ||
  ((opcode == 7'b0110011) && (funct3 == 3'b010) && (funct7 == 7'b0000001)) ||
  ((opcode == 7'b0110011) && (funct3 == 3'b011) && (funct7 == 7'b0000001)) ||
  ((opcode == 7'b0111011) && (funct3 == 3'b000) && (funct7 == 7'b0000000)) ||
  ((opcode == 7'b0111011) && (funct3 == 3'b000) && (funct7 == 7'b0100000)) ||
  ((opcode == 7'b0111011) && (funct3 == 3'b001) && (funct7 == 7'b0000000)) ||
  ((opcode == 7'b0111011) && (funct3 == 3'b101) && (funct7 == 7'b0000000)) ||
  ((opcode == 7'b0111011) && (funct3 == 3'b101) && (funct7 == 7'b0100000)) ||
  ((opcode == 7'b0110011) && (funct3 == 3'b100) && (funct7 == 7'b0000001)) ||
  ((opcode == 7'b0110011) && (funct3 == 3'b101) && (funct7 == 7'b0000001)) ||
  ((opcode == 7'b0110011) && (funct3 == 3'b110) && (funct7 == 7'b0000001)) ||
  ((opcode == 7'b0110011) && (funct3 == 3'b111) && (funct7 == 7'b0000001)) ||
  ((opcode == 7'b0111011) && (funct3 == 3'b000) && (funct7 == 7'b0000001)) ||
  ((opcode == 7'b0111011) && (funct3 == 3'b100) && (funct7 == 7'b0000001)) ||
  ((opcode == 7'b0111011) && (funct3 == 3'b101) && (funct7 == 7'b0000001)) ||
  ((opcode == 7'b0111011) && (funct3 == 3'b110) && (funct7 == 7'b0000001)) ||
  ((opcode == 7'b0111011) && (funct3 == 3'b111) && (funct7 == 7'b0000001));

  assign IS_I =
  ((opcode == 7'b0010011) && (funct3 == 3'b000)) ||
  ((opcode == 7'b0010011) && (funct3 == 3'b010)) ||
  ((opcode == 7'b0010011) && (funct3 == 3'b011)) ||
  ((opcode == 7'b0010011) && (funct3 == 3'b100)) ||
  ((opcode == 7'b0010011) && (funct3 == 3'b110)) ||
  ((opcode == 7'b0010011) && (funct3 == 3'b111)) ||
  ((opcode == 7'b0011011) && (funct3 == 3'b000));


endmodule
