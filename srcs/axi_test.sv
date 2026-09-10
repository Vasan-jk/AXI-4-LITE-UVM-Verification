class test extends uvm_test;
`uvm_component_utils(test)
axi_environment env;
axi_config a_cfg;

function new(string name = "axi_test", uvm_component parent);
  super.new(name, parent);  
endfunction

function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  a_cfg = axi_config::type_id::create("a_cfg");
  
  if(!(uvm_config_db#(virtual axi_interface)::get(this,"","axi_if",a_cfg.vif)))
  a_cfg.input_agent_is_active = UVM_ACTIVE;
  a_cfg.output_agent_is_active = UVM_PASSIVE;
  
  uvm_config_db#(axi_config)::set(this,"*","a_cfg",a_cfg);
  env = axi_environment::type_id::create("env", this);
endfunction

function void end_of_elaboration_phase(uvm_phase phase);
  super.end_of_elaboration_phase(phase);
  uvm_top.print_topology();
endfunction

endclass

class base_test extends test;
`uvm_component_utils(base_test)
axi_sequence s;

function new(string name = "base_test", uvm_component parent);
  super.new(name, parent);
endfunction

function void build_phase(uvm_phase phase);
 super.build_phase(phase);
endfunction

task run_phase(uvm_phase phase);
  phase.raise_objection(this);
  s=axi_sequence::type_id::create("s");
  s.start(env_h.inp_agt_h.seq);
  #40; 
  phase.drop_objection(this);
 endtask

endclass
