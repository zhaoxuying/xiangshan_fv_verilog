
module mux_inst_fifo #(
 parameter FIFO_WIDTH = 32 ,
 parameter FIFO_DEPTH = 32 , //support 2^PTR_WIDTH depth
 parameter PTR_WIDTH = 5
)
(
 input  clk, rstn,
 input [FIFO_WIDTH-1:0] fifo_wdata_0,
 input [FIFO_WIDTH-1:0] fifo_wdata_1,
 input [FIFO_WIDTH-1:0] fifo_wdata_2,
 input [FIFO_WIDTH-1:0] fifo_wdata_3,
 input [FIFO_WIDTH-1:0] fifo_wdata_4,
 input [FIFO_WIDTH-1:0] fifo_wdata_5,
 input [FIFO_WIDTH-1:0] fifo_wdata_6,
 input [FIFO_WIDTH-1:0] fifo_wdata_7,
 input [3:0] instruction_num,
 input  fifo_wt, fifo_rd,

 output [FIFO_WIDTH-1:0] fifo_rdata_0,
 output [FIFO_WIDTH-1:0] fifo_rdata_1,
 output [FIFO_WIDTH-1:0] fifo_rdata_2,
 output [FIFO_WIDTH-1:0] fifo_rdata_3,
 output [FIFO_WIDTH-1:0] fifo_rdata_4,
 output [FIFO_WIDTH-1:0] fifo_rdata_5,
 output [FIFO_WIDTH-1:0] fifo_rdata_6,
 output [FIFO_WIDTH-1:0] fifo_rdata_7,

 output fifo_almost_full, fifo_almost_empty
); 

//-------------------------------------------------------------
 reg [PTR_WIDTH-1 :0] rptr, wptr; 
 reg [PTR_WIDTH   :0] fifo_cnt;
 reg [FIFO_WIDTH-1:0] fifo [FIFO_DEPTH-1:0];
 wire fifo_full, fifo_empty;
 wire [PTR_WIDTH :0] wptr_0, rptr_0; 
 wire [PTR_WIDTH :0] wptr_1, rptr_1; 
 wire [PTR_WIDTH :0] wptr_2, rptr_2; 
 wire [PTR_WIDTH :0] wptr_3, rptr_3; 
 wire [PTR_WIDTH :0] wptr_4, rptr_4; 
 wire [PTR_WIDTH :0] wptr_5, rptr_5; 
 wire [PTR_WIDTH :0] wptr_6, rptr_6; 
 wire [PTR_WIDTH :0] wptr_7, rptr_7; 
//---------------------------------------------------------------
always@(posedge clk)begin
 if(~rstn) 
   fifo_cnt <= 0;
 else if(fifo_wt & ~fifo_rd)
   fifo_cnt <= fifo_cnt + instruction_num;
 else if(~fifo_wt & fifo_rd)
   fifo_cnt <= fifo_cnt - 8;
 else if(fifo_wt & fifo_rd)
   fifo_cnt <= fifo_cnt - 8 + instruction_num;
end


assign fifo_full  = (fifo_cnt == FIFO_DEPTH);
assign fifo_empty = (fifo_cnt == 0); 
assign fifo_almost_full  = (fifo_cnt > FIFO_DEPTH-8);
assign fifo_almost_empty = (fifo_cnt <= 8); 
//---------------------------------------------------------------
assign wptr_0 = {wptr[PTR_WIDTH-1],wptr} + 0;
assign wptr_1 = {wptr[PTR_WIDTH-1],wptr} + 1;
assign wptr_2 = {wptr[PTR_WIDTH-1],wptr} + 2;
assign wptr_3 = {wptr[PTR_WIDTH-1],wptr} + 3;
assign wptr_4 = {wptr[PTR_WIDTH-1],wptr} + 4;
assign wptr_5 = {wptr[PTR_WIDTH-1],wptr} + 5;
assign wptr_6 = {wptr[PTR_WIDTH-1],wptr} + 6;
assign wptr_7 = {wptr[PTR_WIDTH-1],wptr} + 7;

assign rptr_0 = {rptr[PTR_WIDTH-1],rptr} + 0;
assign rptr_1 = {rptr[PTR_WIDTH-1],rptr} + 1;
assign rptr_2 = {rptr[PTR_WIDTH-1],rptr} + 2;
assign rptr_3 = {rptr[PTR_WIDTH-1],rptr} + 3;
assign rptr_4 = {rptr[PTR_WIDTH-1],rptr} + 4;
assign rptr_5 = {rptr[PTR_WIDTH-1],rptr} + 5;
assign rptr_6 = {rptr[PTR_WIDTH-1],rptr} + 6;
assign rptr_7 = {rptr[PTR_WIDTH-1],rptr} + 7;

always@(posedge clk) begin
 if(~rstn) 
  wptr <= 0;
 else if(fifo_wt)
  wptr <= wptr + instruction_num;
end

always@(posedge clk) begin
 if(~rstn)
  rptr <= 0;
 else if (fifo_rd)
  rptr <= rptr + 8;
