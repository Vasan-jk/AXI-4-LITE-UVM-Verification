class axi_scoreboard extends uvm_scoreboard;
`uvm_component_utils(axi_scoreboard)

uvm_tlm_analysis_fifo #(axi_seq_item) moninwr_fifo;
uvm_tlm_analysis_fifo #(axi_seq_item) moninrd_fifo;
uvm_tlm_analysis_fifo #(axi_seq_item) monoutwr_fifo;
uvm_tlm_analysis_fifo #(axi_seq_item) monoutrd_fifo;

axi_seq_item monin_tr;
axi_seq_item monout_tr;

bit [31:0] mem [int];

function new(string name = "axi_scoreboard", uvm_component parent);
  super.new(name, parent);
  moninwr_fifo = new("moninwr_fifo", this);
  moninrd_fifo = new("moninrd_fifo", this);
  monoutwr_fifo = new("monoutwr_fifo", this);
  monoutrd_fifo = new("monoutrd_fifo", this);
endfunction


task ref_model_wr(axi_seq_item tr);
     if(tr.AWADDR[1:0] != 2'b00)
        tr.BRESP = 2'b10;
     else if(tr.AWADDR > 32'h3C) 
        tr.BRESP = 2'b11;
     else if(tr.AWADDR >= 32'h28 && tr.AWADDR <= 32'h30)
        tr.BRESP = 2'b10;
     else begin
        for(int i = 0; i < 4; i++) begin
           if(tr.WSTRB[i])  
            mem[tr.AWADDR[5:2]][i*8 +:8] = tr.WDATA[i*8 +:8];
        end
     end
endtask

task ref_model_rd(axi_seq_item tr);
      if(tr.ARADDR[1:0] != 2'b00)
        tr.RRESP = 2'b10;
     else if(tr.ARADDR > 32'h3C)
        tr.RRESP = 2'b11;
     else if(tr.ARADDR >= 32'h34 && tr.ARADDR <= 32'h38)
        tr.RRESP = 2'b10;
     else
        tr.RDATA = mem[tr.ARADDR];
endtask
endclass
