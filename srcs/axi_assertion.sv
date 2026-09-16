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

property p_aw;
  @(posedge ACLK) disable iff (!ARESETn)
    (AWVALID && !AWREADY) |=> AWREADY && $stable(AWADDR) && $stable(AWPROT);
endproperty

p_aw_check: assert property(p_aw)
            else $error("AWVALID dropped or payload changed before AWREADY");


property p_w;
  @(posedge ACLK) disable iff (!ARESETn)
    (WVALID && !WREADY) |=> WREADY && $stable(WDATA) && $stable(WSTRB);
endproperty

p_w_check: assert property(p_w)
           else $error("WVALID dropped or payload changed before WREADY");


property p_b;
  @(posedge ACLK) disable iff (!ARESETn)
    (BVALID && !BREADY) |=> BREADY && $stable(BRESP);
endproperty

p_b_check: assert property(p_b)
           else $error("BVALID dropped or response changed before BREADY");


property p_ar;
  @(posedge ACLK) disable iff (!ARESETn)
    (ARVALID && !ARREADY) |=> ARVALID && $stable(ARADDR) && $stable(ARPROT);
endproperty

p_ar_check: assert property(p_ar)
            else $error("ARVALID dropped or payload changed before ARREADY");


property p_r;
  @(posedge ACLK) disable iff (!ARESETn)
    (RVALID && !RREADY) |=> RVALID && $stable(RDATA) && $stable(RRESP);
endproperty

p_r_check: assert property(p_r)
           else $error("RVALID dropped or payload changed before RREADY");
endinterface
