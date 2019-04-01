module my_ram(
input wire clk,
input wire ce_ram,

input wire [15:0] pc_final,
output reg [19:0] ram_dout
    );

reg [19:0] memory [0:255];
initial $readmemb("ram.bin",memory);

always@(posedge clk) begin
    if(ce_ram) begin
        ram_dout<=#12 memory[pc_final];
    end else begin
        ram_dout <= #8 15'd0;
    end
end

endmodule