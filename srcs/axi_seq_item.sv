class axi_seq_item(input ACLK, ARESETn);
rand bit [`ADDR_WIDTH-1:0]AWADDR;
rand bit AWVALID;
rand bit [2:0] AWPROT;
bit AWREADY;

rand bit [`DATA_WIDTH-1:0] WDATA;
rand bit [`STRB_WIDTH-1:0] WSTRB;
rand bit WVALID;
bit WREADY;

rand bit BREADY;
bit BVALID;
bit BRESP;

rand bit [`ADDR_WIDTH-1:0] ARADDR;
rand bit [2:0] ARPROT;
rand bit ARVALID;
bit ARREADY;

rand bit RREADY;
bit RDATA;
bit RRESP;
bit RVALID;
`uvm_object_utils_begin(axi_seq_item)
`uvm_field_int(AWADDR, UVM_ALL_ON)
`uvm_field_int(AWVALID, UVM_ALL_ON)
`uvm_field_int(AWPROT, UVM_ALL_ON)
`uvm_field_int(AWREADY, UVM_ALL_ON)
`uvm_field_int(WDATA, UVM_ALL_ON)
`uvm_field_int(WSTRB, UVM_ALL_ON)
`uvm_field_int(WVALID, UVM_ALL_ON)
`uvm_field_int(WREADY, UVM_ALL_ON)
`uvm_field_int(BREADY, UVM_ALL_ON)
`uvm_field_int(BVALID, UVM_ALL_ON)
`uvm_field_int(BRESP, UVM_ALL_ON)
`uvm_field_int(ARADDR, UVM_ALL_ON)
`uvm_field_int(ARPROT, UVM_ALL_ON)
`uvm_field_int(ARVALID, UVM_ALL_ON)
`uvm_field_int(ARREADY, UVM_ALL_ON)
`uvm_field_int(RREADY, UVM_ALL_ON)
`uvm_field_int(RDATA, UVM_ALL_ON)
`uvm_field_int(RRESP, UVM_ALL_ON)
`uvm_field_int(RVALID, UVM_ALL_ON)
`uvm_object_utils_end

function new(string name = "axi_seq_item");
  super.new(name);
endfunction

endclass
endclass
