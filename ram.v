module my_ram(
input wire clk,
input wire ce_ram,
input wire we_ram,
input wire [15:0] pc_final,
input wire [15:0] a,
input wire [20:0] pc_modify,
output reg [19:0] ram_dout
    );

reg [19:0] memory [0:255];
initial $readmemb("ram.bin",memory);
//read 
always@(posedge clk) begin
    if(ce_ram) begin
        ram_dout<= #4 memory[pc_final];
    end else begin
        ram_dout <= #4 15'd0;
    end
end
//write 
always@(posedge clk )begin
    if(we_ram) begin
        memory[a] <= #4 pc_modify;
    end
    else 
        memory[a] <= #4 memory[a];
end

endmodule