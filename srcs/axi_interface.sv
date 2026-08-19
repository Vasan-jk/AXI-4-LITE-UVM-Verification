interface axi_interface(input ACLK, ARESETn);
logic [`ADDR_WIDTH-1:0]AWADDR;
logic AWVALID;
logic [2:0] AWPROT;
logic AWREADY;

logic [`DATA_WIDTH-1:0] WDATA;
logic [`STRB_WIDTH-1:0] WSTRB;
logic WVALID;
logic WREADY;

logic BREADY;
logic BVALID;
logic BRESP;

logic [`ADDR_WIDTH-1:0] ARADDR;
logic [2:0] ARPROT;
logic ARVALID;
logic ARREADY;

logic RREADY;
logic RDATA;
logic RRESP;
logic RVALID;

clocking drv_cb(@posedge ACLK);
default input #1 output #0;
input AWREADY, WREADY, BRESP, BVALID, ARREADY, RDATA, RRESP, RVALID;
output AWADDR, AWVALID, AWPROT, WDATA, WSTRB, WVALID, BREADY, ARADDR, ARVALID, RREADY; 
endinterface

clocking monin_cb(@posedge ACLK);
default input #1 output #0;
input AWADDR, AWVALID, AWPROT, WDATA, WSTRB, WVALID, BREADY, ARADDR, ARVALID, RREADY; 
endinterface

clocking monout_cb(@posedge ACLK);
default input #1 output #0;
input AWREADY, WREADY, BRESP, BVALID, ARREADY, RDATA, RRESP, RVALID;
endinterface

modport drv(clocking drv_cb);
modport monin(clocking monin_cb);
modport monout(clocking monout_cb);

endinterface
