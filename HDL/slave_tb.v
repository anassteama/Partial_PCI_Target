`timescale 1ns/1ps
module slave_tb_3();
reg clk;
reg rst;
wire [63:0] ad;
wire [7:0] c_be;
wire frame;
wire req64;
wire irdy;
wire trdy;
wire devsel;
wire ack64;
wire stop;
wire par; 
wire par64; 
wire perr;

//
wire [31:0] ad_least,ad_most;
wire [3:0] c_be_least,c_be_most;

wire [3:0]state;

assign ad_least=ad[31:0];
assign ad_most=ad[63:32];
assign c_be_least=c_be[3:0];
assign c_be_most=c_be[7:4];

assign state=dut.slave_fsm.state;
//
slave dut(.clk(clk),.rst(rst),.ad(ad),.c_be(c_be),.frame(frame),.req64(req64),.irdy(irdy),.trdy(trdy),.devsel(devsel),.ack64(ack64),.stop(stop),.par(par),.par64(par64),.perr(perr));
initial begin 
    clk=0;
    forever #50 clk= ~clk;
end
initial begin
//////////////////////////parity error////////////
rst=0;
#200
rst=1;
force stop=1;
force devsel=1;/////
force ack64=1;///////
force req64=0;
force frame=0;
force par=1'bz;
force par64=1'bz;
force ad={32'bz,1'b1,28'b0,3'b000};
force c_be[3:0]=4'b0111;
#100
force ad={31'b0,1'b1,31'b0,1'b0};
force c_be[3:0]=4'b0000;
force c_be[7:4]=4'b0000;
force irdy=0;
#100
//force trdy=0;
force dut.slave_fsm.trdy_assign=0;
release devsel;
release perr;
release ack64;
#100
force ad={29'b0,3'b011,29'b0,3'b010};
force c_be[3:0]=4'b0000;
force c_be[7:4]=4'b0000;
force par=0;
force par64=0;
#100
force ad={29'b0,3'b101,29'b0,3'b100};
force c_be[3:0]=4'b0000;
force c_be[7:4]=4'b0000;
force par=0;
force par64=1;
#100
force frame=1;
force req64=1;
force ad={29'b0,3'b111,29'b0,3'b110};
force c_be[3:0]=4'b0000;
force c_be[7:4]=4'b0000;
force par=1;
force par64=0;
#100
force irdy=1;
//force trdy=1;
force dut.slave_fsm.trdy_assign=1;
force par=1;
force par64=1;
force ad=64'bz;
force c_be=8'bz;
#100
release par;
release par64;

#400 $stop;
//////////////////////read multiple without wait////////////////////////////////////////
//#100
//rst=0;
//#200
//rst=1;
force devsel=1;/////////
#100
force frame=0;
force ad={32'bz,1'b1,28'b0,3'b100};
force c_be[3:0]=4'b1100;
force irdy=1;
//force trdy=1;
force dut.slave_fsm.trdy_assign=1;
#100
force irdy=0;
release ad;
force c_be[2:0]=3'b100;
#100
//force trdy=0;
force dut.slave_fsm.trdy_assign=0;
release devsel;
#200
force frame=1;
#100
force ad=64'bz;
force c_be=8'bz;
force irdy=1;
//force trdy=1;
force dut.slave_fsm.trdy_assign=1;
#300 $stop;
//////////////////////read multiple without wait////////////////////////////////////////
//#100
//rst=0;
//#200
//rst=1;
force devsel=1;/////////
#100
force frame=0;
force ad={32'bz,1'b1,28'b0,3'b111};
force c_be[3:0]=4'b1100;
force irdy=1;
//force trdy=1;
force dut.slave_fsm.trdy_assign=1;
#100
force irdy=0;
release ad;
force c_be[2:0]=3'b100;
#100
//force trdy=0;
force dut.slave_fsm.trdy_assign=0;
release devsel;
#200
force frame=1;
#100
force ad=64'bz;
force c_be=8'bz;
force irdy=1;
//force trdy=1;
force dut.slave_fsm.trdy_assign=1;
#300 $stop;
//////////////////////////////read multiple with wait////////////////////////////////////////////
//rst=0;
//#200 rst=1;
force stop=1;
force perr=1;
force ack64=1;
//force dut.slave_fsm.stop_assign=1;
force frame=1;
force ad=64'bz;
force c_be=8'bz;
force irdy=1;
force dut.slave_fsm.trdy_assign=1;
//force trdy=1;
force devsel=1;
force req64=1;
#100
force frame=0;
force ad={32'bz,1'b1,28'b0,3'b000};
force c_be[3:0]=4'b1100;//##########
#100
force ad=64'bz;
force c_be[2:0]=3'b100;
force irdy=0;
#100
force dut.slave_fsm.trdy_assign=0;
//force trdy=0;
release devsel;
release ad;
#100
force dut.slave_fsm.trdy_assign=1;
//force trdy=0;
#100
force dut.slave_fsm.trdy_assign=0;
//force trdy=0;
#100
force irdy=1;
#100
force irdy=0;
force frame=1;
#100
force ad=64'bz;
force c_be=8'bz;
force irdy=1;
force dut.slave_fsm.trdy_assign=1;
//force trdy=1;
#300 $stop;
//////////////////////////////read multiple with wait////////////////////////////////////////////
//rst=0;
//#200 rst=1;
force stop=1;
force perr=1;
force ack64=1;
//force dut.slave_fsm.stop_assign=1;
force frame=1;
force ad=64'bz;
force c_be=8'bz;
force irdy=1;
force dut.slave_fsm.trdy_assign=1;
//force trdy=1;
force devsel=1;
force req64=1;
#100
force frame=0;
force ad={32'bz,1'b1,28'b0,3'b101};
force c_be[3:0]=4'b1100;//##########
#100
force ad=64'bz;
force c_be[2:0]=3'b100;
force irdy=0;
#100
force dut.slave_fsm.trdy_assign=0;
//force trdy=0;
release devsel;
release ad;
#100
force dut.slave_fsm.trdy_assign=1;
//force trdy=0;
#100
force dut.slave_fsm.trdy_assign=0;
//force trdy=0;
#100
force irdy=1;
#100
force irdy=0;
force frame=1;
#100
force ad=64'bz;
force c_be=8'bz;
force irdy=1;
force dut.slave_fsm.trdy_assign=1;
//force trdy=1;
#300 $stop;
//////////////////////////////read multiple with wait////////////////////////////////////////////
//rst=0;
//#200 rst=1;
force stop=1;
force perr=1;
force ack64=1;
//force dut.slave_fsm.stop_assign=1;
force frame=1;
force ad=64'bz;
force c_be=8'bz;
force irdy=1;
force dut.slave_fsm.trdy_assign=1;
//force trdy=1;
force devsel=1;
force req64=1;
#100
force frame=0;
force ad={32'bz,1'b1,28'b0,3'b111};
force c_be[3:0]=4'b1100;//##########
#100
force ad=64'bz;
force c_be[2:0]=3'b100;
force irdy=0;
#100
force dut.slave_fsm.trdy_assign=0;
//force trdy=0;
release devsel;
release ad;
#100
force dut.slave_fsm.trdy_assign=1;
//force trdy=0;
#100
force dut.slave_fsm.trdy_assign=0;
//force trdy=0;
#100
force irdy=1;
#100
force irdy=0;
force frame=1;
#100
force ad=64'bz;
force c_be=8'bz;
force irdy=1;
force dut.slave_fsm.trdy_assign=1;
//force trdy=1;
#300 $stop;


////////////////////read word with delayed frame
#200
force stop=1;
force devsel=1;////////
force frame=0;
force ad={32'bz,1'b1,28'b0,3'b000};
force c_be[3:0]=4'b0110;
#100
force ad=64'bz;
force c_be[2:0]=3'b110;
force irdy=0;
#100
//force trdy=0;
force dut.slave_fsm.trdy_assign=0;
release devsel;
release ad;
release stop;
#100
//force stop=0;
//force dut.slave_fsm.stop_assign=0;
#100
force frame=1;
#100
force ad=64'bz;
force c_be=8'bz;
force irdy=1;
//force trdy=1;
force dut.slave_fsm.trdy_assign=1;
//force stop=1;
//force dut.slave_fsm.stop_assign=1;
#300 $stop;
////////////////////////read 64 multiple with wait////
#200
force stop=1;
force devsel=1;/////
force ack64=1;///////
force req64=0;
force frame=0;
force ad={32'bz,1'b1,28'b0,3'b000};
force c_be[3:0]=4'b1100;
#100
force ad=64'bz;
force c_be[3:0]=4'b1100;
force c_be[7:4]=4'b1100;
force irdy=0;
#100
release devsel;
//force trdy=0;
force dut.slave_fsm.trdy_assign=0;
release ad;
release ack64;
#100
//force trdy=1;
force dut.slave_fsm.trdy_assign=1;
#100
//force trdy=0;
force dut.slave_fsm.trdy_assign=0;
#100
force irdy=1;
#100
force irdy=0;
force frame=1;
force req64=1;
#100
force irdy=1;
//force trdy=1;
force dut.slave_fsm.trdy_assign=1;
force ad=64'bz;
force c_be=8'bz;
#300 $stop;
////////////////////////read 64 multiple with wait////
#200
force stop=1;
force devsel=1;/////
force ack64=1;///////
force req64=0;
force frame=0;
force ad={32'bz,1'b1,28'b0,3'b110};
force c_be[3:0]=4'b1100;
#100
force ad=64'bz;
force c_be[3:0]=4'b1100;
force c_be[7:4]=4'b1100;
force irdy=0;
#100
release devsel;
//force trdy=0;
force dut.slave_fsm.trdy_assign=0;
release ad;
release ack64;
#100
//force trdy=1;
force dut.slave_fsm.trdy_assign=1;
#100
//force trdy=0;
force dut.slave_fsm.trdy_assign=0;
#100
force irdy=1;
#100
force irdy=0;
force frame=1;
force req64=1;
#100
force irdy=1;
//force trdy=1;
force dut.slave_fsm.trdy_assign=1;
force ad=64'bz;
force c_be=8'bz;
#300 $stop;

///////////////////////write with wait////////
#200 
force stop=1;
force frame=0;
force ad={32'bz,1'b1,28'b0,3'b000};
force c_be[3:0]=4'b0111;
force devsel=1;//////
force ack64=1;///////
force  perr=1;
//force trdy=1;
force dut.slave_fsm.trdy_assign=1;
#100
force irdy=0;
force ad={32'bz,{32{1'b1}}};
force c_be[3:0]=4'b1110;
#100
//force trdy=0;
force dut.slave_fsm.trdy_assign=0;
release devsel;////
#100
force ad={32'bz,{32{1'b1}}};
force c_be[3:0]=4'b1101;
#100
force irdy=1;
//force trdy=1;
force dut.slave_fsm.trdy_assign=1;
#100
force ad={32'bz,{32{1'b1}}};
force c_be[3:0]=4'b1011;
force frame=1;
force irdy=0;
#200
//force trdy=0;
force dut.slave_fsm.trdy_assign=0;
#100
force irdy=1;
//force trdy=1;
force dut.slave_fsm.trdy_assign=1;
force ad=64'bz;
force c_be=8'bz;
#300 $stop;

///////////////////////wrong address////////
#200
force stop=1;
force frame=0;
force ad={32'bz,1'b1,28'b1,3'b000};
force c_be[3:0]=4'b0110;
force irdy=1;
//force trdy=1;
force dut.slave_fsm.trdy_assign=1;
force devsel=1;
#100
release devsel;
release ack64;
force irdy=0;
force ad=64'bz;
force c_be[2:0]=3'b100;
#200
force irdy=1;
force frame=1;
#200
force c_be=8'bz;
#100 $stop;
/////////////read line without wait///////
#200
force frame=0;
force req64=0;
force ad={32'bz,1'b1,28'b0,3'b000};
force c_be[3:0]=4'b1110;
force irdy=1;
//force trdy=1;
force dut.slave_fsm.trdy_assign=1;
force stop=1;
force devsel=1;
force ack64=1;
#100
force irdy=0;
force c_be[3:0]=4'b1111;
force c_be[7:4]=4'b1000;
force ad=64'bz;
#100
release ad;
release devsel;
release ack64;
//force trdy=0;
force dut.slave_fsm.trdy_assign=0;
#100 
force frame=1;
force req64=1;
#100
force ad=64'bz;
force c_be=8'bz;
force irdy=1;
//force trdy=1;
force dut.slave_fsm.trdy_assign=1;
#300 $stop;
/////////////read line without wait///////
#200
force frame=0;
force req64=0;
force ad={32'bz,1'b1,28'b0,3'b100};
force c_be[3:0]=4'b1110;
force irdy=1;
//force trdy=1;
force dut.slave_fsm.trdy_assign=1;
force stop=1;
force devsel=1;
force ack64=1;
#100
force irdy=0;
force c_be[3:0]=4'b1111;
force c_be[7:4]=4'b1000;
force ad=64'bz;
#100
release ad;
release devsel;
release ack64;
//force trdy=0;
force dut.slave_fsm.trdy_assign=0;
#100 
force frame=1;
force req64=1;
#100
force ad=64'bz;
force c_be=8'bz;
force irdy=1;
//force trdy=1;
force dut.slave_fsm.trdy_assign=1;
#300 $stop;
end
endmodule

