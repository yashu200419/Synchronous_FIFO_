class transactor;
  randc bit rd_en;
  randc bit wr_en;
  randc bit [7:0]wdata;
  bit [7:0]rdata;
  bit full;
  bit empty; 
//constraint, to generate any one among write and read
  constraint rd_wr_en{ rd_en!= wr_en;}
endclass
