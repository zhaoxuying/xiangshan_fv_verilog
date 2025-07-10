// Copyright (c) Stanford University
//
// This source code is patent protected and being made available under the
// terms explained in the ../LICENSE-Academic and ../LICENSE-GOV files.

module qed_i_cache (
  // Outputs
  qic_instruction,
  vld_out, 
  exec_dup_r, 
  // Inputs
  clk, 
  rst,
  exec_dup, 
  inst_ren,
  inst_raddr,
  instruction_in
  );

  parameter ICACHESIZE = 128;

  input clk;
  input rst;
  input exec_dup;
  input inst_ren;
  input [63:0] inst_raddr;
  input [31:0] instruction_in;

  output reg vld_out; //currently not used vld_out
  output reg [31:0] qic_instruction;
  output reg exec_dup_r;

  reg [31:0] i_cache[ICACHESIZE-1:0];
  reg [6:0] address_tail;  
  reg [6:0] address_head;
  reg [63:0] prev_inst_raddr;
  reg [31:0] prev_qic_instruction;
  reg prev_exec_dup;

  wire is_empty;
  wire is_full;
  wire is_nop;
  wire insert_cond ;
  wire delete_cond;
  wire [31:0] instruction;

  assign insert_cond = (~rst) & (~exec_dup) & (~is_nop) & inst_ren & (~is_full) & (prev_inst_raddr!=inst_raddr);
  assign delete_cond = (~rst) & (exec_dup) & (~is_empty) & inst_ren & (prev_inst_raddr!=inst_raddr);
  assign is_nop = (instruction_in == 32'h00000013);
  assign is_empty = (address_tail == address_head);
  assign is_full = ((address_tail + 1) == address_head);

  always @(posedge clk) begin
    if (rst) begin
      address_tail <= 7'b0;
      address_head <= 7'b0;
    end 
    else if (insert_cond) begin
      i_cache[address_tail] <= instruction_in;
      address_tail <= address_tail + 1;
    end 
    else if (delete_cond) begin
      address_head <= address_head + 1;
    end
  end

  assign instruction = i_cache[address_head];

//to match the instruction memory behavior, rdata delay 1 cycle after rvalid.
  always @(posedge clk) begin
    if (rst) begin
      qic_instruction <= 32'h0;
      vld_out <= 1'h0;
      exec_dup_r <= 1'b0;
      prev_inst_raddr <= 64'hfffff;
      prev_qic_instruction <= 'b0;
      prev_exec_dup <= 1'b0;
    end
    else if(prev_inst_raddr==inst_raddr) begin
      if(inst_ren) begin 
        qic_instruction <= prev_qic_instruction;
        vld_out <= 1'h1;
        exec_dup_r <= prev_exec_dup;
        prev_inst_raddr <= prev_inst_raddr;
        prev_qic_instruction <= prev_qic_instruction;
        prev_exec_dup <= prev_exec_dup;
      end
      else begin
        qic_instruction <= qic_instruction;
        vld_out <= 1'h0;
        exec_dup_r <= exec_dup_r;
        prev_inst_raddr <= prev_inst_raddr;
        prev_qic_instruction <= prev_qic_instruction;
      end
    end
    else begin
      if(insert_cond) begin
        qic_instruction <= instruction_in;
        vld_out <= 1'h1;
        exec_dup_r <= 1'b0;
        prev_inst_raddr <= inst_raddr;
        prev_qic_instruction <= instruction_in;
        prev_exec_dup <= 1'b0;
      end
      else if(delete_cond) begin
        qic_instruction <= instruction;
        vld_out <= 1'h1;
        exec_dup_r <= 1'b1;
        prev_inst_raddr <= inst_raddr;
        prev_qic_instruction <= instruction;
        prev_exec_dup <= 1'b1;
      end
      else if(inst_ren) begin 
        qic_instruction <= 32'h00000013;
        vld_out <= 1'h1;
        exec_dup_r <= 1'b0;
        prev_inst_raddr <= inst_raddr;
        prev_qic_instruction <= 32'h00000013;
        prev_exec_dup <= 1'b0;
      end
      else begin
        qic_instruction <= 32'h00000013;
        vld_out <= 1'h0;
        exec_dup_r <= 1'b0;
        prev_inst_raddr <= prev_inst_raddr;
        prev_qic_instruction <= prev_qic_instruction;
        prev_exec_dup <= 1'b0;
      end
    end
  end

//debug
//**************************************************************************//
`ifdef EN_DEBUG
`define SIM_TIME 10000
integer file1, file2;

initial begin
  file1 = $fopen("orig_instruction_o.txt","w");
  file2 = $fopen("dump_instruction_o.txt","w");
  if((file1 ==0) || (file2 ==0)) begin
    $display("Can't open orig_instruction_o.txt!");
    $finish;
  end
end

always @(posedge clk) begin
  if(vld_out) begin
    if(exec_dup_r & (prev_inst_raddr!=inst_raddr))
      //$fdisplay(file2,"r_index=%08h, dump_instruction_o=%08h",prev_inst_raddr,qic_instruction);
      $fdisplay(file2,"%08h",qic_instruction);
    else if(~exec_dup_r & (qic_instruction != 32'h00000013) & (prev_inst_raddr!=inst_raddr))
      //$fdisplay(file1,"r_index=%08h, orig_instruction_o=%08h",prev_inst_raddr,qic_instruction);
      $fdisplay(file1,"%08h",qic_instruction);
  end
end

initial begin
  #`SIM_TIME;
  $fclose(file1);
  $fclose(file2);
end

`endif
//**************************************************************************//


endmodule 





