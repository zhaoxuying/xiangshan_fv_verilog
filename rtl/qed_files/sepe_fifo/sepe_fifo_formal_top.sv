
module sepe_fifo_formal_top(
  input         clock,
  input         reset_n,
  input  [31:0] instruction,
  input         qed_exec_dup
);

wire reset;
wire [31:0] qed_instruction_out;
wire frontend_reset;
wire qed_vld_out;
wire inst_fifo_rd;
wire [31:0] inst_fifo_rdata;
wire         _difftest_delayer_o_valid  ;
wire         _difftest_delayer_1_o_valid;
wire         _difftest_delayer_2_o_valid;
wire         _difftest_delayer_3_o_valid;
wire         _difftest_delayer_4_o_valid;
wire         _difftest_delayer_5_o_valid;
wire         _difftest_delayer_6_o_valid;
wire         _difftest_delayer_7_o_valid;
wire         _difftest_delayer_o_rfwen  ;
wire         _difftest_delayer_1_o_rfwen;
wire         _difftest_delayer_2_o_rfwen;
wire         _difftest_delayer_3_o_rfwen;
wire         _difftest_delayer_4_o_rfwen;
wire         _difftest_delayer_5_o_rfwen;
wire         _difftest_delayer_6_o_rfwen;
wire         _difftest_delayer_7_o_rfwen;
wire [7:0]   _difftest_delayer_o_wdest  ;
wire [7:0]   _difftest_delayer_1_o_wdest;
wire [7:0]   _difftest_delayer_2_o_wdest;
wire [7:0]   _difftest_delayer_3_o_wdest;
wire [7:0]   _difftest_delayer_4_o_wdest;
wire [7:0]   _difftest_delayer_5_o_wdest;
wire [7:0]   _difftest_delayer_6_o_wdest;
wire [7:0]   _difftest_delayer_7_o_wdest;
wire [63:0]  _difftestArchIntRegState_delayer_o_value_0 ;
wire [63:0]  _difftestArchIntRegState_delayer_o_value_1 ;
wire [63:0]  _difftestArchIntRegState_delayer_o_value_2 ;
wire [63:0]  _difftestArchIntRegState_delayer_o_value_3 ;
wire [63:0]  _difftestArchIntRegState_delayer_o_value_4 ;
wire [63:0]  _difftestArchIntRegState_delayer_o_value_5 ;
wire [63:0]  _difftestArchIntRegState_delayer_o_value_6 ;
wire [63:0]  _difftestArchIntRegState_delayer_o_value_7 ;
wire [63:0]  _difftestArchIntRegState_delayer_o_value_8 ;
wire [63:0]  _difftestArchIntRegState_delayer_o_value_9 ;
wire [63:0]  _difftestArchIntRegState_delayer_o_value_10;
wire [63:0]  _difftestArchIntRegState_delayer_o_value_11;
wire [63:0]  _difftestArchIntRegState_delayer_o_value_12;
wire [63:0]  _difftestArchIntRegState_delayer_o_value_13;
wire [63:0]  _difftestArchIntRegState_delayer_o_value_14;
wire [63:0]  _difftestArchIntRegState_delayer_o_value_15;
wire [63:0]  _difftestArchIntRegState_delayer_o_value_16;
wire [63:0]  _difftestArchIntRegState_delayer_o_value_17;
wire [63:0]  _difftestArchIntRegState_delayer_o_value_18;
wire [63:0]  _difftestArchIntRegState_delayer_o_value_19;
wire [63:0]  _difftestArchIntRegState_delayer_o_value_20;
wire [63:0]  _difftestArchIntRegState_delayer_o_value_21;
wire [63:0]  _difftestArchIntRegState_delayer_o_value_22;
wire [63:0]  _difftestArchIntRegState_delayer_o_value_23;
wire [63:0]  _difftestArchIntRegState_delayer_o_value_24;
wire [63:0]  _difftestArchIntRegState_delayer_o_value_25;
wire [63:0]  _difftestArchIntRegState_delayer_o_value_26;
wire [63:0]  _difftestArchIntRegState_delayer_o_value_27;
wire [63:0]  _difftestArchIntRegState_delayer_o_value_28;
wire [63:0]  _difftestArchIntRegState_delayer_o_value_29;
wire [63:0]  _difftestArchIntRegState_delayer_o_value_30;
wire [63:0]  _difftestArchIntRegState_delayer_o_value_31;

