%% filename: IF_module.m
clear all;clc;close all;format compact;
inst_rom = textread('inst.data','%s');

fid=fopen('decoder_result.txt','wt');
for i = 1:length(inst_rom)
    RV32I_decoder(inst_rom{i},fid);
end

% single inst
% RV32I_decoder('00100d13',fid);

fclose(fid);
