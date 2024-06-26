`include "transactor.sv"
`include "generator.sv"
`include "driver.sv"

class environment;
  
 generator gen;//create handle
  driver driv;
  mailbox gen2driv;
  event gen_ended;//event for synchronization between generator and test
  virtual fifo_if vif_ff;
  
  function new(virtual fifo_if vif_ff);
    this.vif_ff = vif_ff;
    $display("environment created");
    endfunction
  
  task build();
    $display("entered into the build phase");
       gen2driv = new();
    //instantiates generator and driver
     gen = new(gen2driv);
    driv = new(vif_ff,gen2driv);
  endtask
  
// pre_test() – Method to call Initialization. i.e, reset method.
  task pre_test();
    driv.reset();
  endtask
  
// test() – Method to call Stimulus Generation and Stimulus Driving.
  task test();
    fork
    gen.main();
    driv.main();
    join
  endtask
  
// post_test() – Method to wait the completion of generation and driving.  
   task post_test();
    wait(gen_ended.triggered);
    wait(gen.repeat_count == driv.no_of_transactions);
  endtask 
  
  task run();
    pre_test();
    test();
    post_test();
    $finish();
  endtask
    
endclass
  
  
