interface axi_assertion(
input logic ACLK, 
input logic ARESETn,
input logic [`ADDR_WIDTH-1:0]AWADDR,
input logic AWVALID,
input logic [2:0] AWPROT,
input logic AWREADY,

input logic [`DATA_WIDTH-1:0] WDATA,
input logic [`STRB_WIDTH-1:0] WSTRB,
input logic WVALID,
input logic WREADY,

input logic BREADY,
input logic BVALID,
input logic [1:0]BRESP,

input logic [`ADDR_WIDTH-1:0] ARADDR,
input logic [2:0] ARPROT,
input logic ARVALID,
input logic ARREADY,

input logic RREADY,
input logic [`DATA_WIDTH-1:0]RDATA,
input logic [1:0]RRESP,
input logic RVALID);

property p1;
  @(posedge ACLK) disable iff (!ARESETn)
    (AWVALID && !AWREADY) |=> AWVALID;
endproperty

p1_check: assert property(p1) 
          else $error("awvalid dropped before AWREADY");
endinterface
