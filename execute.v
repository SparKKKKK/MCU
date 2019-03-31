module my_execute(
input wire clk,
input wire rst_n,

input wire wait_en,
input wire wait_med,
input wire [1:0] wait_unit,
input wire [7:0] wait_const,

input wire set_en,
input wire [9:0]set_data,
input wire [7:0]set_addr,

input wire cpy_en,
input wire [7:0]cpy_rsrc,
input wire [7:0]cpy_rtgt,

input wire cpyir_en,
input wire [7:0]cpyir_rsrc,
input wire [7:0]cpyir_rtgt,

input wire cpyri_en,
input wire [7:0]cpyri_rsrc,
input wire [7:0]cpyri_rtgt,

output wire [7:0]bus_rd_addr,
input wire [9:0]bus_rd_data,

output reg [7:0]int_rd_addr,
input wire [9:0]int_rd_data,

output wire [7:0]int_wr_addr,
output wire [9:0]int_wr_data,

output wire [7:0]bus_wr_addr,
output wire [9:0]bus_wr_data.

output wire bus_rd_en,
output wire bus_wr_en,

output wire pc_hold
    );
//wait process
reg [9:0]wait_num,wait_num1;
always@(*)begin
    if(wait_en)
        case(wait_med)
            1'b0:wait_num = wait_const;
            1'b1:wait_num = int_rd_data;
            default:wait_num = 10'd0;
        endcase
    else begin
        wait_num = 10'd0;
    end
end
always@(*)begin
    case(wait_unit)
        2'b00:wait_num1 = wait_num;
        2'b01:wait_num1 = {wait_num,1'b0};
        2'b10:wait_num1 = {wait_num,2'b00};
        2'b11:wait_num1 = {wait_num,3'b000};
        default:wait_num1 = 10'd0;
        endcase
end
reg [7:0]wait_cycle;
always@(posedge clk or negedge rst_n)begin
    if(!rst_n)
        wait_cycle <= 0;
    else if(wait_en)
        wait_cycle <= wait_num1;
    else if(wait_cycle>3)
        wait_cycle <= wait_cycle -1;
    else begin
        wait_cycle <= 0;
    end
end
assign pc_hold = wait_en|(wait_cycle>10'd2);

reg [7:0]write_addr;
reg [9:0]write_data;
//cpy process

assign bus_rd_addr = cpyri_rsrc;

always@(*)begin
    case(1'b1)
        cpyir_en:int_rd_addr = cpyir_rsrc;
        cpy_en:  int_rd_addr = cpy_rsrc;
        (wait_en&wait_med):int_addr_addr = wait_const;
        
        default:int_rd_addr = 8'd0;
    endcase
end




always@(*)begin
    case(1'b1)
        set_en:begin write_addr =set_addr; write_data = set_data end
        cpyri_en:begin write_addr = cpyri_rtgt; write_data = bus_rd_data;end
        cpyir_en:begin write_addr = cpyir_rtgt; write_data = int_rd_data;end
        cpy_en:  begin write_addr = cpy_rtgt; write_data = int_rd_data; end

        default:begin write_addr = 8'b0; write_data = 10'b0;end
    endcase
end

wire int_en = (write_addr>=`ADDR_BOUNDRY)?1'b1:1'b0;
wire bus_en = (write_addr<`ADDR_BOUNDRY)?1'b1:1'b0;

assign int_wr_addr = int_en?write_addr:8'd0;
assign int_wr_data = int_en?write_data:10'd0;
assign bus_wr_addr = bus_en?write_addr:8'd0;
assign bus_wr_data = bus_en?write_data:10'd0;

assign bus_wr_en = set_en|cpyir_en;
assign bus_rd_en = cpyri_en;

endmodule 