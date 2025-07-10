
module dup_inst_fifo #(
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

 output [FIFO_WIDTH-1:0] fifo_rdata,
 output fifo_almost_full, fifo_empty
); 

//-------------------------------------------------------------
 reg [PTR_WIDTH-1 :0] rptr, wptr; 
 reg [PTR_WIDTH   :0] fifo_cnt;
 reg [FIFO_WIDTH-1:0] fifo [FIFO_DEPTH-1:0];
 wire [PTR_WIDTH :0] wptr_0; 
 wire [PTR_WIDTH :0] wptr_1; 
 wire [PTR_WIDTH :0] wptr_2; 
 wire [PTR_WIDTH :0] wptr_3; 
 wire [PTR_WIDTH :0] wptr_4; 
 wire [PTR_WIDTH :0] wptr_5; 
 wire [PTR_WIDTH :0] wptr_6; 
 wire [PTR_WIDTH :0] wptr_7; 
//---------------------------------------------------------------
always@(posedge clk)begin
 if(~rstn) 
   fifo_cnt <= 0;
 else if(fifo_wt & ~fifo_rd)
   fifo_cnt <= fifo_cnt + instruction_num;
 else if(~fifo_wt & fifo_rd)
   fifo_cnt <= fifo_cnt - 1;
 else if(fifo_wt & fifo_rd)
   fifo_cnt <= fifo_cnt - 1 + instruction_num;
end


assign fifo_empty = (fifo_cnt == 0); 
assign fifo_almost_full  = (fifo_cnt > FIFO_DEPTH-8);
//---------------------------------------------------------------
assign wptr_0 = {wptr[PTR_WIDTH-1],wptr} + 0;
assign wptr_1 = {wptr[PTR_WIDTH-1],wptr} + 1;
assign wptr_2 = {wptr[PTR_WIDTH-1],wptr} + 2;
assign wptr_3 = {wptr[PTR_WIDTH-1],wptr} + 3;
assign wptr_4 = {wptr[PTR_WIDTH-1],wptr} + 4;
assign wptr_5 = {wptr[PTR_WIDTH-1],wptr} + 5;
assign wptr_6 = {wptr[PTR_WIDTH-1],wptr} + 6;
assign wptr_7 = {wptr[PTR_WIDTH-1],wptr} + 7;


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
  rptr <= rptr + 1;
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

assign fifo_rdata = fifo[rptr]; 

endmodule
