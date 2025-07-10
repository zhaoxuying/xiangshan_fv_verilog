`include "constants.v"

module sepe_fifo_top(
    //Inputs
    input [`INSN_LEN-1:0] ifu_mux_instruction,
    input ena,    
    input exe_dup,
    input clk,
    input rst,

    input         inst_fifo_rd,
    output  [31:0]  inst_fifo_rdata
);


  wire [`INSN_LEN-1:0] instruction_dup_0;
  wire [`INSN_LEN-1:0] instruction_dup_1;
  wire [`INSN_LEN-1:0] instruction_dup_2;
  wire [`INSN_LEN-1:0] instruction_dup_3;
  wire [`INSN_LEN-1:0] instruction_dup_4;
  wire [`INSN_LEN-1:0] instruction_dup_5;
  wire [`INSN_LEN-1:0] instruction_dup_6;
  wire [`INSN_LEN-1:0] instruction_dup_7;
  wire [3:0] instruction_dup_num;
  wire dup_fifo_wt, dup_fifo_rd;
  wire dup_fifo_almost_full, dup_fifo_empty;
  wire [`INSN_LEN-1:0] dup_fifo_rdata;
  wire icache_fifo_wt, icache_fifo_rd;
  wire icache_fifo_full, icache_fifo_empty;
  wire [`INSN_LEN-1:0] icache_fifo_wdata;
  wire [`INSN_LEN-1:0] icache_fifo_rdata;
  wire inst_fetch;

  mux_inst_duplicate inst_duplicate(
    .ifu_mux_instruction(ifu_mux_instruction),
  
    .instruction_dup_0(instruction_dup_0),
    .instruction_dup_1(instruction_dup_1),
    .instruction_dup_2(instruction_dup_2),
    .instruction_dup_3(instruction_dup_3),
    .instruction_dup_4(instruction_dup_4),
    .instruction_dup_5(instruction_dup_5),
    .instruction_dup_6(instruction_dup_6),
    .instruction_dup_7(instruction_dup_7),
    .instruction_dup_num(instruction_dup_num)
  );

  wire is_nop;
  wire exe_orig;

  assign is_nop = (ifu_mux_instruction==32'h00000013);
  assign exe_orig = ~exe_dup;

  assign dup_fifo_wt = (~is_nop) & (~dup_fifo_almost_full) & (~rst) & exe_orig & (~icache_fifo_full) & ena;
  assign dup_fifo_rd = (~rst) & exe_dup & (~dup_fifo_empty) & (~icache_fifo_full) & ena;


  dup_inst_fifo dup_inst_fifo(
    .clk(clk), 
    .rstn(~rst),
    .fifo_wdata_0(instruction_dup_0),
    .fifo_wdata_1(instruction_dup_1),
    .fifo_wdata_2(instruction_dup_2),
    .fifo_wdata_3(instruction_dup_3),
    .fifo_wdata_4(instruction_dup_4),
    .fifo_wdata_5(instruction_dup_5),
    .fifo_wdata_6(instruction_dup_6),
    .fifo_wdata_7(instruction_dup_7),
    .instruction_num(instruction_dup_num),
    .fifo_wt(dup_fifo_wt),
 
    .fifo_rd(dup_fifo_rd),
    .fifo_rdata(dup_fifo_rdata),
    .fifo_almost_full(dup_fifo_almost_full), 
    .fifo_empty(dup_fifo_empty)
); 


  assign inst_fetch = inst_fifo_rd;
  assign icache_fifo_wt = ~icache_fifo_full & (dup_fifo_wt | dup_fifo_rd);
  assign icache_fifo_wdata = dup_fifo_wt ? ifu_mux_instruction : (dup_fifo_rd ? dup_fifo_rdata : 32'h00000013);

  assign icache_fifo_rd = inst_fetch & (~icache_fifo_empty);
  assign inst_fifo_rdata = icache_fifo_rd ? icache_fifo_rdata : 32'h00000013;

  icache_fifo icache_fifo (
    .clk(clk), 
    .rstn(~rst),
    .fifo_wdata(icache_fifo_wdata),
    .fifo_wt   (icache_fifo_wt), 
    .fifo_rd   (icache_fifo_rd),

    .fifo_rdata(icache_fifo_rdata),
    .fifo_full(icache_fifo_full), 
    .fifo_empty(icache_fifo_empty)
); 

endmodule
