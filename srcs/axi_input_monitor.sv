class axi_input_monitor extends uvm_monitor;
`uvm_component_utils(axi_input_monitor)
axi_config a_cfg;
axi_interface.monin_cb vif;
uvm_analysis_port #(seq_item) in_port;
axi_seq_item tr;

function new(string name = "axi_input_monitor", uvm_component parent);
  super.new(name, parent);
  in_port = new("in_port", this);
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
repeat(6) @(vif.monin_cb);
tr = axi_seq_item::type_id::create("tr");
forever begin
  if(vif.monin_cb.AWVALID && vif.monin_cb.AWREADY) begin
    tr.AWPROT = vif.monin_cb.AWPROT;
    tr.AWADDR = vif.monin_cb.AWADDR;
  end
  if(vif.monin_cb.WVALID && vif.monin_cb.WREADY) begin  
    tr.WDATA = vif.monin_cb.WDATA; 
    tr.WSTRB = vif.monin_cb.WSTRB;
  end
  if(vif.monin_cb.ARVALID && vif.monin_cb.ARREADY) begin
    tr.ARADDR = vif.monin_cb.ARADDR;
  end
  `uvm_info("INPUT_MONITOR",$sformatf("Input MONITOR\n%s",tr.sprint()),UVM_HIGH)
  in_port.write(tr); 
end
endtask
endclass
