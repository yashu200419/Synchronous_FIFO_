`include "environment.sv"

program test(fifo_if inf);

  environment env;
  
  initial begin
    env = new(inf);  
    env.build();
    env.gen.repeat_count =3;
    env.pre_test();
    env.test();
    env.post_test();
    env.run();
  end
  
endprogram
