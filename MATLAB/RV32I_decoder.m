%% filename: RV32I_Decoder.m
% clear all;clc;close all;format compact;
function [] = RV32I_decoder(inst_hex,fid)
%% get instruction 
bw = 32; % bit width 32

% inst_hex = '00100d13';
inst_dec = hex2dec(inst_hex);
inst_bin = dec2bin(inst_dec);
inst = inst_bin;
inst_str=[inst_hex '->'];
fprintf(fid,'%s\n',inst_str);
disp(inst_str);
for i = 1 : bw-length(inst_bin)
    inst = ['0',inst];
end

%% decode step 1 
% R-type
opcode = inst(bw-6:bw-0);   % [ 6:0 ]
rd     = inst(bw-11:bw-7);  % [11:7 ]     
funct3 = inst(bw-14:bw-12); % [14:12]
rs1    = inst(bw-19:bw-15); % [19:15]
rs2    = inst(bw-24:bw-20); % [24:20]
funct7 = inst(bw-31:bw-25); % [31:25]

% I-type
imm_I = inst(bw-31:bw-20); % [31:20]

% S-type
imm_S = [inst(bw-31:bw-25) inst(bw-11:bw-7)]; % [31:25]_[11:7]

% B-type
imm_B = [inst(bw-31) inst(bw-7) inst(bw-30:bw-25) inst(bw-11:bw-8) 0]; % [31]_[7]_[30:25]_[11:8]_0 

% U-type
imm_U = inst(bw-31:bw-12); % [31:12]

% J-type
imm_J = [inst(bw-31) inst(bw-19:bw-12) inst(bw-20) inst(bw-30:bw-21) 0]; % [31]_[19:12]_[20]_[30:21]_0

%% decode step 2

switch opcode
    case '0110111'
        inst_n = 'LUI ';
        str=['          ' inst_n ' : opcode = ' opcode ', rd '  ' = ' rd '  ' ', imm = ' imm_U ';'];
        
    case '0010111'
        inst_n = 'AUIPC';
        str=['          ' inst_n ' : opcode = ' opcode ', rd '  ' = ' rd '  ' ', imm = ' imm_U ';'];
        
    case '1101111'
        inst_n = 'JAL ';
        str=['          ' inst_n ' : opcode = ' opcode ', rd '  ' = ' rd '  ' ', imm = ' imm_J ';'];
        
    case '1100111'
        inst_n = 'JALR';
        str=['          ' inst_n ' : opcode = ' opcode ', rd '  ' = ' rd '  ' ', funct3 = ' funct3 ...
            ', rs1 = ' rs1 ', imm = ' imm_I ';'];
        
    case '1100011'
        if(funct3 == '000') inst_n = 'BEQ '; end
        if(funct3 == '001') inst_n = 'BNE '; end
        if(funct3 == '100') inst_n = 'BLT '; end
        if(funct3 == '101') inst_n = 'BGE '; end
        if(funct3 == '110') inst_n = 'BLTU'; end
        if(funct3 == '111') inst_n = 'BGEU'; end
                
        str=['          ' inst_n ' : opcode = ' opcode ', funct3 = ' funct3 ...
            ', rs1 = ' rs1 ', rs2 = ' rs2 ', imm = ' imm_B ';'];
        
    case '0000011'
        if(funct3 == '000') inst_n = 'LB  '; end
        if(funct3 == '001') inst_n = 'LH  '; end
        if(funct3 == '010') inst_n = 'LW  '; end
        if(funct3 == '100') inst_n = 'LBU '; end
        if(funct3 == '101') inst_n = 'LHU '; end
                
        str=['          ' inst_n ' : opcode = ' opcode ', rd '  ' = ' rd '  ' ', funct3 = ' funct3 ...
            ', rs1 = ' rs1 ', imm = ' imm_I ';'];
        
    case '0100011'
        if(funct3 == '000') inst_n = 'SB  '; end
        if(funct3 == '001') inst_n = 'SH  '; end
        if(funct3 == '010') inst_n = 'SW  '; end
                
        str=['          ' inst_n ' : opcode = ' opcode ', funct3 = ' funct3 ...
            ', rs1 = ' rs1 ', rs2 = ' rs2 ', imm = ' imm_S ';'];
        
    case '0010011'
        if(funct3 == '000') inst_n = 'ADDI'; end
        if(funct3 == '010') inst_n = 'SLTI'; end
        if(funct3 == '011') inst_n = 'SLTIU'; end
        if(funct3 == '100') inst_n = 'XORI'; end
        if(funct3 == '110') inst_n = 'ORI '; end
        if(funct3 == '111') inst_n = 'ANDI'; end
        if(funct3 == '001') inst_n = 'SLLI'; end
        if(funct3 == '101') 
            if(funct7 == '0000000')inst_n = 'SRLI';
            else inst_n = 'SRAI';end
            str=['          ' inst_n ' : opcode = ' opcode ', rd '  ' = ' rd '  ' ', funct3 = ' funct3 ...
            ', rs1 = ' rs1 ', funct7 = ' funct7 ';'];
        else
            str=['          ' inst_n ' : opcode = ' opcode ', rd '  ' = ' rd '  ' ', funct3 = ' funct3 ...
            ', rs1 = ' rs1 ', imm = ' imm_I ';'];
        end           
        
    case '0110011'
        if(funct3 == '000') 
            if(funct7 == '0000000')inst_n = 'ADD '; 
            else inst_n = 'SUB ';end
        end
        if(funct3 == '001') inst_n = 'SLL '; end
        if(funct3 == '010') inst_n = 'SLT '; end
        if(funct3 == '011') inst_n = 'SLTU'; end
        if(funct3 == '100') inst_n = 'XOR '; end
        if(funct3 == '101') 
            if(funct7 == '0000000')inst_n = 'SRL '; 
            else inst_n = 'SRA ';end
        end
        if(funct3 == '110') inst_n = 'OR  '; end
        if(funct3 == '111') inst_n = 'AND '; end
                                       
        str=['          ' inst_n ' : opcode = ' opcode ', rd '  ' = ' rd '  ' ', funct3 = ' funct3 ...
            ', rs1 = ' rs1 ', rs2 = ' rs2 ', funct7 = ' funct7 ';'];
        
    case '0001111'
        if(funct3 == '000') inst_n = 'FENCE';end
        if(funct3 == '001') inst_n = 'FENCE.I';end
        str=['          ' inst_n ' : opcode = ' opcode ', funct3 = ' funct3 ';'];
        disp(str);
    case '1110011'
        if(funct3 == '001') inst_n = 'CSRRW'; end
        if(funct3 == '010') inst_n = 'CSRRS'; end
        if(funct3 == '011') inst_n = 'CSRRC'; end
        if(funct3 == '101') inst_n = 'CSRRWI'; end
        if(funct3 == '110') inst_n = 'CSRRSI'; end
        if(funct3 == '111') inst_n = 'CSRRCI'; end
        
        if(funct3 == '000')
            if(imm_I == '000000000000') inst_n = 'ECALL';
            else inst_n = 'EBREAK';end
            str=['          ' inst_n ' : opcode = ' opcode ', imm = ' imm_I ';'];
        else
            str=['          ' inst_n ' : opcode = ' opcode ', rd '  ' = ' rd '  ' ', funct3 = ' funct3 ...
            ', rs1 = ' rs1 ', csr = ' imm_I ';'];        
        end
    
    otherwise
        str = '    ERROR';
end

disp(str);

fprintf(fid,'%s\n',str);
end