// Módulo de decodificação BCD (Mantido e limpo)
module decodBCD (
    input      [3:0] bcd,
    output reg [6:0] seg
);
    always @(*) begin
        case(bcd)
            4'h0: seg = 7'b1000000;
            4'h1: seg = 7'b1111001;
            4'h2: seg = 7'b0100100;
            4'h3: seg = 7'b0110000;
            4'h4: seg = 7'b0011001;
            4'h5: seg = 7'b0010010;
            4'h6: seg = 7'b0000010;
            4'h7: seg = 7'b1111000;
            4'h8: seg = 7'b0000000;
            4'h9: seg = 7'b0010000;
            default: seg = 7'b1111111; // Apagado
        endcase
    end
endmodule

// Módulo principal simplificado
module display_7seg(
    input [13:0] data, // 14 bits cobrem até 16383, suficiente para 4 dígitos (9999)
    input ligaOUT,
    output [6:0] unid_display, dez_display, cen_display, mil_display
);

    // Fios internos para os valores BCD
    wire [3:0] unidade, dezena, centena, milhar;

    // Lógica de separação de dígitos (Conversão Simples)
    // Nota: O Quartus tentará otimizar isso, mas para 4 dígitos é aceitável.
    assign unidade = ligaOUT ? (data % 10) : 4'hF;
    assign dezena  = ligaOUT ? ((data / 10) % 10) : 4'hF;
    assign centena = ligaOUT ? ((data / 100) % 10) : 4'hF;
    assign milhar  = ligaOUT ? ((data / 1000) % 10) : 4'hF;

    // Instanciação dos decodificadores
    decodBCD bcd0(.bcd(unidade), .seg(unid_display));
    decodBCD bcd1(.bcd(dezena),  .seg(dez_display));
    decodBCD bcd2(.bcd(centena), .seg(cen_display));
    decodBCD bcd3(.bcd(milhar),  .seg(mil_display));

endmodule