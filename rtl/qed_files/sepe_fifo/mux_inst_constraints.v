`include "constants.v"

module mux_inst_constraints (
  // Inputs
  input [`INSN_LEN-1:0] instruction,
  input clk
);

  wire [4:0] shamt;
  wire [11:0] imm12;
  wire [4:0] rd;
  wire [2:0] funct3;
  wire [6:0] opcode;
  wire [6:0] imm7;
  wire [6:0] funct7;
  wire [4:0] imm5;
  wire [4:0] rs1;
  wire [4:0] rs2;

  wire FORMAT_I;
  wire ALLOWED_I;
  wire ANDI;
  wire SLTIU;
  wire SRLI;
  wire SLTI;
  wire SRAI;
  wire SLLI;
  wire ORI;
  wire XORI;
  wire ADDI;

  wire FORMAT_R;
  wire ALLOWED_R;
  wire AND;
  wire SLTU;
  wire MULH;
  wire SRA;
  wire XOR;
  wire SUB;
  wire SLT;
  wire MULHSU;
  wire MULHU;
  wire SRL;
  wire SLL;
  wire ADD;
  wire MUL;
  wire OR;

  wire FORMAT_LW;
  wire ALLOWED_LW;
  wire LW;

  wire FORMAT_SW;
  wire ALLOWED_SW;
  wire SW;

  wire ALLOWED_NOP;
  wire NOP;

  assign shamt = instruction[24:20];
  assign imm12 = instruction[31:20];
  assign rd = instruction[11:7];
  assign funct3 = instruction[14:12];
  assign opcode = instruction[6:0];
  assign imm7 = instruction[31:25];
  assign funct7 = instruction[31:25];
  assign imm5 = instruction[11:7];
  assign rs1 = instruction[19:15];
  assign rs2 = instruction[24:20];

  assign FORMAT_I = (rs1 < 13) && (rd < 13);
  assign ANDI = FORMAT_I && (funct3 == 3'b111) && (opcode == 7'b0010011);
  assign SLTIU = FORMAT_I && (funct3 == 3'b011) && (opcode == 7'b0010011);
  assign SRLI = FORMAT_I && (funct3 == 3'b101) && (opcode == 7'b0010011) && (funct7 == 7'b0000000);
  assign SLTI = FORMAT_I && (funct3 == 3'b010) && (opcode == 7'b0010011);
  assign SRAI = FORMAT_I && (funct3 == 3'b101) && (opcode == 7'b0010011) && (funct7 == 7'b0100000);
  assign SLLI = FORMAT_I && (funct3 == 3'b001) && (opcode == 7'b0010011) && (funct7 == 7'b0000000);
  assign ORI = FORMAT_I && (funct3 == 3'b110) && (opcode == 7'b0010011);
  assign XORI = FORMAT_I && (funct3 == 3'b100) && (opcode == 7'b0010011);
  assign ADDI = FORMAT_I && (funct3 == 3'b000) && (opcode == 7'b0010011);
  assign ALLOWED_I = ANDI || SLTIU || SRLI || SLTI || SRAI || SLLI || ORI || XORI || ADDI;

  assign FORMAT_R = (rs2 < 13) && (rs1 < 13) && (rd < 13);
  assign AND = FORMAT_R && (funct3 == 3'b111) && (opcode == 7'b0110011) && (funct7 == 7'b0000000);
  assign SLTU = FORMAT_R && (funct3 == 3'b011) && (opcode == 7'b0110011) && (funct7 == 7'b0000000);
  assign MULH = FORMAT_R && (funct3 == 3'b001) && (opcode == 7'b0110011) && (funct7 == 7'b0000001);
  assign SRA = FORMAT_R && (funct3 == 3'b101) && (opcode == 7'b0110011) && (funct7 == 7'b0100000);
  assign XOR = FORMAT_R && (funct3 == 3'b100) && (opcode == 7'b0110011) && (funct7 == 7'b0000000);
  assign SUB = FORMAT_R && (funct3 == 3'b000) && (opcode == 7'b0110011) && (funct7 == 7'b0100000);
  assign SLT = FORMAT_R && (funct3 == 3'b010) && (opcode == 7'b0110011) && (funct7 == 7'b0000000);
  assign MULHSU = FORMAT_R && (funct3 == 3'b010) && (opcode == 7'b0110011) && (funct7 == 7'b0000001);
  assign MULHU = FORMAT_R && (funct3 == 3'b011) && (opcode == 7'b0110011) && (funct7 == 7'b0000001);
  assign SRL = FORMAT_R && (funct3 == 3'b101) && (opcode == 7'b0110011) && (funct7 == 7'b0000000);
  assign SLL = FORMAT_R && (funct3 == 3'b001) && (opcode == 7'b0110011) && (funct7 == 7'b0000000);
  assign ADD = FORMAT_R && (funct3 == 3'b000) && (opcode == 7'b0110011) && (funct7 == 7'b0000000);
  assign MUL = FORMAT_R && (funct3 == 3'b000) && (opcode == 7'b0110011) && (funct7 == 7'b0000001);
  assign OR = FORMAT_R && (funct3 == 3'b110) && (opcode == 7'b0110011) && (funct7 == 7'b0000000);
  assign ALLOWED_R = AND || SLTU || MULH || SRA || XOR || SUB || SLT || MULHSU || MULHU || SRL || SLL || ADD || MUL || OR;

  assign FORMAT_LW = (instruction[31:23] == 9'b000000) && (rd < 13);
  assign LW = FORMAT_LW && (funct3 == 3'b010) && (opcode == 7'b0000011) && (rs1 == 5'b00000 || rs1==5'b11001);
  assign ALLOWED_LW = LW;

  assign FORMAT_SW = (instruction[31:25] == 7'b000000) && (instruction[11:10] == 2'b00) && (rs2 < 13);
  assign SW = FORMAT_SW && (funct3 == 3'b010) && (opcode == 7'b0100011) && (rs1 == 5'b00000 || rs1==5'b11001);
  assign ALLOWED_SW = SW;

  assign NOP = (instruction == 32'h00000013);
  assign ALLOWED_NOP = NOP;

`ifdef VERILATOR_SIM
  assume property (@(posedge clk) 
  (ALLOWED_LW || ALLOWED_SW || ADD));
`else
  always @(posedge clk) begin
    //assume property (ALLOWED_I || ALLOWED_LW || ALLOWED_SW || ALLOWED_R || ALLOWED_NOP);
    assume property (ALLOWED_LW || ALLOWED_SW || ADD);
  end
`endif

endmodule
