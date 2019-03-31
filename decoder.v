`include "define.v"
module my_decoder(
input wire [19:0]inst2decoder,

output wire set_en,
output reg [9:0]set_data,
output reg [7:0]set_addr,

output wire cpy_en,
output reg [7:0]cpy_rsrc,
output reg [7:0]cpy_rtgt,

output wire cpyir_en,
output reg [7:0]cpyir_rsrc,
output reg [7:0]cpyir_rtgt,

output wire cpyri_en,
output reg [7:0]cpyri_rsrc,
output reg [7:0]cpyri_rtgt,

output wire call_en,
output reg [15:0]call_const,

output wire return_en,

output wire wait_en,
output reg wait_med,
output reg [7:0]wait_unit,
output reg [7:0]wait_const,

output wire jmp_en,
output reg [15:0] jmp_const
    );
assign set_en = (inst2decoder[19:18]==`SET)?1:0;

assign call_en = (inst2decoder[19:16]==`CALL)?1:0;

assign jmp_en = (inst2decoder[19:16]==`JMP)?1:0;

assign return_en = (inst2decoder[19:16]==`RETURN)?1:0;

assign cpy_en = (inst2decoder[19:16]==`CPY)?1:0;

assign cpyir_en = (inst2decoder[19:16]==`CPYIR)?1:0;
assign cpyri_en = (inst2decoder[19:16]==`CPYRI)?1:0;

assign wait_en = (inst2decoder[19:16]==`WAIT)?1:0;

always@(*)begin
    if(set_en)begin
        set_data=inst2decoder[9:0];
        set_addr=inst2decoder[17:10];
    end
    else if(call_en)begin
        call_const=inst2decoder[15:0];
    end
    else if(jmp_en)begin
        jmp_const=inst2decoder[15:0];
    end
    else if(cpy_en)begin
        cpy_rsrc=inst2decoder[15:8];
        cpy_rtgt=inst2decoder[7:0];
    end
     else if(cpyir_en)begin
        cpyir_rsrc=inst2decoder[15:8];
        cpyir_rtgt=inst2decoder[7:0];
    end
        else if(cpyri_en)begin
        cpyri_rsrc=inst2decoder[15:8];
        cpyri_rtgt=inst2decoder[7:0];
    end   
    else if(wait_en)begin
        wait_med=inst2decoder[15];
        wait_unit=inst2decoder[14:13];
        wait_const=inst2decoder[7:0];
    end
end

endmodule 