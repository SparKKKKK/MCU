module my_fetch(
input wire clk,
input wire rst_n,
input wire mcu_en,

input wire [15:0] pc_start,
input wire [19:0] rom_dout,
input wire [19:0] ram_dout,

input wire call_en,
input wire [15:0] call_const,
input wire return_en,

input wire jmp_en,
input wire [15:0] jmp_const,

output reg [15:0] pc_final,
output wire [19:0] inst2decoder,
output wire ce_ram,
output wire ce_rom,

input wire pc_hold
    );
//mcu_en_pulse
reg mcu_en_dly;
wire mcu_en_pulse;
always@(posedge clk) begin
    if(!rst_n)
        mcu_en_dly <= 1'b0;
    else 
        mcu_en_dly <= mcu_en;
end
assign mcu_en_pulse = mcu_en^mcu_en_dly;
//get instruction
assign inst2decoder = pc_final[15]?ram_dout:rom_dout;
assign ce_rom = (!pc_final[15])&mcu_en;
assign ce_ram = (pc_final[15])&mcu_en;
//call return process
reg [15:0] stack [0:2];
reg [2:0] stack_point;
wire [2:0] pop_addr;
always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        stack_point <= 0;
    end else if(call_en) begin
        stack_point <= stack_point +1;
    end else if(return_en) begin
        stack_point <= stack_point -1;
    end else begin
        stack_point <= stack_point;
    end
end
always @(posedge clk or posedge rst_n) begin
    if (!rst) begin
        stack[0] <= 0;
        stack[1] <= 0;
        stack[2] <= 0;
    end
    else if (calL_en) begin
        case(stack_point)
            3'd0:stack[0]<= pc_final;
            3'd1:stack[1]<= pc_final;
            3'd2:stack[2]<= pc_final;
            default:stack[0]<=16'bx;
        endcase
    end
    else begin
        stack[0] <= stack[0];
        stack[1] <= stack[1];
        stack[2] <= stack[2];
    end
end

assign pop_addr = return_en?(stack_point-2'b1):2'b0;
reg pop_data;
always@(*)begin
    if(return_en)begin
        if(pop_addr==2'b00) begin
            pop_data = stack[0];
        end else if(pop_addr==2'b01)begin
            pop_data = stack[1];
        end else if(pop_addr==2'b10)begin
            pop_data = stack[2];
        end else begin
            pop_data = pop_data;
        end
    end else begin
        pop_data = 16'd0;
    end
end
//reg define
reg [15:0] pc_ch;
wire pc_ch_en = call_en | return_en | jmp_en;
//pc_ch
always@(*) begin
    case(1'b1)
        call_en:  pc_ch=call_const;
        return_en:pc_ch=pop_data;
        jmp_en:   pc_ch=jmp_const;

        default:  pc_ch=16'd0;
    endcase
end
//set pc_final,should put it at the end of module
always @(posedge clk or posedge rst_n) begin
    if (!rst_n) begin
        // reset
        pc_final <= 16'b0;
    end
    else if (mcu_en_pulse) begin
        pc_final <= pc_start;
    end 
    else if(pc_ch_en) begin
        pc_final <= pc_ch;
    end
    else if(pc_hold) begin
        pc_final <= pc_final;
    end
    else begin
        pc_final <= pc_final +1;
    end
end

endmodule