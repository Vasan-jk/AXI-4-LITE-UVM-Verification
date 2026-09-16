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
  
  if(!(uvm_config_db#(virtual axi_interface)::get(this,"","axi_if",a_cfg.vif))) begin
    `uvm_fatal("TEST","TEST is not configured")
  end

  a_cfg.input_agent_is_active = UVM_ACTIVE;
  a_cfg.output_agent_is_active = UVM_PASSIVE;
  
  uvm_config_db#(axi_config)::set(this,"*","axi_cfg",a_cfg);
  env = axi_environment::type_id::create("env", this);
endfunction

function void end_of_elaboration_phase(uvm_phase phase);
  super.end_of_elaboration_phase(phase);
  uvm_top.print_topology();
endfunction

endclass

class base_test extends test;
`uvm_component_utils(base_test)
base_read br;
base_write bw;

function new(string name = "base_test", uvm_component parent);
  super.new(name, parent);
endfunction

function void build_phase(uvm_phase phase);
 super.build_phase(phase);
endfunction

task run_phase(uvm_phase phase);
  phase.raise_objection(this);
  bw = base_write::type_id::create("s");
  bw.start(env.inp_agnt.wrsqr);
  br = base_read::type_id::create("r");
  br.start(env.inp_agnt.rdsqr);
  #40; 
  phase.drop_objection(this);
 endtask

endclass

class rewr_test extends test;
`uvm_component_utils(rewr_test)
read_test br;
write_test bw;

function new(string name = "rewr_test", uvm_component parent);
  super.new(name, parent);
endfunction

function void build_phase(uvm_phase phase);
 super.build_phase(phase);
endfunction

task run_phase(uvm_phase phase);
  phase.raise_objection(this);
  fork begin
  bw = write_test::type_id::create("s");
  bw.start(env.inp_agnt.wrsqr);
  end
  begin
  br = read_test::type_id::create("r");
  br.start(env.inp_agnt.rdsqr);
  end
  join
  #40;
  phase.drop_objection(this);
 endtask

endclass

class rewr_valid_test extends test;
`uvm_component_utils(rewr_valid_test)
read_valid_test br;
write_valid_test bw;

function new(string name = "rewr_test", uvm_component parent);
  super.new(name, parent);
endfunction

function void build_phase(uvm_phase phase);
 super.build_phase(phase);
endfunction

task run_phase(uvm_phase phase);
  phase.raise_objection(this);
  fork begin
  bw = write_valid_test::type_id::create("s");
  bw.start(env.inp_agnt.wrsqr);
  end
  begin
  br = read_valid_test::type_id::create("r");
  br.start(env.inp_agnt.rdsqr);
  end
  join
  #40;
  phase.drop_objection(this);
 endtask

endclass

class write_in_read_only extends test;
`uvm_component_utils(write_in_read_only)
axi_write_ro_sequence bw;
function new(string name = "write_in_read_only", uvm_component parent);
  super.new(name, parent);
endfunction

function void build_phase(uvm_phase phase);
 super.build_phase(phase);
endfunction

task run_phase(uvm_phase phase);
  phase.raise_objection(this);
  fork begin
  bw = axi_write_ro_sequence::type_id::create("s");
  bw.start(env.inp_agnt.wrsqr);
  end
  join
  #40;
  phase.drop_objection(this);
 endtask

endclass

class read_in_write_only extends test;
`uvm_component_utils(read_in_write_only)
axi_read_wo_sequence bw;
function new(string name = "read_in_write_only", uvm_component parent);
  super.new(name, parent);
endfunction

function void build_phase(uvm_phase phase);
 super.build_phase(phase);
endfunction

task run_phase(uvm_phase phase);
  phase.raise_objection(this);
  fork begin
  bw = axi_read_wo_sequence::type_id::create("s");
  bw.start(env.inp_agnt.rdsqr);
  end
  join
  #40;
  phase.drop_objection(this);
 endtask

endclass

class write_error_addr extends test;
`uvm_component_utils(write_error_addr)
error_addr_write bw;
function new(string name = "write_error_addr", uvm_component parent);
  super.new(name, parent);
endfunction

function void build_phase(uvm_phase phase);
 super.build_phase(phase);
endfunction

task run_phase(uvm_phase phase);
  phase.raise_objection(this);
  fork begin
  bw = error_addr_write::type_id::create("s");
  bw.start(env.inp_agnt.wrsqr);
  end
  join
  #40;
  phase.drop_objection(this);
 endtask

endclass

class read_error_addr extends test;
`uvm_component_utils(read_error_addr)
error_addr_read bw;
function new(string name = "read_error_addr", uvm_component parent);
  super.new(name, parent);
endfunction

function void build_phase(uvm_phase phase);
 super.build_phase(phase);
endfunction

task run_phase(uvm_phase phase);
  phase.raise_objection(this);
  fork begin
  bw = error_addr_read::type_id::create("s");
  bw.start(env.inp_agnt.rdsqr);
  end
  join
  #40;
  phase.drop_objection(this);
 endtask

endclass

class minmax_addr_test extends test;
`uvm_component_utils(minmax_addr_test)
minmax_addr_read br;
minmax_addr_write bw;

function new(string name = "minmax_addr_test", uvm_component parent);
  super.new(name, parent);
endfunction

function void build_phase(uvm_phase phase);
 super.build_phase(phase);
endfunction

task run_phase(uvm_phase phase);
  phase.raise_objection(this);
  bw = minmax_addr_write::type_id::create("s");
  bw.start(env.inp_agnt.wrsqr);
  br = minmax_addr_read::type_id::create("r");
  br.start(env.inp_agnt.rdsqr);
  #40; 
  phase.drop_objection(this);
 endtask

endclass

class wait_test extends test;
`uvm_component_utils(wait_test)
wait_read br;
wait_write bw;

function new(string name = "wait_test", uvm_component parent);
  super.new(name, parent);
endfunction

function void build_phase(uvm_phase phase);
 super.build_phase(phase);
endfunction

task run_phase(uvm_phase phase);
  phase.raise_objection(this);
  bw = wait_write::type_id::create("s");
  bw.start(env.inp_agnt.wrsqr);
  br = wait_read::type_id::create("r");
  br.start(env.inp_agnt.rdsqr);
  #40;
  phase.drop_objection(this);
 endtask

endclass


class unaligned_test extends test;
`uvm_component_utils(unaligned_test)
read_test br;
write_test wrr;
unaligned_addr_wr_test bw;

function new(string name = "unaligned_test", uvm_component parent);
  super.new(name, parent);
endfunction

function void build_phase(uvm_phase phase);
 super.build_phase(phase);
endfunction

task run_phase(uvm_phase phase);
  phase.raise_objection(this);
  bw = unaligned_addr_wr_test::type_id::create("s");
  br = read_test::type_id::create("r");
  wrr = write_test::type_id::create("wr");
  wrr.start(env.inp_agnt.wrsqr);
  bw.start(env.inp_agnt.wrsqr);
  br.start(env.inp_agnt.rdsqr);
  #40;
  phase.drop_objection(this);
 endtask

endclass

class reserved_addr extends test;
`uvm_component_utils(reserved_addr)
reserved_read br;
reserved_write bw;

function new(string name = "base_test", uvm_component parent);
  super.new(name, parent);
endfunction

function void build_phase(uvm_phase phase);
 super.build_phase(phase);
endfunction

task run_phase(uvm_phase phase);
  phase.raise_objection(this);
  bw = reserved_write::type_id::create("s");
  bw.start(env.inp_agnt.wrsqr);
  br = reserved_read::type_id::create("r");
  br.start(env.inp_agnt.rdsqr);
  #40; 
  phase.drop_objection(this);
 endtask

endclass

class prot_read_addr extends test;
`uvm_component_utils(prot_read_addr)
prot_read bw;
function new(string name = "prot_read_addr", uvm_component parent);
  super.new(name, parent);
endfunction

function void build_phase(uvm_phase phase);
 super.build_phase(phase);
endfunction

task run_phase(uvm_phase phase);
  phase.raise_objection(this);
  fork begin
  bw = prot_read::type_id::create("s");
  bw.start(env.inp_agnt.rdsqr);
  end
  join
  #40;
  phase.drop_objection(this);
 endtask

endclass
