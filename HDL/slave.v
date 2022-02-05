module slave(clk,rst,ad,c_be,frame,req64,irdy,trdy,devsel,ack64,stop,par,par64,perr);
input clk,rst;
inout frame,req64,irdy;
inout [63:0]ad;
inout [7:0] c_be;
inout trdy,devsel,ack64,stop;
inout par,par64;
inout perr;

wire [2:0]add1,add2;
wire we1,we,oe,mode,par_e1,par_e2;
wire perr_e1,perr_e2;

data_path slave_data_path(clk,rst,add1,add2,we1,we2,ad,c_be,oe,mode,par,par64,par_e1,par_e2,perr,perr_e1,perr_e2);
fsm slave_fsm(clk,rst,ad,c_be,frame,req64,irdy,trdy,devsel,ack64,add1,add2,we1,we2,oe,mode,stop,par_e1,par_e2,perr_e1,perr_e2);


endmodule 