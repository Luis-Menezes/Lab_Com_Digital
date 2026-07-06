module vga_raster_display(
    input [9:0]  iX,
    input [9:0]  iY,
    input        iBLANK_N,
    input [15:0] temp1,
    input [15:0] temp2,
    input [15:0] limiar_operacao, // Preparado para o PC4 (Teclado)
    input        alerta,
    output reg [7:0] oR,
    output reg [7:0] oG,
    output reg [7:0] oB
);
    // Base inferior dos gráficos de barra (Y = 400)
    localparam GRAPH_BASE = 400;

    always @(*) begin
        if (!iBLANK_N) begin
            oR = 8'h00; oG = 8'h00; oB = 8'h00;
        end else begin
            // 1. Cor de Fundo Padrão (Azul Escuro/Preto)
            oR = 8'h1C; oG = 8'h37; oB = 8'hA6;

            // 2. Gráfico do Sensor 1 (Coluna X de 120 a 180)
            if (iX >= 120 && iX <= 180) begin
                // A altura da barra é proporcional ao valor da temperatura (multiplicado por 3 para dar escala)
                if (iY >= (GRAPH_BASE - (temp1 * 3)) && iY <= GRAPH_BASE) begin
                    oR = 8'h00; oG = 8'hFF; oB = 8'h55; // Verde Vivo
                end
            end

            // 3. Gráfico do Sensor 2 (Coluna X de 240 a 300)
            if (iX >= 240 && iX <= 300) begin
                if (iY >= (GRAPH_BASE - (temp2 * 3)) && iY <= GRAPH_BASE) begin
                    oR = 8'h00; oG = 8'hD5; oB = 8'hFF; // Ciano
                end
            end

            // 4. Desenhar a Linha Dinâmica do Limiar de Operação (PC4)
            // Uma linha horizontal vermelha tracejada ou sólida cruzando os gráficos
            if (iY == (GRAPH_BASE - (limiar_operacao * 3)) && iX >= 100 && iX <= 320) begin
                oR = 8'hFF; oG = 8'h00; oB = 8'h00;
            end

            // 5. Bloco Indicador de Alerta Geral (Quadrado no canto superior direito)
            if (alerta && (iX >= 480 && iX <= 580) && (iY >= 40 && iY <= 140)) begin
                oR = 8'hFF; oG = 8'h00; oB = 8'h00; // Vermelho Puro de Alarme
            end
        end
    end
endmodule