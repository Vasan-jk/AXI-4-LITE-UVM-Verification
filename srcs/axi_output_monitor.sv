class axi_output_monitor extends uvm_monitor;
`uvm_component_utils(axi_output_monitor)
axi_config a_cfg;
axi_interface.monout_cb vif;
uvm_analysis_port #(seq_item) outrd_port;
uvm_analysis_port #(seq_item) outwr_port;
axi_seq_item wrtr;
axi_seq_item rdtr;

function new(string name = "axi_output_monitor", uvm_component parent);
  super.new(name, parent);
  outrd_port = new("outwr_port", this);
  outwr_port = new("outrd_port", this);
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
wrtr = axi_seq_item::type_id::create("wrtr");
rdtr = axi_seq_item::type_id::create("rdtr");
forever begin
 if(vif.monout_cb.BVALID && vif.monout_cb.BREADY) begin
  tr.BRESP = vif.monout_cb.BRESP; 
 end
 
 if(vif.monout_cb.RVALID && vif.monout_cb.RREADY) begin
  tr.RDATA = vif.monout_cb.RDATA; 
  tr.RRESP = vif.monout_cb.RRESP; 
 end
  `uvm_info("OUTPUT_MONITOR",$sformatf("Output MONITOR\n%s",tr.sprint()),UVM_HIGH)
  out_port.write(tr); 
end
endtask
endclass
