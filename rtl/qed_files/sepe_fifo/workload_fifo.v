
module workload_fifo #(
 parameter FIFO_WIDTH = 32 ,
 parameter FIFO_DEPTH = 32 , //support 2^PTR_WIDTH depth
 parameter PTR_WIDTH = 5
)
(
 input  clk, rstn,
 input  fifo_rd,

 output [FIFO_WIDTH-1:0] fifo_rdata,
 output fifo_empty
); 

//-------------------------------------------------------------
 reg [PTR_WIDTH-1 :0] rptr; 
 reg [PTR_WIDTH   :0] fifo_cnt;
 reg [FIFO_WIDTH-1:0] fifo [FIFO_DEPTH-1:0];
//---------------------------------------------------------------
always@(posedge clk)begin
 if(~rstn) 
   fifo_cnt <= FIFO_DEPTH;
 else if(fifo_rd)
   fifo_cnt <= fifo_cnt - 1;
end


assign fifo_empty = (fifo_cnt == 0); 
//---------------------------------------------------------------

always@(posedge clk) begin
 if(~rstn)
  rptr <= 0;
 else if (fifo_rd)
  rptr <= rptr + 1;
end

always@(posedge clk) begin
 if (~rstn) begin
   fifo[0]  <= 32'h80000CB7;
   fifo[1]  <= 32'h020c9c93;
   fifo[2]  <= 32'h020cdc93;
   fifo[3]  <= 32'h00100093;
   fifo[4]  <= 32'h00200113;
   fifo[5]  <= 32'h00300193;
   fifo[6]  <= 32'h00400213;
   fifo[7]  <= 32'h00500293;
   fifo[8]  <= 32'h00600313;
   fifo[9]  <= 32'h00700393;
   fifo[10] <= 32'h00800413;
   fifo[11] <= 32'h00900493;
   fifo[12] <= 32'h00a00513;
   fifo[13] <= 32'h00b00593;
   fifo[14] <= 32'h00c00613;
   fifo[15] <= 32'h00100693;
   fifo[16] <= 32'h00200713;
   fifo[17] <= 32'h00300793;
   fifo[18] <= 32'h00400813;
   fifo[19] <= 32'h00500893;
   fifo[20] <= 32'h00600913;
   fifo[21] <= 32'h00700993;
   fifo[22] <= 32'h00800a13;
   fifo[23] <= 32'h00900a93;
   fifo[24] <= 32'h00a00b13;
   fifo[25] <= 32'h00b00b93;
   fifo[26] <= 32'h00c00c13;
   fifo[27] <= 32'h00000013;
   fifo[28] <= 32'h00000013;
   fifo[29] <= 32'h00000013;
   fifo[30] <= 32'h00000013;
   fifo[31] <= 32'h00000013;
 end
end

assign fifo_rdata = fifo[rptr]; 

endmodule
