//`define SEPE
`define SEPE_FIFO

module formal_top(
  input         clock,
  input         reset_n,
  input  [31:0] instruction,
  input         qed_exec_dup
);

`ifdef SEPE
sepe_formal_top sepe_formal(
  .clock(clock),
  .reset_n(reset_n),
  .instruction(32'b0),
  .qed_exec_dup(qed_exec_dup)
);

`elsif SEPE_FIFO
sepe_fifo_formal_top sepe_formal(
  .clock(clock),
  .reset_n(reset_n),
  .instruction(instruction),
  .qed_exec_dup(qed_exec_dup)
);

`else
wire reset;
wire [31:0] qed_instruction_out;
wire qed_vld_out;
wire r_enable;
wire [63:0] r_index;
wire [63:0] r_data_0;
wire [63:0] r_data_1;
wire [63:0] r_data_2;
wire [63:0] r_data_3;
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
(* keep *) inst_constraint inst_constraint0(
  .clk(clock),
  .instruction(instruction)
);

// instruction1 and qed_exec_dup are cutpoints
(* keep *) qed qed0 ( // Inputs
  .clk(clock),
  .rst(reset),
  .ena(1'b1),
  .instruction_in(instruction),
  .exec_dup(qed_exec_dup),
  .inst_ren(r_enable),
  .inst_raddr(r_index),
// outputs
  .instruction_out(qed_instruction_out),
  .vld_out(qed_vld_out)
);

assign r_data_0 = {qed_instruction_out,qed_instruction_out};
assign r_data_1 = {qed_instruction_out,qed_instruction_out};
assign r_data_2 = {qed_instruction_out,qed_instruction_out};
assign r_data_3 = {qed_instruction_out,qed_instruction_out};

//debug
//**************************************************************************//
`ifdef EN_DEBUG
`define SIM_TIME 10000
reg r_enable_d;
reg [63:0] r_index_d;
reg [63:0] r_index_pre;
integer file;

always @(posedge clock) begin
  if(reset) begin
    r_enable_d <= 1'b0;
    r_index_d <= 64'b0;
    r_index_pre <= 64'b0;
  end
  else begin
    r_enable_d <= r_enable;
    r_index_d <= r_index;
    r_index_pre <= r_index_d;
  end
end

initial begin
  file = $fopen("fetch_instruction.txt","w");
  if(file ==0) begin
    $display("Can't open fetch_instruction.txt!");
    $finish;
  end
end

always @(posedge clock) begin
  if(r_enable_d) begin
    if(r_index_d!=r_index_pre)
      $fdisplay(file,"r_index=%08h, qed_instruction_out=%08h",r_index_d,qed_instruction_out);
  end
end

initial begin
  #`SIM_TIME;
  $fclose(file);
end

`endif
//**************************************************************************//

DutTop dut_top(
  .clock(clock),
  .reset(reset),
  .r_enable(r_enable),
  .r_index(r_index),
  .r_data_0(r_data_0),
  .r_data_1(r_data_1),
  .r_data_2(r_data_2),
  .r_data_3(r_data_3),
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
    if (commit_valid[i] && intrf_wen[i] && (intrf_dest[i] < 5'd16) && (intrf_dest[i] != 0))
      num_orig_commits = num_orig_commits + 1;
  end
end

always @(*) begin
  num_dup_commits = 0;
  for (i = 0; i < 8; i = i + 1) begin
    if (commit_valid[i] && intrf_wen[i] && (intrf_dest[i] >= 5'd16))
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

assign qed_ready = ((num_orig_insts == num_dup_insts) && num_orig_insts>0 && num_dup_insts>0);

always @(posedge clock) begin
  if(qed_ready) begin
    sqed: assert property (
          (intrf[1]  == intrf[17]) &&
          (intrf[2]  == intrf[18]) &&
          (intrf[3]  == intrf[19]) &&
          (intrf[4]  == intrf[20]) &&
          (intrf[5]  == intrf[21]) &&
          (intrf[6]  == intrf[22]) &&
          (intrf[7]  == intrf[23]) &&
          (intrf[8]  == intrf[24]) &&
          (intrf[9]  == intrf[25]) &&
          (intrf[10] == intrf[26]) &&
          (intrf[11] == intrf[27]) &&
          (intrf[12] == intrf[28]) &&
          (intrf[13] == intrf[29]) &&
          (intrf[14] == intrf[30]) &&
          (intrf[15] == intrf[31]) );
  end
end

`endif

endmodule

