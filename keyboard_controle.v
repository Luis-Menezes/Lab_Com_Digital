module keyboard_controle(
    input            iCLK_50,        // Clock do sistema
    input            iRST_n,         // Reset geral
    input      [7:0] iSCAN_CODE,     // Scancode vindo do teclado
    input            iKEY_READY,     // Pulso de dado pronto do teclado
    
    output reg [1:0] oSENSOR_SEL,    // Sensor selecionado (ex: 00=Temp, 01=Umidade...)
    output reg [15:0] oLIMIAR_TEMP,   // Registrador do limiar de Temperatura
    output reg [15:0] oLIMIAR_UMID    // Registrador do limiar de Umidade
);

    // Parâmetros com os Scancodes das teclas do teclado PS/2
    parameter KEY_UP    = 8'h75; // Seta para Cima (Aumenta limiar)
    parameter KEY_DOWN  = 8'h72; // Seta para Baixo (Diminui limiar)
    parameter KEY_LEFT  = 8'h6B; // Seta para Esquerda (Muda sensor)
    parameter KEY_RIGHT = 8'h74; // Seta para Direita (Muda sensor)
    parameter BREAK_CODE = 8'hF0;

    reg is_break;

    // Processamento dos comandos do teclado
    always @(posedge iCLK_50 or negedge iRST_n) begin
        if (!iRST_n) begin
            oSENSOR_SEL   <= 2'b00;
            oLIMIAR_TEMP  <= 16'd2000;  // Valor padrão inicial (ex: 30°C)
            oLIMIAR_UMID  <= 16'd60;  // Valor padrão inicial (ex: 60%)
            is_break      <= 1'b0;
        end else if (iKEY_READY) begin
            if (iSCAN_CODE == BREAK_CODE) begin
                is_break <= 1'b1; // Próximo byte será a liberação da tecla, ignoramos
            end else if (is_break) begin
                is_break <= 1'b0; // Reseta o estado de break
            end else begin
                // Executa a ação baseada na tecla pressionada (Make Code)
                case (iSCAN_CODE)
                    KEY_RIGHT: oSENSOR_SEL <= oSENSOR_SEL + 1'b1;
                    KEY_LEFT:  oSENSOR_SEL <= oSENSOR_SEL - 1'b1;
                    
                    KEY_UP: begin
                        if (oSENSOR_SEL == 2'b00)
                            oLIMIAR_TEMP <= oLIMIAR_TEMP + 7'd100;
                        else if (oSENSOR_SEL == 2'b01)
                            oLIMIAR_UMID <= oLIMIAR_UMID + 1'b1;
                    end
                    
                    KEY_DOWN: begin
                        if (oSENSOR_SEL == 2'b00)
                            oLIMIAR_TEMP <= oLIMIAR_TEMP - 7'd100;
                        else if (oSENSOR_SEL == 2'b01)
                            oLIMIAR_UMID <= oLIMIAR_UMID - 1'b1;
                    end
                    default: ; // Ignora outras teclas
                endcase
            end
        end
    end

endmodule