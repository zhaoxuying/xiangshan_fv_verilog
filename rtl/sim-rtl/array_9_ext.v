
module array_9_ext(
  input RW0_clk,
  input RW0_addr,
  input RW0_en,
  input RW0_wmode,
  input [1:0] RW0_wmask,
  input [95:0] RW0_wdata,
  output [95:0] RW0_rdata
);

  reg reg_RW0_ren;
  reg reg_RW0_addr;
  reg [95:0] ram [1:0];
  `ifdef RANDOMIZE_MEM_INIT
    integer initvar;
    initial begin
      #`RANDOMIZE_DELAY begin end
      for (initvar = 0; initvar < 2; initvar = initvar+1)
        ram[initvar] = {3 {$random}};
      reg_RW0_addr = {1 {$random}};
    end
  `endif
  integer i;
  always @(posedge RW0_clk)
    reg_RW0_ren <= RW0_en && !RW0_wmode;
  always @(posedge RW0_clk)
    if (RW0_en && !RW0_wmode) reg_RW0_addr <= RW0_addr;
  always @(posedge RW0_clk)
    if (RW0_en && RW0_wmode) begin
      for (i=0;i<2;i=i+1) begin
        if (RW0_wmask[i]) begin
          ram[RW0_addr][i*48 +: 48] <= RW0_wdata[i*48 +: 48];
        end
      end
    end
  `ifdef RANDOMIZE_GARBAGE_ASSIGN
  reg [95:0] RW0_random;
  `ifdef RANDOMIZE_MEM_INIT
    initial begin
      #`RANDOMIZE_DELAY begin end
      RW0_random = {$random, $random, $random};
      reg_RW0_ren = RW0_random[0];
    end
  `endif
  always @(posedge RW0_clk) RW0_random <= {$random, $random, $random};
  assign RW0_rdata = reg_RW0_ren ? ram[reg_RW0_addr] : RW0_random[95:0];
  `else
  assign RW0_rdata = ram[reg_RW0_addr];
  `endif

endmodule