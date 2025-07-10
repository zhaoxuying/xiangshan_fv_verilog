
module DiffExtSyncAIAEvent(
  input         clock,
  input         enable,
  input         io_valid,
  input  [63:0] io_mtopei,
  input  [63:0] io_stopei,
  input  [63:0] io_vstopei,
  input  [63:0] io_hgeip,
  input  [ 7:0] io_coreid
);
`ifndef SYNTHESIS
`ifdef DIFFTEST

import "DPI-C" function void v_difftest_SyncAIAEvent (
  input   longint io_mtopei,
  input   longint io_stopei,
  input   longint io_vstopei,
  input   longint io_hgeip,
  input      byte io_coreid
);


  always @(posedge clock) begin
    if (enable)
      v_difftest_SyncAIAEvent (io_mtopei, io_stopei, io_vstopei, io_hgeip, io_coreid);
  end
`endif
`endif
endmodule
