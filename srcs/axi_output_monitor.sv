class axi_output_monitor extends uvm_monitor;
`uvm_component_utils(axi_output_monitor)
axi_config a_cfg;
axi_interface.monout_cb vif;
uvm_analysis_port #(seq_item) out_port;
axi_seq_item tr;

function new(string name = "axi_output_monitor", uvm_component parent);
  super.new(name, parent);
  out_port = new("out_port", this);
endfunction

function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  if(!(uvm_config_db#(axi_config)::get(this,"","axi_cfg","a_cfg")))
    `uvm_fatal("INPUT_MONITOR","INPUT MONITOR NOT CONFIGURED")
endfunction

function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  vif = a_cfg.vif;
endfunction

task run_phase(uvm_phase phase);
repeat(6) @(vif.monout_cb);
tr = axi_seq_item::type_id::create("tr");
forever begin
 tr.AWREADY = vif.monout_cb.AWREADY;
 tr.WREADY = vif.monout_cb.WREADY;
 tr.BRESP = vif.monout_cb.BRESP; 
 tr.BVALID = vif.monout_cb.BVALID;
 tr.ARREADY = vif.monout_cb.ARREADY;
 tr.RDATA = vif.monout_cb.RDATA; 
 tr.RRESP = vif.monout_cb.RRESP; 
 tr.RVALID = vif.monout_cb.RVALID;
  `uvm_info("OUTPUT_MONITOR",$sformatf("Output MONITOR\n%s",tr.sprint()),UVM_HIGH)
  out_port.write(tr); 
end
endtask
endclass
