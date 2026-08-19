class axi_master_driver extends uvm_driver#(axi_seq_item);
`uvm_component_utils(axi_driver)
axi_seq_item tr;
axi_config a_cfg;
axi_interface.drv vif;

function new(string name = "axi_driver", uvm_component parent);
  super.new(name, parent);
endfunction

function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  if(!(uvm_config_db#(axi_config)::get(this,"","axi_cfg","a_cfg")))
    `uvm_fatal(get_full_name(),"DRIVER CONFIG NOT CONNECTED")
endfunction

function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  vif = a_cfg.vif;
endfunction

task run_phase(uvm_phase phase);
  repeat(3)@vif.drv_cb.ACLK;
  forever begin
    seq_item_port.get_next_item(req);
      fork
        begin
          fork
            wr_addr(req);
            wr_data(req);
          join
          wr_response(req);
        end
        begin
            rd_addr(req);
            rd_data(req);
        end
      join
    seq_item_port.item_done();
  end
endtask
task wr_addr(axi_seq_item wrar);
  vif.drv_cb.AWADDR <= wrar.AWADDR;
  vif.drv_cb.AWVALID <= wrar.AWVALID;
  vif.drv_cb.AWPROT <= wrar.AWPROT;
  wait(vif.drv_cb.AWREADY);
endtask
task wr_data(axi_seq_item wrdt);
  vif.drv_cb.WDATA <= wrdt.WDATA;
  vif.drv_cb.WSTRB <= wrdt.WSTRB;
  vif.drv_cb.WVALID <= wrdt.WVALID;
  wait(vif.drv_cb.WREADY);
endtask

task wr_response(axi_seq_item wrsp);
  wait(vif.drv_cb.BVALID);
  vif.drv_cb.BREADY <= wrsp.BREADY;
endtask

task rd_addr(axi_seq_item rdar);
  vif.drv_cb.ARADDR <= rdar.ARADDR;
  vif.drv_cb.ARPROT <= rdar.ARPROT;
  vif.drv_cb.ARVALID <= rdar.ARVAILD;
  wait(vif.drv_cb.ARREADY);
endtask

task rd_data(axi_seq_item rddt);
  wait(vif.drv_cb.RVALID);
  vif.drv_cb.RREADY <= rddt.RREADY;
endtask
endclass
