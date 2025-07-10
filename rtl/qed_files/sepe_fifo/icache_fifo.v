
module icache_fifo #(
 parameter FIFO_WIDTH = 32 ,
 parameter FIFO_DEPTH = 16 , //support 2^PTR_WIDTH depth
 parameter PTR_WIDTH = 4
)
(
 input  clk, rstn,
 input [FIFO_WIDTH-1:0] fifo_wdata,
 input  fifo_wt, fifo_rd,

 output [FIFO_WIDTH-1:0] fifo_rdata,
 output fifo_full, fifo_empty
); 

//-------------------------------------------------------------
 reg [PTR_WIDTH-1 :0] rptr, wptr; 
 reg [PTR_WIDTH   :0] fifo_cnt;
 reg [FIFO_WIDTH-1:0] fifo [FIFO_DEPTH-1:0];
//---------------------------------------------------------------
always@(posedge clk)begin
 if(~rstn) 
   fifo_cnt <= 0;
 else if(fifo_wt & ~fifo_rd)
   fifo_cnt <= fifo_cnt + 1;
 else if(~fifo_wt & fifo_rd)
   fifo_cnt <= fifo_cnt - 1;
 else if(fifo_wt & fifo_rd)
   fifo_cnt <= fifo_cnt ;
end


assign fifo_full  = (fifo_cnt == FIFO_DEPTH);
assign fifo_empty = (fifo_cnt == 0); 
//---------------------------------------------------------------
always@(posedge clk) begin
 if(~rstn) 
  wptr <= 0;
 else if(fifo_wt)
  wptr <= wptr + 1;
end

always@(posedge clk) begin
 if(~rstn)
  rptr <= 0;
 else if (fifo_rd)
  rptr <= rptr + 1;
end

always@(posedge clk) begin
 if (fifo_wt) begin
  fifo[wptr] <= fifo_wdata;
 end
end

assign fifo_rdata = fifo[rptr]; 

endmodule
