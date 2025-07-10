
`ifdef SYNTHESIS
  `define DISABLE_DIFFTEST_RAM_DPIC
`endif

`ifndef DISABLE_DIFFTEST_RAM_DPIC
import "DPI-C" function longint difftest_ram_read(input longint rIdx);
`endif // DISABLE_DIFFTEST_RAM_DPIC


`ifndef DISABLE_DIFFTEST_RAM_DPIC
import "DPI-C" function void difftest_ram_write
(
  input  longint index,
  input  longint data,
  input  longint mask
);
`endif // DISABLE_DIFFTEST_RAM_DPIC

module MemRWHelper(
  
input             r_enable,
input      [63:0] r_index,
output reg [63:0] r_data,

  
input         w_enable,
input  [63:0] w_index,
input  [63:0] w_data,
input  [63:0] w_mask,

  input clock
);
 
//1KB 
`define RAM_SIZE (1 * 1 * 1024)
reg [63:0] memory [0 : `RAM_SIZE / 8 - 1];
`define MEM_TARGET memory

  always @(*) begin
    r_data = 0;
    if (r_enable) r_data = `MEM_TARGET[r_index];
  end

  always @(posedge clock) begin
    if (w_enable) begin
      `MEM_TARGET[w_index] <= (w_data & w_mask) | (`MEM_TARGET[w_index] & ~w_mask);
    end
  end
endmodule
     