end

always@(posedge clk) begin
 if (fifo_wt) begin
  case(instruction_num)
   4'd1: begin
    fifo[wptr_0[PTR_WIDTH-1 :0]] <= fifo_wdata_0;
   end
   4'd2: begin
    fifo[wptr_0[PTR_WIDTH-1 :0]] <= fifo_wdata_0;
    fifo[wptr_1[PTR_WIDTH-1 :0]] <= fifo_wdata_1;
   end
   4'd3: begin
    fifo[wptr_0[PTR_WIDTH-1 :0]] <= fifo_wdata_0;
    fifo[wptr_1[PTR_WIDTH-1 :0]] <= fifo_wdata_1;
    fifo[wptr_2[PTR_WIDTH-1 :0]] <= fifo_wdata_2;
   end
   4'd4: begin
    fifo[wptr_0[PTR_WIDTH-1 :0]] <= fifo_wdata_0;
    fifo[wptr_1[PTR_WIDTH-1 :0]] <= fifo_wdata_1;
    fifo[wptr_2[PTR_WIDTH-1 :0]] <= fifo_wdata_2;
    fifo[wptr_3[PTR_WIDTH-1 :0]] <= fifo_wdata_3;
   end
   4'd5: begin
    fifo[wptr_0[PTR_WIDTH-1 :0]] <= fifo_wdata_0;
    fifo[wptr_1[PTR_WIDTH-1 :0]] <= fifo_wdata_1;
    fifo[wptr_2[PTR_WIDTH-1 :0]] <= fifo_wdata_2;
    fifo[wptr_3[PTR_WIDTH-1 :0]] <= fifo_wdata_3;
    fifo[wptr_4[PTR_WIDTH-1 :0]] <= fifo_wdata_4;
   end
   4'd6: begin
    fifo[wptr_0[PTR_WIDTH-1 :0]] <= fifo_wdata_0;
    fifo[wptr_1[PTR_WIDTH-1 :0]] <= fifo_wdata_1;
    fifo[wptr_2[PTR_WIDTH-1 :0]] <= fifo_wdata_2;
    fifo[wptr_3[PTR_WIDTH-1 :0]] <= fifo_wdata_3;
    fifo[wptr_4[PTR_WIDTH-1 :0]] <= fifo_wdata_4;
    fifo[wptr_5[PTR_WIDTH-1 :0]] <= fifo_wdata_5;
   end
   4'd7: begin
    fifo[wptr_0[PTR_WIDTH-1 :0]] <= fifo_wdata_0;
    fifo[wptr_1[PTR_WIDTH-1 :0]] <= fifo_wdata_1;
    fifo[wptr_2[PTR_WIDTH-1 :0]] <= fifo_wdata_2;
    fifo[wptr_3[PTR_WIDTH-1 :0]] <= fifo_wdata_3;
    fifo[wptr_4[PTR_WIDTH-1 :0]] <= fifo_wdata_4;
    fifo[wptr_5[PTR_WIDTH-1 :0]] <= fifo_wdata_5;
    fifo[wptr_6[PTR_WIDTH-1 :0]] <= fifo_wdata_6;
   end
   4'd8: begin
    fifo[wptr_0[PTR_WIDTH-1 :0]] <= fifo_wdata_0;
    fifo[wptr_1[PTR_WIDTH-1 :0]] <= fifo_wdata_1;
    fifo[wptr_2[PTR_WIDTH-1 :0]] <= fifo_wdata_2;
    fifo[wptr_3[PTR_WIDTH-1 :0]] <= fifo_wdata_3;
    fifo[wptr_4[PTR_WIDTH-1 :0]] <= fifo_wdata_4;
    fifo[wptr_5[PTR_WIDTH-1 :0]] <= fifo_wdata_5;
    fifo[wptr_6[PTR_WIDTH-1 :0]] <= fifo_wdata_6;
    fifo[wptr_7[PTR_WIDTH-1 :0]] <= fifo_wdata_7;
   end
   default: begin
    fifo[wptr_0[PTR_WIDTH-1 :0]] <= fifo_wdata_0;
   end
  endcase 
 end
end

assign fifo_rdata_0 = fifo[rptr_0[PTR_WIDTH-1 :0]]; 
assign fifo_rdata_1 = fifo[rptr_1[PTR_WIDTH-1 :0]]; 
assign fifo_rdata_2 = fifo[rptr_2[PTR_WIDTH-1 :0]]; 
assign fifo_rdata_3 = fifo[rptr_3[PTR_WIDTH-1 :0]]; 
assign fifo_rdata_4 = fifo[rptr_4[PTR_WIDTH-1 :0]]; 
assign fifo_rdata_5 = fifo[rptr_5[PTR_WIDTH-1 :0]]; 
assign fifo_rdata_6 = fifo[rptr_6[PTR_WIDTH-1 :0]]; 
assign fifo_rdata_7 = fifo[rptr_7[PTR_WIDTH-1 :0]]; 


endmodule
