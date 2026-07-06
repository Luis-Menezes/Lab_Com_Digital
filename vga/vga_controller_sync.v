module vga_controller_sync(
    input            vga_clk,
    input            reset_n,
    output           oH_SYNC,
    output           oV_SYNC,
    output           oBLANK_N,
    output [9:0]     oX,
    output [9:0]     oY
);
    // Parâmetros de temporização VGA 640x480 @ 60Hz
    parameter H_ACTIVE = 640, H_FRONT = 16, H_SYNC = 96, H_BACK = 48, H_TOTAL = 800;
    parameter V_ACTIVE = 480, V_FRONT = 10, V_SYNC = 2, V_BACK = 33, V_TOTAL = 525;

    reg [9:0] h_count = 0;
    reg [9:0] v_count = 0;

    // Contadores de varredura
    always @(posedge vga_clk or negedge reset_n) begin
        if (!reset_n) begin
            h_count <= 0;
            v_count <= 0;
        end else begin
            if (h_count < H_TOTAL - 1)
                h_count <= h_count + 1;
            else begin
                h_count <= 0;
                if (v_count < V_TOTAL - 1)
                    v_count <= v_count + 1;
                else
                    v_count <= 0;
            end
        end
    end

    // Geração dos sincronismos (ativos em nível baixo)
    assign oH_SYNC = (h_count >= (H_ACTIVE + H_FRONT) && h_count < (H_ACTIVE + H_FRONT + H_SYNC)) ? 1'b0 : 1'b1;
    assign oV_SYNC = (v_count >= (V_ACTIVE + V_FRONT) && v_count < (V_ACTIVE + V_FRONT + V_SYNC)) ? 1'b0 : 1'b1;
    
    // Sinalizador de região ativa visível
    assign oBLANK_N = (h_count < H_ACTIVE) && (v_count < V_ACTIVE);

    // Envia as coordenadas X e Y atuais para o gerador de imagem
    assign oX = (h_count < H_ACTIVE) ? h_count : 10'd0;
    assign oY = (v_count < V_ACTIVE) ? v_count : 10'd0;
endmodule