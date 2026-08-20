class axi_scoreboard extends uvm_scoreboard;
`uvm_component_utils(axi_scoreboard)

uvm_tlm_analysis_fifo #(axi_seq_item) monin_fifo;
uvm_tlm_analysis_fifo #(axi_seq_item) monout_fifo;

axi_seq_item monin_tr;
axi_seq_item monout_tr;

int mem [int];

function new(string name = "axi_scoreboard", uvm_component parent);
  super.new(name, parent);
  monin_fifo = new("monin_fifo", this);
  monout_fifo = new("monout_fifo", this);
endfunction


task ref_model_wr(axi_seq_item tr);
    if(tr.
endtask
endclass
