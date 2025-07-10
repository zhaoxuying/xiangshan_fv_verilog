// Copyright (c) Stanford University
//
// This source code is patent protected and being made available under the
// terms explained in the ../LICENSE-Academic and ../LICENSE-GOV files.

module qed_instruction_mux (
  // Outputs
  instruction_out,
  // Inputs
  qic_instruction, 
  qed_instruction, 
  ena, 
  exec_dup
  );

  input [31:0] qic_instruction;
  input [31:0] qed_instruction;
  input exec_dup;
  input ena;

  output [31:0] instruction_out;

  assign instruction_out = ena ? ((exec_dup == 1'b0) ? qic_instruction : qed_instruction) : qic_instruction;

endmodule 

