`include "constants.v"

module mux_inst_duplicate (
  //Inputs
  input [`INSN_LEN-1:0] ifu_mux_instruction,

  //Outputs
  output reg [`INSN_LEN-1:0] instruction_dup_0,
  output reg [`INSN_LEN-1:0] instruction_dup_1,
  output reg [`INSN_LEN-1:0] instruction_dup_2,
  output reg [`INSN_LEN-1:0] instruction_dup_3,
  output reg [`INSN_LEN-1:0] instruction_dup_4,
  output reg [`INSN_LEN-1:0] instruction_dup_5,
  output reg [`INSN_LEN-1:0] instruction_dup_6,
  output reg [`INSN_LEN-1:0] instruction_dup_7,
  output reg [3:0] instruction_dup_num
);

//-------------------------------------------------------------
//decode:
  wire [4:0] shamt;
  wire [11:0] imm12;
  wire [4:0] rd;
  wire [2:0] funct3;
  wire [6:0] opcode;
  wire [4:0] rs2;
  wire [6:0] funct7;
  wire [4:0] imm5;
  wire [4:0] rs1;
  wire [6:0] imm7;
  wire [19:0] imm20;
  wire IS_S;
  wire IS_R;
  wire IS_I;
  wire IS_L;
  wire IS_B;
  wire IS_U;
  wire IS_UJ;
  wire IS_JALR;

  assign shamt = ifu_mux_instruction[24:20];
  assign imm12 = ifu_mux_instruction[31:20];
  assign imm20 = ifu_mux_instruction[31:12];
  assign rd = ifu_mux_instruction[11:7];
  assign funct3 = ifu_mux_instruction[14:12];
  assign opcode = ifu_mux_instruction[6:0];
  assign imm7 = ifu_mux_instruction[31:25];
  assign funct7 = ifu_mux_instruction[31:25];
  assign imm5 = ifu_mux_instruction[11:7];
  assign rs1 = ifu_mux_instruction[19:15];
  assign rs2 = ifu_mux_instruction[24:20];

  assign IS_I = (opcode == 7'b0010011);
  assign IS_L = (opcode == 7'b0000011);
  assign IS_S = (opcode == 7'b0100011);
  assign IS_R = (opcode == 7'b0110011);
  assign IS_B = (opcode == 7'b1100011);
  assign IS_U = (opcode == 7'b0110111) || (opcode == 7'b0010111);
  assign IS_UJ = (opcode == 7'b1101111);
  assign IS_JALR = (opcode == 7'b1100111);

//-------------------------------------------------------------
//duplicate:
  wire [`INSN_LEN-1:0] SQED_I;
  wire [`INSN_LEN-1:0] SQED_L;
  wire [`INSN_LEN-1:0] SQED_R;
  wire [`INSN_LEN-1:0] SQED_S;
  wire [`INSN_LEN-1:0] SQED_B;
  wire [`INSN_LEN-1:0] SQED_U;
  wire [`INSN_LEN-1:0] SQED_UJ;
  wire [`INSN_LEN-1:0] SQED_JALR;
  wire [`INSN_LEN-1:0] NOP_INST;
  

  wire [`REG_SEL-1:0] NEW_rd;
  wire [`REG_SEL-1:0] NEW_rs1;
  wire [`REG_SEL-1:0] NEW_rs2;
  wire [11:0] NEW_imm12;
  wire [6:0] NEW_imm7;
  wire [4:0] NEW_imm5;

  assign NEW_rd = (rd == 5'b00000) ? rd : (rd + 12);
  assign NEW_rs1 = (rs1 == 5'b00000) ? rs1 : (rs1 + 12);
  assign NEW_rs2 = (rs2 == 5'b00000) ? rs2 : (rs2 + 12);
  assign NEW_imm12 = {9'b000001, imm12[2:0]};
  assign NEW_imm7 = {6'b000001, imm7[0]}; // signed bit is always zero for lw,sw instructions
  assign NEW_imm5 = {2'b01, imm5[2:0]}; // signed bit is always zero for lw,sw instructions

  //Duplicate instruction
  assign SQED_I = {imm12, NEW_rs1, funct3, NEW_rd, opcode};
  assign SQED_L = {NEW_imm12, rs1, funct3, NEW_rd, opcode};
  assign SQED_R = {funct7, NEW_rs2, NEW_rs1, funct3, NEW_rd, opcode};
  assign SQED_S = {imm7, NEW_rs2, rs1, funct3, NEW_imm5, opcode};
  assign SQED_B = {imm7, NEW_rs2, NEW_rs1, funct3, imm5, opcode};
  assign SQED_U = {imm20,NEW_rd,opcode};
  assign SQED_UJ = {imm20,NEW_rd,opcode};
  assign SQED_JALR = {imm12,NEW_rs1,`FUNCT3_JALR,NEW_rd,opcode};

//-------------------------------------------------------------
// instruction composition:
  assign NOP_INST = 32'h00000013;

  always @(*) begin
    if(IS_I) begin
      instruction_dup_0 = SQED_I;
      instruction_dup_1 = NOP_INST;
      instruction_dup_2 = NOP_INST;
      instruction_dup_3 = NOP_INST;
      instruction_dup_4 = NOP_INST;
      instruction_dup_5 = NOP_INST;
      instruction_dup_6 = NOP_INST;
      instruction_dup_7 = NOP_INST;
      instruction_dup_num = 1;
    end
    else if(IS_L) begin
      instruction_dup_0 = SQED_L;
      instruction_dup_1 = NOP_INST;
      instruction_dup_2 = NOP_INST;
      instruction_dup_3 = NOP_INST;
      instruction_dup_4 = NOP_INST;
      instruction_dup_5 = NOP_INST;
      instruction_dup_6 = NOP_INST;
      instruction_dup_7 = NOP_INST;
      instruction_dup_num = 1;
    end
    else if(IS_R) begin
      instruction_dup_0 = SQED_R;
      instruction_dup_1 = NOP_INST;
      instruction_dup_2 = NOP_INST;
      instruction_dup_3 = NOP_INST;
      instruction_dup_4 = NOP_INST;
      instruction_dup_5 = NOP_INST;
      instruction_dup_6 = NOP_INST;
      instruction_dup_7 = NOP_INST;
      instruction_dup_num = 1;
    end
    else if(IS_S) begin
      instruction_dup_0 = SQED_S;
      instruction_dup_1 = NOP_INST;
      instruction_dup_2 = NOP_INST;
      instruction_dup_3 = NOP_INST;
      instruction_dup_4 = NOP_INST;
      instruction_dup_5 = NOP_INST;
      instruction_dup_6 = NOP_INST;
      instruction_dup_7 = NOP_INST;
      instruction_dup_num = 1;
    end
    else if(IS_B) begin
      instruction_dup_0 = SQED_B;
      instruction_dup_1 = NOP_INST;
      instruction_dup_2 = NOP_INST;
      instruction_dup_3 = NOP_INST;
      instruction_dup_4 = NOP_INST;
      instruction_dup_5 = NOP_INST;
      instruction_dup_6 = NOP_INST;
      instruction_dup_7 = NOP_INST;
      instruction_dup_num = 1;
    end
    else if(IS_U) begin
      instruction_dup_0 = SQED_U;
      instruction_dup_1 = NOP_INST;
      instruction_dup_2 = NOP_INST;
      instruction_dup_3 = NOP_INST;
      instruction_dup_4 = NOP_INST;
      instruction_dup_5 = NOP_INST;
      instruction_dup_6 = NOP_INST;
      instruction_dup_7 = NOP_INST;
      instruction_dup_num = 1;
    end
    else if(IS_UJ) begin
      instruction_dup_0 = SQED_UJ;
      instruction_dup_1 = NOP_INST;
      instruction_dup_2 = NOP_INST;
      instruction_dup_3 = NOP_INST;
      instruction_dup_4 = NOP_INST;
      instruction_dup_5 = NOP_INST;
      instruction_dup_6 = NOP_INST;
      instruction_dup_7 = NOP_INST;
      instruction_dup_num = 1;
    end
    else if(IS_JALR) begin
      instruction_dup_0 = SQED_JALR;
      instruction_dup_1 = NOP_INST;
      instruction_dup_2 = NOP_INST;
      instruction_dup_3 = NOP_INST;
      instruction_dup_4 = NOP_INST;
      instruction_dup_5 = NOP_INST;
      instruction_dup_6 = NOP_INST;
      instruction_dup_7 = NOP_INST;
      instruction_dup_num = 1;
    end
    else begin
      instruction_dup_0 = NOP_INST;
      instruction_dup_1 = NOP_INST;
      instruction_dup_2 = NOP_INST;
      instruction_dup_3 = NOP_INST;
      instruction_dup_4 = NOP_INST;
      instruction_dup_5 = NOP_INST;
      instruction_dup_6 = NOP_INST;
      instruction_dup_7 = NOP_INST;
      instruction_dup_num = 1;
    end
  end

endmodule
