class generator;
  
  transactor trans;//handle for transaction class
  mailbox gen2driv;//mailbox declaration
  int repeat_count;

  
  function new(mailbox gen2driv);
    this.gen2driv = gen2driv;
    $display("allocated memory for generator ");
  endfunction
  
  task main();
    repeat(repeat_count) 
      begin
      trans=new();
        trans.randomize();
      gen2driv.put(trans);
    end
  endtask:main
endclass
  
