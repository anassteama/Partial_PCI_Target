module data_path(clk,rst,add1,add2,we1,we2,ad,be,oe,mode,par,par64,par_e1,par_e2,perr,perr_e1,perr_e2);
input clk,rst;
input [2:0] add1,add2;
input we1,we2;
inout [63:0]ad;
input [7:0] be;
input oe,mode;
inout par,par64,perr;
input par_e1,par_e2;
inout perr_e1,perr_e2;


wire [63:0] data;
wire [63:0] data_temp;

reg [31:0] data_par1_d1,data_par2_d1;//for generate par and par64
//,data_par1_d2,data_par2_d2
reg par_e1_d1,par_e2_d1;
//par_e1_d2,par_e2_d2;


wire [35:0] temp_in1,temp_in2;//for generate perr
reg gen_par1,gen_par2,gen_par1_d1,gen_par2_d1,gen_par1_d2,gen_par2_d2;//for generate perr
reg sen_par1,sen_par2,sen_par1_d1,sen_par2_d1;
reg perr_temp;
reg perr_e1_d1,perr_e2_d1,perr_e1_d2,perr_e2_d2;

reg [31:0] reg_file [0:7];
reg [7:0] be_reg;
wire [63:0] mask;

/// calculate perr
assign temp_in1={be[3:0],ad[31:0]};
assign temp_in2={be[7:4],ad[63:32]};

always@(posedge clk)
begin
	sen_par1<=par;
	sen_par2<=par64;
end

always@(negedge clk)
begin
	sen_par1_d1<=sen_par1;
	sen_par2_d1<=sen_par2;
end

always@(posedge clk)
begin
	gen_par1<=^temp_in1;
	gen_par2<=^temp_in2;
end

always@(negedge clk)
begin
	gen_par1_d1<=gen_par1;
	gen_par2_d1<=gen_par2;
end

always@(negedge clk)
begin
	gen_par1_d2<=gen_par1_d1;
	gen_par2_d2<=gen_par2_d1;
end

always@(negedge clk)
begin
	perr_e1_d1<=perr_e1;
	perr_e2_d1<=perr_e2;
end

always@(negedge clk)
begin
	perr_e1_d2<=perr_e1_d1;
	perr_e2_d2<=perr_e2_d1;
end

always@(*)
begin
	if(perr_e2_d2)
		perr_temp=((!(gen_par1_d2^sen_par1_d1))&(!((gen_par2_d2^sen_par2_d1))));
	else if(perr_e1_d2)
		perr_temp=(!(gen_par1_d2^sen_par1_d1));
	else 	
		perr_temp=1'bz;
end

assign perr=perr_temp;
/////////////////////////////

//// calculate par and par64
always@(negedge clk)
begin
	data_par1_d1<=data_temp[31:0];
    data_par2_d1<=data_temp[63:32];
end
/*
always@(negedge clk)
begin
	data_par1_d2<=data_par1_d1;
        data_par2_d2<=data_par2_d1;
end
*/


always@(negedge clk)
begin
	par_e1_d1<=par_e1;
	par_e2_d1<=par_e2;
end

/*
always@(negedge clk)
begin
	par_e1_d2<=par_e1_d1;
	par_e2_d2<=par_e2_d1;
end
*/

assign par=(par_e1_d1)?^(data_par1_d1):1'bz;
assign par64=(par_e2_d1)?^(data_par2_d1):1'bz;
///////////////////////////

assign mask[7:0]=(be[0])?0:255;
assign mask[15:8]=(be[1])?0:255;
assign mask[23:16]=(be[2])?0:255;
assign mask[31:24]=(be[3])?0:255;
assign mask[39:32]=(be[4])?0:255;
assign mask[47:40]=(be[5])?0:255;
assign mask[55:48]=(be[6])?0:255;
assign mask[63:56]=(be[7])?0:255;


assign data=(oe)?64'bz:ad;
assign ad=(oe)?data_temp:64'bz;

always@(posedge clk,negedge rst)
begin
	if(!rst)
	begin
		reg_file[0]<=0;
		reg_file[1]<=0;
		reg_file[2]<=0;
		reg_file[3]<=0;
		reg_file[4]<=0;
		reg_file[5]<=0;
		reg_file[6]<=0;
		reg_file[7]<=0;
	end	
	else if(we1&we2)
	begin
		reg_file[add1]<= data[31:0]& mask[31:0];
		reg_file[add2]<= data[63:32]& mask[63:32];
	end
	else if(we1)
		reg_file[add1]<= data[31:0]& mask[31:0];
end

assign data_temp[31:0]=reg_file[add1];
assign data_temp[63:32]=(mode)?32'bz:reg_file[add2];


endmodule