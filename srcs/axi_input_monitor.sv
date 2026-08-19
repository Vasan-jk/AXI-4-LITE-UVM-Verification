class axi_input_monitor extends uvm_monitor;
`uvm_component_utils(axi_input_monitor)
axi_config a_cfg;
axi_interface.monin_cb vif;

function new(string name = "axi_input_monitor", uvm_component parent);
  super.new(name, parent);
endfunction

function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  if(!(

endclass
