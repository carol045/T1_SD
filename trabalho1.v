module trabalho1(
    input reset,
    input clock,
    input stop, 
    input pause, 
    input start,
    input  [6:0] min,
    input  [6:0] sec,
    output reg [7:0] an,
    output done,
    output reg [7:0] dec_cat
    );
    // Declaração dos sinais
    //------------
    wire start_ed, pause_ed, stop_ed;
    wire [6:0] min_left, sec_left;
    wire [1:0] EA;

    // Instanciação dos edge_detectors
    //------------
    edge_detector ed1(.clock(clock), .reset(reset), .din(start), .rising(start_ed));
    edge_detector ed2(.clock(clock), .reset(reset), .din(pause), .rising(pause_ed));
    edge_detector ed3(.clock(clock), .reset(reset), .din(stop), .rising(stop_ed));
    //------------

    // Decrementador de tempo (minutos e segundos)
    always @(posedge clock or posedge reset) begin
        case({stop, pause, start})
            3'b001: dec_cat = 8'b10011111;
            3'b010: dec_cat = 8'b00100101;
            3'b100: dec_cat = 8'b00001101;
            default: dec_cat = 8'b00000100;
        endcase
    end

    // Máquina de estados para determinar o estado atual (EA)
    always @(posedge clock or posedge reset) begin
        if (reset) begin
          EA <= 2'b00;          
        end
        else begin
            case (EA)
                2'b00: begin
                    if (start_ed)
                        EA <= 2'b01;
                end 
                2'b01: begin
                    if(stop_ed)
                        EA <= 2'b00;
                    if(pause_ed)
                        EA <= 2'b10;
                end
                2'b10: begin
                    if(pause_ed || start_ed)
                        EA <= 2'b01;
                    if(stop_ed)
                        EA <= 2'b00;
                end
                default:
                    ;
            endcase
        end
    end

    // Instanciação da display 7seg  - Segundos
    always @(posedge clock or posedge reset) begin
        case(sec)
            6'b000000: dec_cat = 8'b00000011; // "0"  
            6'b000001: dec_cat = 8'b10011111; // "1" 
            6'b000010: dec_cat = 8'b00100101; // "2" 
            6'b000011: dec_cat = 8'b00001101; // "3" 
            6'b000100: dec_cat = 8'b10011001; // "4" 
            6'b000101: dec_cat = 8'b01001001; // "5" 
            6'b000110: dec_cat = 8'b01000001; // "6" 
            6'b000111: dec_cat = 8'b00011111; // "7" 
            6'b001000: dec_cat = 8'b00000001; // "8"  
            6'b001001: dec_cat = 8'b00001001; // "9" 
            default  : dec_cat = 8'b00000011; // "0"
        endcase
    end
    // Segundos
    always @(posedge clock or posedge reset) begin
        case(min)
            6'b000000: dec_cat = 8'b00000011; // "0"  
            6'b000001: dec_cat = 8'b10011111; // "1" 
            6'b000010: dec_cat = 8'b00100101; // "2" 
            6'b000011: dec_cat = 8'b00001101; // "3" 
            6'b000100: dec_cat = 8'b10011001; // "4" 
            6'b000101: dec_cat = 8'b01001001; // "5" 
            6'b000110: dec_cat = 8'b01000001; // "6" 
            6'b000111: dec_cat = 8'b00011111; // "7" 
            6'b001000: dec_cat = 8'b00000001; // "8"  
            6'b001001: dec_cat = 8'b00001001; // "9" 
            default  : dec_cat = 8'b00000011; // "0"
        endcase
    end
    // Minutos
    always @(posedge clock or posedge reset) begin
        case(min_left)
            6'b000000: dec_cat = 8'b00000011; // "0"  
            6'b000001: dec_cat = 8'b10011111; // "1" 
            6'b000010: dec_cat = 8'b00100101; // "2" 
            6'b000011: dec_cat = 8'b00001101; // "3" 
            6'b000100: dec_cat = 8'b10011001; // "4" 
            6'b000101: dec_cat = 8'b01001001; // "5" 
            6'b000110: dec_cat = 8'b01000001; // "6" 
            6'b000111: dec_cat = 8'b00011111; // "7" 
            6'b001000: dec_cat = 8'b00000001; // "8"  
            6'b001001: dec_cat = 8'b00001001; // "9" 
            default  : dec_cat = 8'b11111111; // "Tudo desligado"
        endcase
    end

endmodule