wire commit_valid [0:7];
wire intrf_wen [0:7]; //high valid
wire [4:0] intrf_dest [0:7];
(* keep *)
reg [63:0] intrf [0:31];

assign reset = ~reset_n;
// embed the assumption that there's no reset
// into the generated BTOR2
// we will run the reset sequence in Yosys before generating the BTOR2
// it will complain about the violated assumption, but should work
// fine otherwise
// this is a neg-edge reset, so we assume it is 1.
always @* begin
   no_reset: assume(reset_n);
end
 
// EDIT: Use the inst_constraint module to constrain instruction to be
//       a valid instruction from the ISA
(* keep *) mux_inst_constraints inst_constraint0(
  .clk(clock),
  .instruction(instruction)
);

reg [5:0] warm_up_cnt;
wire qed_ena;
wire workload_fifo_rd;
wire [31:0] workload_fifo_rdata;
wire workload_fifo_empty;
wire qed_fifo_rd;
wire [31:0] qed_fifo_rdata;

always @(posedge clock) begin
  if(reset)  warm_up_cnt <= 6'b0;
  else if(warm_up_cnt!=6'b111111) warm_up_cnt <= warm_up_cnt + 1;
end
assign qed_ena = (warm_up_cnt==6'b111111);
assign qed_fifo_rd = qed_ena ? inst_fifo_rd : 1'b0;
assign workload_fifo_rd = workload_fifo_empty ? 1'b0 : inst_fifo_rd;
assign inst_fifo_rdata = qed_ena ? qed_fifo_rdata : (workload_fifo_rd ? workload_fifo_rdata : 32'h00000013);

 workload_fifo workload_fifo
(
 .clk(clock),
 .rstn(reset_n),
 .fifo_rd(workload_fifo_rd),
 .fifo_rdata(workload_fifo_rdata),
 .fifo_empty(workload_fifo_empty)
);


(* keep *) sepe_fifo_top sepe(
    .ifu_mux_instruction(instruction),
    .ena(qed_ena),    
    .exe_dup(qed_exec_dup),
    .clk(clock),
    .rst(frontend_reset),
    .inst_fifo_rd(qed_fifo_rd),
    .inst_fifo_rdata(qed_fifo_rdata)
);

//debug
//**************************************************************************//
`ifdef EN_DEBUG
`define SIM_TIME 1000
integer file;

initial begin
  file = $fopen("fetch_instruction.txt","w");
  if(file ==0) begin
    $display("Can't open fetch_instruction.txt!");
    $finish;
  end
end

always @(posedge clock) begin
  if(inst_fifo_rd) begin
    $fdisplay(file,"%08h",inst_fifo_rdata);
  end
end

initial begin
  #`SIM_TIME;
  $fclose(file);
  $finish;
end

`endif
//**************************************************************************//

DutTop dut_top(
  .clock(clock),
  .reset(reset),
  .frontend_reset(frontend_reset),
  .inst_fifo_rd(inst_fifo_rd),
  .inst_fifo_rdata(inst_fifo_rdata),
  ._difftest_delayer_o_valid  (_difftest_delayer_o_valid  ),
  ._difftest_delayer_1_o_valid(_difftest_delayer_1_o_valid),
  ._difftest_delayer_2_o_valid(_difftest_delayer_2_o_valid),
  ._difftest_delayer_3_o_valid(_difftest_delayer_3_o_valid),
  ._difftest_delayer_4_o_valid(_difftest_delayer_4_o_valid),
  ._difftest_delayer_5_o_valid(_difftest_delayer_5_o_valid),
  ._difftest_delayer_6_o_valid(_difftest_delayer_6_o_valid),
  ._difftest_delayer_7_o_valid(_difftest_delayer_7_o_valid),
  ._difftest_delayer_o_rfwen  (_difftest_delayer_o_rfwen  ),
  ._difftest_delayer_1_o_rfwen(_difftest_delayer_1_o_rfwen),
  ._difftest_delayer_2_o_rfwen(_difftest_delayer_2_o_rfwen),
  ._difftest_delayer_3_o_rfwen(_difftest_delayer_3_o_rfwen),
  ._difftest_delayer_4_o_rfwen(_difftest_delayer_4_o_rfwen),
  ._difftest_delayer_5_o_rfwen(_difftest_delayer_5_o_rfwen),
  ._difftest_delayer_6_o_rfwen(_difftest_delayer_6_o_rfwen),
  ._difftest_delayer_7_o_rfwen(_difftest_delayer_7_o_rfwen),
  ._difftest_delayer_o_wdest  (_difftest_delayer_o_wdest  ),
  ._difftest_delayer_1_o_wdest(_difftest_delayer_1_o_wdest),
  ._difftest_delayer_2_o_wdest(_difftest_delayer_2_o_wdest),
  ._difftest_delayer_3_o_wdest(_difftest_delayer_3_o_wdest),
  ._difftest_delayer_4_o_wdest(_difftest_delayer_4_o_wdest),
  ._difftest_delayer_5_o_wdest(_difftest_delayer_5_o_wdest),
  ._difftest_delayer_6_o_wdest(_difftest_delayer_6_o_wdest),
  ._difftest_delayer_7_o_wdest(_difftest_delayer_7_o_wdest),
  ._difftestArchIntRegState_delayer_o_value_0 (_difftestArchIntRegState_delayer_o_value_0 ),
  ._difftestArchIntRegState_delayer_o_value_1 (_difftestArchIntRegState_delayer_o_value_1 ),
  ._difftestArchIntRegState_delayer_o_value_2 (_difftestArchIntRegState_delayer_o_value_2 ),
  ._difftestArchIntRegState_delayer_o_value_3 (_difftestArchIntRegState_delayer_o_value_3 ),
  ._difftestArchIntRegState_delayer_o_value_4 (_difftestArchIntRegState_delayer_o_value_4 ),
  ._difftestArchIntRegState_delayer_o_value_5 (_difftestArchIntRegState_delayer_o_value_5 ),
  ._difftestArchIntRegState_delayer_o_value_6 (_difftestArchIntRegState_delayer_o_value_6 ),
  ._difftestArchIntRegState_delayer_o_value_7 (_difftestArchIntRegState_delayer_o_value_7 ),
  ._difftestArchIntRegState_delayer_o_value_8 (_difftestArchIntRegState_delayer_o_value_8 ),
  ._difftestArchIntRegState_delayer_o_value_9 (_difftestArchIntRegState_delayer_o_value_9 ),
  ._difftestArchIntRegState_delayer_o_value_10(_difftestArchIntRegState_delayer_o_value_10),
  ._difftestArchIntRegState_delayer_o_value_11(_difftestArchIntRegState_delayer_o_value_11),
  ._difftestArchIntRegState_delayer_o_value_12(_difftestArchIntRegState_delayer_o_value_12),
  ._difftestArchIntRegState_delayer_o_value_13(_difftestArchIntRegState_delayer_o_value_13),
  ._difftestArchIntRegState_delayer_o_value_14(_difftestArchIntRegState_delayer_o_value_14),
  ._difftestArchIntRegState_delayer_o_value_15(_difftestArchIntRegState_delayer_o_value_15),
  ._difftestArchIntRegState_delayer_o_value_16(_difftestArchIntRegState_delayer_o_value_16),
  ._difftestArchIntRegState_delayer_o_value_17(_difftestArchIntRegState_delayer_o_value_17),
  ._difftestArchIntRegState_delayer_o_value_18(_difftestArchIntRegState_delayer_o_value_18),
  ._difftestArchIntRegState_delayer_o_value_19(_difftestArchIntRegState_delayer_o_value_19),
  ._difftestArchIntRegState_delayer_o_value_20(_difftestArchIntRegState_delayer_o_value_20),
  ._difftestArchIntRegState_delayer_o_value_21(_difftestArchIntRegState_delayer_o_value_21),
  ._difftestArchIntRegState_delayer_o_value_22(_difftestArchIntRegState_delayer_o_value_22),
  ._difftestArchIntRegState_delayer_o_value_23(_difftestArchIntRegState_delayer_o_value_23),
  ._difftestArchIntRegState_delayer_o_value_24(_difftestArchIntRegState_delayer_o_value_24),
  ._difftestArchIntRegState_delayer_o_value_25(_difftestArchIntRegState_delayer_o_value_25),
  ._difftestArchIntRegState_delayer_o_value_26(_difftestArchIntRegState_delayer_o_value_26),
  ._difftestArchIntRegState_delayer_o_value_27(_difftestArchIntRegState_delayer_o_value_27),
  ._difftestArchIntRegState_delayer_o_value_28(_difftestArchIntRegState_delayer_o_value_28),
  ._difftestArchIntRegState_delayer_o_value_29(_difftestArchIntRegState_delayer_o_value_29),
  ._difftestArchIntRegState_delayer_o_value_30(_difftestArchIntRegState_delayer_o_value_30),
  ._difftestArchIntRegState_delayer_o_value_31(_difftestArchIntRegState_delayer_o_value_31)
);

assign commit_valid[0] = _difftest_delayer_o_valid;
assign commit_valid[1] = _difftest_delayer_1_o_valid;
assign commit_valid[2] = _difftest_delayer_2_o_valid;
assign commit_valid[3] = _difftest_delayer_3_o_valid;
assign commit_valid[4] = _difftest_delayer_4_o_valid;
assign commit_valid[5] = _difftest_delayer_5_o_valid;
assign commit_valid[6] = _difftest_delayer_6_o_valid;
assign commit_valid[7] = _difftest_delayer_7_o_valid;

assign intrf_wen[0] = _difftest_delayer_o_rfwen;
assign intrf_wen[1] = _difftest_delayer_1_o_rfwen;
assign intrf_wen[2] = _difftest_delayer_2_o_rfwen;
assign intrf_wen[3] = _difftest_delayer_3_o_rfwen;
assign intrf_wen[4] = _difftest_delayer_4_o_rfwen;
assign intrf_wen[5] = _difftest_delayer_5_o_rfwen;
assign intrf_wen[6] = _difftest_delayer_6_o_rfwen;
assign intrf_wen[7] = _difftest_delayer_7_o_rfwen;

assign intrf_dest[0] = _difftest_delayer_o_wdest[4:0];
assign intrf_dest[1] = _difftest_delayer_1_o_wdest[4:0];
assign intrf_dest[2] = _difftest_delayer_2_o_wdest[4:0];
assign intrf_dest[3] = _difftest_delayer_3_o_wdest[4:0];
assign intrf_dest[4] = _difftest_delayer_4_o_wdest[4:0];
assign intrf_dest[5] = _difftest_delayer_5_o_wdest[4:0];
assign intrf_dest[6] = _difftest_delayer_6_o_wdest[4:0];
assign intrf_dest[7] = _difftest_delayer_7_o_wdest[4:0];

always @(posedge clock) begin
  intrf[0 ] <= _difftestArchIntRegState_delayer_o_value_0 ; 
  intrf[1 ] <= _difftestArchIntRegState_delayer_o_value_1 ; 
  intrf[2 ] <= _difftestArchIntRegState_delayer_o_value_2 ; 
  intrf[3 ] <= _difftestArchIntRegState_delayer_o_value_3 ; 
  intrf[4 ] <= _difftestArchIntRegState_delayer_o_value_4 ; 
  intrf[5 ] <= _difftestArchIntRegState_delayer_o_value_5 ; 
  intrf[6 ] <= _difftestArchIntRegState_delayer_o_value_6 ; 
  intrf[7 ] <= _difftestArchIntRegState_delayer_o_value_7 ; 
  intrf[8 ] <= _difftestArchIntRegState_delayer_o_value_8 ; 
  intrf[9 ] <= _difftestArchIntRegState_delayer_o_value_9 ; 
  intrf[10] <= _difftestArchIntRegState_delayer_o_value_10; 
  intrf[11] <= _difftestArchIntRegState_delayer_o_value_11; 
  intrf[12] <= _difftestArchIntRegState_delayer_o_value_12; 
  intrf[13] <= _difftestArchIntRegState_delayer_o_value_13; 
  intrf[14] <= _difftestArchIntRegState_delayer_o_value_14; 
  intrf[15] <= _difftestArchIntRegState_delayer_o_value_15; 
  intrf[16] <= _difftestArchIntRegState_delayer_o_value_16; 
  intrf[17] <= _difftestArchIntRegState_delayer_o_value_17; 
  intrf[18] <= _difftestArchIntRegState_delayer_o_value_18; 
  intrf[19] <= _difftestArchIntRegState_delayer_o_value_19; 
  intrf[20] <= _difftestArchIntRegState_delayer_o_value_20; 
  intrf[21] <= _difftestArchIntRegState_delayer_o_value_21; 
  intrf[22] <= _difftestArchIntRegState_delayer_o_value_22; 
  intrf[23] <= _difftestArchIntRegState_delayer_o_value_23; 
  intrf[24] <= _difftestArchIntRegState_delayer_o_value_24; 
  intrf[25] <= _difftestArchIntRegState_delayer_o_value_25; 
  intrf[26] <= _difftestArchIntRegState_delayer_o_value_26; 
  intrf[27] <= _difftestArchIntRegState_delayer_o_value_27; 
  intrf[28] <= _difftestArchIntRegState_delayer_o_value_28; 
  intrf[29] <= _difftestArchIntRegState_delayer_o_value_29; 
  intrf[30] <= _difftestArchIntRegState_delayer_o_value_30; 
  intrf[31] <= _difftestArchIntRegState_delayer_o_value_31;
end

 
// EDIT: Insert the qed ready logic -- tracks number of committed instructions
(* keep *)
wire qed_ready;
(* keep *)
reg [15:0] num_orig_insts;
(* keep *)
reg [15:0] num_dup_insts;
(* keep *)
reg [3:0] num_orig_commits;
(* keep *)
reg [3:0] num_dup_commits;
integer i;

always @(*) begin
  num_orig_commits = 0;
  for (i = 0; i < 8; i = i + 1) begin
    if (commit_valid[i] && intrf_wen[i] && (intrf_dest[i] < 5'd13) && (intrf_dest[i] != 0))
      num_orig_commits = num_orig_commits + 1;
  end
end

always @(*) begin
  num_dup_commits = 0;
  for (i = 0; i < 8; i = i + 1) begin
    if (commit_valid[i] && intrf_wen[i] && (intrf_dest[i] >= 5'd13) && (intrf_dest[i] < 5'd25))
      num_dup_commits = num_dup_commits + 1;
  end
end

always @(posedge clock) begin
  if (reset) begin
    num_orig_insts <= 16'b0;
    num_dup_insts <= 16'b0;
  end 
  else begin
    num_orig_insts <= num_orig_insts + {12'b0,num_orig_commits};
    num_dup_insts <= num_dup_insts + {12'b0,num_dup_commits};
  end
end

//assign qed_ready = ((num_orig_insts == num_dup_insts) && num_orig_insts>0 && num_dup_insts>0);
assign qed_ready = ((num_orig_insts == num_dup_insts) && num_orig_insts>12 && num_dup_insts>12);

`ifdef SIM_MODE
reg [3:0] reg7_commit_num, reg19_commit_num;
reg [15:0] reg7_commit_cnt, reg19_commit_cnt;

always @(*) begin
  reg7_commit_num = 0;
  for (i = 0; i < 8; i = i + 1) begin
    if (commit_valid[i] && intrf_wen[i] && (intrf_dest[i] == 5'd7))
      reg7_commit_num = reg7_commit_num + 1;
  end
end

always @(*) begin
  reg19_commit_num = 0;
  for (i = 0; i < 8; i = i + 1) begin
    if (commit_valid[i] && intrf_wen[i] && (intrf_dest[i] == 5'd19))
      reg19_commit_num = reg19_commit_num + 1;
  end
end

always @(posedge clock) begin
  if (reset) begin
    reg7_commit_cnt <= 16'b0;
    reg19_commit_cnt <= 16'b0;
  end 
  else begin
    reg7_commit_cnt <= reg7_commit_cnt + {12'b0,reg7_commit_num};
    reg19_commit_cnt <= reg19_commit_cnt + {12'b0,reg19_commit_num};
  end
end

always @(posedge clock) begin
  if(qed_ready) begin
    sqed: assert property (
          (intrf[7]  == intrf[19]))
        $display("passed at commit = %d",num_orig_insts);
    else
        $error("failed at commit = %d,  reg7_commit_cnt = %d  reg19_commit_cnt = %d",num_orig_insts,reg7_commit_cnt,reg19_commit_cnt);
  end
end

`else

`ifdef VERILATOR_SIM 
sqed: assert property (@(posedge clock) 
  qed_ready |=> (intrf[7] == intrf[19]));

`else
always @(posedge clock) begin
  if(qed_ready) begin
    sqed: assert property (
          (intrf[7]  == intrf[19]) 
          );
  end
end
`endif
`endif

endmodule

