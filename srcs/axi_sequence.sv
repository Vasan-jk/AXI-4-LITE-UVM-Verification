class axi_sequence extends uvm_sequence#(axi_seq_item);
`uvm_object_utils(axi_sequence)

function new(string name = "axi_sequence");
  super.new(name);
endfunction

task body();
  repeat(`num_of_transaction) begin
  req = axi_seq_item::type_id::create("req");
    start_item(req);
    assert(req.randomize());
    finish_item(req); 
  end
endtask

endclass

class base_write extends uvm_sequence#(axi_seq_item);
`uvm_object_utils(base_write)

function new(string name = "base_write");
  super.new(name);
endfunction

task body();
  repeat(`num_of_transaction) begin
  req = axi_seq_item::type_id::create("req");
    start_item(req);
    assert(req.randomize() with {AWADDR == 16; AWVALID == 1; WDATA == 100; WSTRB == 4'b1111; WVALID == 1; BREADY == 1; ARVALID == 0; RREADY == 0; }  );
    finish_item(req);
  end
endtask

endclass

class base_read extends uvm_sequence#(axi_seq_item);
`uvm_object_utils(base_read)

function new(string name = "base_read");
  super.new(name);
endfunction

task body();
  repeat(`num_of_transaction) begin
  req = axi_seq_item::type_id::create("req");
    start_item(req);
    assert(req.randomize() with {AWVALID == 0; WVALID == 0; ARVALID == 1; ARADDR == 16; RREADY == 1; }  );
    finish_item(req);
  end
endtask

endclass


class write_test extends uvm_sequence#(axi_seq_item);
`uvm_object_utils(write_test)

function new(string name = "base_write");
  super.new(name);
endfunction

task body();
  repeat(`num_of_transaction) begin
  req = axi_seq_item::type_id::create("req");
    start_item(req);
    assert(req.randomize() with {AWADDR % 4 == 0; AWADDR inside{[0:32'h27],32'h3C}; AWVALID == 1; WVALID == 1; BREADY == 1; ARVALID == 0; RREADY == 0; }  );
    finish_item(req);
  end
endtask

endclass

class read_test extends uvm_sequence#(axi_seq_item);
`uvm_object_utils(read_test)
function new(string name = "base_read");
  super.new(name);
endfunction

task body();
  repeat(`num_of_transaction) begin
  req = axi_seq_item::type_id::create("req");
    start_item(req);
    assert(req.randomize() with {AWVALID == 0; WVALID == 0; ARVALID == 1; ARADDR[1:0] == 2'b00; ARADDR inside{[0:32'h27],32'h3C}; RREADY == 1; ARPROT inside {[0:7]}; }  );
    finish_item(req);
  end
endtask

endclass


class read_valid_test extends uvm_sequence#(axi_seq_item);
`uvm_object_utils(read_valid_test)
function new(string name = "base_read");
  super.new(name);
endfunction
bit [31:0] arr [] = {0,4,8,12,16,20,24,28,32,36,40}; 
task body();
  foreach(arr[i]) begin
  req = axi_seq_item::type_id::create("req");
    start_item(req);
    assert(req.randomize() with {AWVALID == 0; WVALID == 0; ARVALID == 1; ARADDR == arr[i]; RREADY == 1; }  );
    finish_item(req);
  end
endtask

endclass

class write_valid_test extends uvm_sequence#(axi_seq_item);
`uvm_object_utils(write_valid_test)

function new(string name = "base_write");
  super.new(name);
endfunction
bit [31:0] arr [] = {0,4,8,12,16,20,24,28,32,36,40,32'h34,32'h38}; 
task body();
  foreach(arr[i]) begin
  req = axi_seq_item::type_id::create("req");
    start_item(req);
    assert(req.randomize() with {AWADDR == arr[i]; AWVALID == 1; WSTRB == 4'b1111; WVALID == 1; BREADY == 1; ARVALID == 0; RREADY == 0; }  );
    finish_item(req);
  end
endtask

endclass

class axi_write_ro_sequence extends axi_sequence;
`uvm_object_utils(axi_write_ro_sequence)
 
function new(string name = "axi_write_ro_sequence");
  super.new(name);
endfunction
 
task body();
  write_ro_seq_new();
endtask
 
task write_ro_seq_new();
  repeat(`num_of_transaction)begin
 
    req = axi_seq_item::type_id::create("req");
    start_item(req);
 
    assert(req.randomize() with {
      AWVALID == 1;
      AWADDR inside {32'h28,32'h2C,32'h30};
      WVALID == 0;
      WSTRB == 4'b1111;
      WDATA == 5;
      BREADY == 0;
      ARVALID == 0;
      RREADY == 0;
    });
 
    finish_item(req);
 
    req = axi_seq_item::type_id::create("req");
    start_item(req);
 
    assert(req.randomize() with {
      AWVALID == 0;
      AWADDR inside {32'h28,32'h2C,32'h30};
      WVALID == 1;
      WSTRB == 4'b1111;
      WDATA inside {[100:200]};
      BREADY == 1;
      ARVALID == 0;
      RREADY == 0;
    });
 
    finish_item(req);
 
  end
endtask
endclass
 
 
class axi_read_wo_sequence extends axi_sequence;
`uvm_object_utils(axi_read_wo_sequence)
 
function new(string name = "axi_read_wo_sequence");
  super.new(name);
endfunction
 
task body();
  read_wo_seq_new();
endtask
 
task read_wo_seq_new();
  repeat(`num_of_transaction)begin
 
    req = axi_seq_item::type_id::create("req");
    start_item(req);
 
    assert(req.randomize() with {
      AWVALID == 0;
      WVALID  == 0;
      BREADY  == 0;
      ARVALID  == 1;
      ARADDR  inside {32'h34,32'h38};
      RREADY  == 1;
    });
 
    finish_item(req);
 
  end
endtask
endclass

class error_addr_write extends uvm_sequence#(axi_seq_item);
`uvm_object_utils(error_addr_write)

function new(string name = "base_write");
  super.new(name);
endfunction

task body();
  repeat(`num_of_transaction) begin
  req = axi_seq_item::type_id::create("req");
    start_item(req);
    assert(req.randomize() with {AWADDR > 32'h3c; AWVALID == 1; WDATA == 100; WSTRB == 4'b1111; WVALID == 1; BREADY == 1; ARVALID == 0; RREADY == 0; }  );
    finish_item(req);
  end
endtask

endclass

class error_addr_read extends uvm_sequence#(axi_seq_item);                                                                           
`uvm_object_utils(error_addr_read)                                                                                                   
function new(string name = "base_read");                                                                                               super.new(name);                                                                                                                   
endfunction                                                                                                                          
                                                                                                                                     task body();                                                                                                                           repeat(`num_of_transaction) begin                                                                                                    req = axi_seq_item::type_id::create("req");                                                                                            start_item(req);                                                                                                                     assert(req.randomize() with {AWVALID == 0; WVALID == 0; ARVALID == 1; ARADDR > 32'h3c; RREADY == 1; }  );
                                                                                                                                    
finish_item(req); 
end
endtask                                                                                                                                                                                                                                                                   endclass


class minmax_addr_write extends uvm_sequence#(axi_seq_item);
`uvm_object_utils(minmax_addr_write)

function new(string name = "base_write");
  super.new(name);
endfunction

task body();
  repeat(`num_of_transaction) begin
  req = axi_seq_item::type_id::create("req");
    start_item(req);
    assert(req.randomize() with {AWADDR inside {32'h0,32'hFFFF_FFFF}; AWVALID == 1; WDATA == 100; WSTRB == 4'b1111; WVALID == 1; BREADY == 1; ARVALID == 0; RREADY == 0; }  );
    finish_item(req);
  end
endtask
endclass

class minmax_addr_read extends uvm_sequence#(axi_seq_item);
`uvm_object_utils(minmax_addr_read)

function new(string name = "base_read");
  super.new(name);
endfunction

task body();
  repeat(`num_of_transaction) begin
  req = axi_seq_item::type_id::create("req");
    start_item(req);
    assert(req.randomize() with {AWVALID == 0; WVALID == 0; ARVALID == 1; ARADDR inside{32'h0,32'hFFFF_FFFF}; RREADY == 1; }  );
    finish_item(req);
  end
endtask

endclass

class wait_write extends uvm_sequence#(axi_seq_item);                                                                                `uvm_object_utils(wait_write)                                                                                                        
function new(string name = "wait_write");                                                                                              super.new(name);
endfunction                                                                                                                          
task body();                                                                                                                           repeat(`num_of_transaction) begin
  req = axi_seq_item::type_id::create("req");                                                                                            start_item(req);
    assert(req.randomize() with {AWADDR % 4 ==0; AWADDR inside{[0:32]}; AWVALID == 1; WDATA == 100; WSTRB == 4'b1111; WVALID == 1; BREADY == 1; ARVALID == 0; RREADY == 0; wt_addr inside{[0:7]}; wt_data inside {[0:7]}; wt_data != wt_addr;});
    finish_item(req);
  end
endtask

endclass

class wait_read extends uvm_sequence#(axi_seq_item);
`uvm_object_utils(wait_read)
function new(string name = "wait_read");
  super.new(name);
endfunction

task body();
  repeat(`num_of_transaction) begin
  req = axi_seq_item::type_id::create("req");
    start_item(req);
    assert(req.randomize() with {AWVALID == 0; WVALID == 0; ARVALID == 1; ARADDR[1:0] == 2'b00; ARADDR inside {[1:32]}; RREADY == 1; wt_addr inside{[0:7]}; }  );
    finish_item(req);
  end
endtask

endclass

class unaligned_addr_wr_test extends uvm_sequence#(axi_seq_item);
`uvm_object_utils(unaligned_addr_wr_test)

function new(string name = "base_write");
  super.new(name);
endfunction

task body();
  repeat(`num_of_transaction) begin
  req = axi_seq_item::type_id::create("req");
    start_item(req);
    assert(req.randomize() with {AWADDR % 4 != 0; AWADDR inside{[1:33]}; AWVALID == 1; WSTRB == 4'b1111; WVALID == 1; BREADY == 1; ARVALID == 0; RREADY == 0; }  );
    finish_item(req);
  end
endtask

endclass

class reserved_write extends uvm_sequence#(axi_seq_item);
`uvm_object_utils(reserved_write)

function new(string name = "base_write");
  super.new(name);
endfunction

task body();
  begin
  req = axi_seq_item::type_id::create("req");
    start_item(req);
    assert(req.randomize() with {AWADDR == 32'h3C; AWVALID == 1; WSTRB == 4'b1111; WVALID == 1; BREADY == 1; ARVALID == 0; RREADY == 0; }  );
    finish_item(req);
  end
endtask

endclass

class reserved_read extends uvm_sequence#(axi_seq_item);
`uvm_object_utils(reserved_read)

function new(string name = "base_read");
  super.new(name);
endfunction

task body();
  begin
  req = axi_seq_item::type_id::create("req");
    start_item(req);
    assert(req.randomize() with {AWVALID == 0; WVALID == 0; ARVALID == 1; ARADDR == 32'h3C; RREADY == 1; }  );
    finish_item(req);
  end
endtask

endclass

class prot_read extends uvm_sequence#(axi_seq_item);
`uvm_object_utils(prot_read)
function new(string name = "prot_read");
  super.new(name);
endfunction

task body();
  for(int i = 0; i < 8; i++) begin
  req = axi_seq_item::type_id::create("req");
    start_item(req);
    assert(req.randomize() with {AWVALID == 0; WVALID == 0; ARVALID == 1; ARADDR == i; ARPROT == i; RREADY == 1; }  );
    finish_item(req);
  end
endtask

endclass
