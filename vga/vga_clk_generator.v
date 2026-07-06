module vga_clk_generator(
    input  clk_50MHz,
    output reg vga_clk = 0
);
    always @(posedge clk_50MHz) begin
        vga_clk <= ~vga_clk;
    end
endmodule