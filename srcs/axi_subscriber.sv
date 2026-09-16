`uvm_analysis_imp_decl(_inwr)
`uvm_analysis_imp_decl(_inrd)
`uvm_analysis_imp_decl(_outwr)
`uvm_analysis_imp_decl(_outrd)

class axi_subscriber extends uvm_component;
  `uvm_component_utils(axi_subscriber)

  uvm_analysis_imp_inwr  #(axi_seq_item, axi_subscriber) ap_inwr;
  uvm_analysis_imp_inrd  #(axi_seq_item, axi_subscriber) ap_inrd;
  uvm_analysis_imp_outwr #(axi_seq_item, axi_subscriber) ap_outwr;
  uvm_analysis_imp_outrd #(axi_seq_item, axi_subscriber) ap_outrd;


  axi_seq_item tr;

  covergroup cg_write;
    option.per_instance = 1;

    awaddr_cp: coverpoint tr.AWADDR {
      bins b1 = {[32'h00000000 : 32'h00000024]};
      bins b2 = {[32'h00000028 : 32'h00000030]};
      bins b3 = {[32'h00000034 : 32'h00000038]};
      bins b4 = {32'h0000003C};
      bins others = default;
    }

    wdata_cp: coverpoint tr.WDATA {
      bins low  = {[32'h0000_0000 : 32'h5555_5555]};
      bins mid  = {[32'h5555_5556 : 32'hAAAA_AAAA]};
      bins high = {[32'hAAAA_AAAB : 32'hFFFF_FFFF]};
    }

    wstrb_cp: coverpoint tr.WSTRB {
      bins b2[] = {[4'b0000 : 4'b1111]};
    }
  endgroup

  covergroup cg_read;
    option.per_instance = 1;

    araddr_cp: coverpoint tr.ARADDR {
      bins b1 = {[32'h00000000 : 32'h00000024]};
      bins b2 = {[32'h00000028 : 32'h00000030]};
      bins b3 = {[32'h00000034 : 32'h00000038]};
      bins b4 = {32'h0000003C};
      bins others = default;
    }
  endgroup

  function new(string name = "axi_subscriber", uvm_component parent);
    super.new(name, parent);
    ap_inwr  = new("ap_inwr",  this);
    ap_inrd  = new("ap_inrd",  this);
    ap_outwr = new("ap_outwr", this);
    ap_outrd = new("ap_outrd", this);
    cg_write = new();
    cg_read  = new();
  endfunction

  function void write_inwr(axi_seq_item t);
    tr = t;
    cg_write.sample();
  endfunction

  function void write_inrd(axi_seq_item t);
    tr = t;
    cg_read.sample();
  endfunction

  function void write_outwr(axi_seq_item t);
    tr = t;
    cg_write.sample();
  endfunction

  function void write_outrd(axi_seq_item t);
    tr = t;
    cg_read.sample();
  endfunction

  function void report_phase(uvm_phase phase);
    `uvm_info("COVERAGE", $sformatf("Write Coverage = %0.2f%% | Read Coverage = %0.2f%%",
                cg_write.get_coverage(), cg_read.get_coverage()), UVM_NONE)
  endfunction

endclass
