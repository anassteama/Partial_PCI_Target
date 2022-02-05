module fsm(clk,rst,ad,c_be,frame,req64,irdy,trdy,devsel,ack64,add1,add2,we1,we2,oe,mode,stop,par_e1,par_e2,perr_e1,perr_e2);
input clk,rst,frame,req64,irdy;
input [63:0] ad;
input [7:0] c_be;
output devsel,ack64,trdy;
output reg we1,we2;
output oe;
output [2:0] add1,add2;
output mode,stop;
output reg par_e1,par_e2,perr_e1,perr_e2;

localparam s0=0;
localparam s1=1;
localparam s2=2;
localparam s3=3;
localparam s4=4;
localparam s5=5;
localparam s6=6;
localparam s7=7;
localparam s8=8;

localparam range=29'h10000000;

reg mode64,stop_reg;
reg trdy_assign;
reg [3:0] state,next_state;
reg [3:0] command;
reg [31:0] address;
//wire devsel_ass,ack64_ass;
reg devsel_temp,ack64_temp;
reg [2:0]add1_reg,add2_reg;
reg oe_reg,irdy_reg;
reg se;
reg [1:0]counter;

assign mode=mode64;
assign oe=oe_reg;
assign devsel=(se)?devsel_temp:1'bz;
assign ack64=(se)?ack64_temp:1'bz;
assign trdy=trdy_assign;

assign add1=add1_reg;
assign add2=add2_reg;

always@(negedge clk)
begin
	perr_e1<=(state==s7|state==s8)?1:0;
	perr_e2<=((state==s7|state==s8)&!mode64)?1:0;
end

always@(negedge clk)
begin
	par_e1<=(state==s2|state==s3|state==s5|state==s6)?1:0;
	par_e2<=((state==s2|state==s3|state==s5|state==s6)&!mode64)?1:0;
end
always@(posedge clk)
irdy_reg<=irdy;

always@(negedge clk)
begin
	if (state==s2|state==s7)
	begin
		add1_reg<=address[2:0];
		add2_reg<=address[2:0]+1;
		counter<=0;
	end
	else if (((state==s3)|(state==s5)|(state==s8))&(!irdy_reg)&(!trdy_assign)&(!mode64))
	begin
		add1_reg<=add1_reg+2;
		add2_reg<=add2_reg+2;
		counter<=counter+2;
	end
	else if (((state==s3)|(state==s5)|(state==s8))&(!irdy_reg)&(!trdy_assign)&(mode64))
	begin
		add1_reg<=add1_reg+1;
		add2_reg<=add2_reg+1;
		counter<=counter+1;
	end
end

always@(negedge clk)
begin
if(state==s2|state==s3|state==s5|state==s6)
	oe_reg<=1;
else 
	oe_reg<=0;
end

always@(negedge clk)
begin
if(state==s2|state==s3|state==s4|state==s5|state==s6|state==s7|state==s8)
	se<=1;
else 
	se<=0;
end
/*
assign devsel_ass=(state==s2|state==s3)?0:1;
assign ack64_ass=((state==s2|state==s3)&!mode64)?0:1;
*/
//assign s_e=(state==s2|state==s3|state==s4)?1:0;



always@(negedge clk)
begin
	if (state==s2|state==s3|state==s5|state==s6|state==s7|state==s8)
		devsel_temp<=0;
	else 
		devsel_temp<=1;
end

always@(negedge clk)
begin
	if ((state==s2|state==s3|state==s5|state==s6|state==s7|state==s8)&!mode64)
		ack64_temp<=0;
	else 
		ack64_temp<=1;
end

always@(posedge clk)
begin
if (!frame&&state==s0)
begin
	address<=ad[31:0];
	command<=c_be[3:0];
end
end

always@(*)
begin 
	if((state==s7|state==s8)&(!irdy_reg)&(!trdy_assign))
		we1=1;
	else
		we1=0;
end

always@(*)
begin 
	if((state==s7|state==s8)&(!irdy_reg)&(!trdy_assign)&!mode)
		we2=1;
	else
		we2=0;
end

always@(posedge clk)
begin
	if(state==s0)
		mode64<=req64;
	else if(state==s4)
		mode64<=1;
end


always@(posedge clk,negedge rst)
begin
if (!rst)
	state<=s0;
else 
	state<=next_state;

end

always@(negedge clk)
begin 
	if(state==s6)
		stop_reg<=0;
	else
		stop_reg<=1;
end

assign stop=stop_reg;

always@(*)
begin
case (state)
s0:
	begin
	if (frame==0)
		next_state=s1;
	else
		next_state=s0;
	end
s1:
	begin
	if ((address[31:3]==range)&&((command==4'b0110)||(command==4'b1100)||(command==4'b1110)))
		next_state=s2;
	else if ((address[31:3]==range)&&(command==4'b0111))
		next_state=s7;
	else
		next_state=s0;
	end
s2:
	begin
	if ((!trdy_assign)&&(!irdy_reg)&&(command==4'b0110)&&frame)
		next_state=s4;
	else if ((!trdy_assign)&&(!irdy_reg)&&(command==4'b0110)&&!frame)
		next_state=s6;
	else if ((!trdy_assign)&&(!irdy_reg)&&(command==4'b1100))
		next_state=s3;
	else if ((!trdy_assign)&&(!irdy_reg)&&(command==4'b1110))
		next_state=s5;
	else
		next_state=s2;
	end
s3:
	begin
	if (frame)
		next_state=s4;
	else
		next_state=s3;
	end
s4:
	begin
	next_state=s0;
	end
s5:
	begin
	if (frame)
		next_state=s4;
	else if((mode64)&&(counter==3)&&frame)
		next_state=s4;
	else if((mode64)&&(counter==3)&&!frame)
		next_state=s6;
	else if((!mode64)&&(counter==2)&&frame)
		next_state=s4;
	else if((!mode64)&&(counter==2)&&!frame)
		next_state=s6;
	else
		next_state=s5;
	end
s6: 
	begin
	if (frame)
		next_state=s4;
 	else 
		next_state=s6;
	end
s7:
	begin
	if(frame&(!irdy_reg)&(!trdy_assign))
		next_state=s4;
	else
		next_state=s8;
	end
s8:
	begin
	if(frame&(!irdy_reg)&(!trdy_assign))
		next_state=s4;
	else
		next_state=s8;
	end
default:
	begin
	next_state=s0;
	end

endcase
end

endmodule