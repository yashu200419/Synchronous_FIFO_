class driver;
  virtual fifo_if vif_ff;//Handle for virtual interface
  mailbox gen2driv;
  int no_of_transactions;//to keep track of the number of transactions processed.
  
  function new (virtual fifo_if vif_ff,mailbox gen2driv);
    this.vif_ff = vif_ff;
    this.gen2driv = gen2driv; 
  endfunction
    
  task reset();
    $display(" Entered into reset mode ");
      vif_ff.DRIVER.driver_cb.rst<=1;
      vif_ff.DRIVER.driver_cb.rd_en<=0;
      vif_ff.DRIVER.driver_cb.wdata<=0;
      vif_ff.DRIVER.driver_cb.wr_en<=0;
    repeat(1) @(posedge vif_ff.DRIVER.clk)
      vif_ff.DRIVER.driver_cb.rst<=0;
    repeat(1)@(posedge vif_ff.clk);
    vif_ff.rst<=0;
    $display(" Leaving from reset mode ");
    endtask :reset

  task main(); 
    $display(" Entered into transaction mode");
     forever begin
     transactor trans;//handle of transaction class to get mailbox data
     trans=new();
     gen2driv.get(trans);
     @(posedge vif_ff.DRIVER.clk)
     if(trans.wr_en||trans.rd_en) 
      begin
       if(trans.wr_en) 
        begin
        vif_ff.DRIVER.driver_cb.wr_en<=trans.wr_en;
        vif_ff.DRIVER.driver_cb.rd_en<=trans.rd_en;
        vif_ff.DRIVER.driver_cb.wdata<=trans.wdata;
        $display("\wr_en=%h \wdata=%h",trans.wr_en,trans.wdata);
        @(posedge vif_ff.DRIVER.clk);
        end
       else 
         begin
         vif_ff.DRIVER.driver_cb.wr_en<=trans.wr_en;
         vif_ff.DRIVER.driver_cb.rd_en<=trans.rd_en;
         $display("\rd_en=%h \trdata = %0h",trans.rd_en,trans.rdata);
         end
       no_of_transactions++;
       $display("no.of.transactions=%d",no_of_transactions);
       end
     end
  endtask      
endclass
      
    
    
