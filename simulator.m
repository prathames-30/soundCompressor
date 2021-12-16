%Run this file for output
close all; clear all; clc;

%% load audio
[information, fs] = audioread('Gabbar_Kitne_Aadmi.wav');

information = mean(information, 2); % converting to one channel
information = resample(information, 10000, fs); % resampling to 10kHz
fs = 10000;
w = hann(floor(0.03*fs), 'periodic'); % using 30ms Hann window

%% Encoding the signal using LPC model
p = 30; %Assuming it depends on past 30 values 
[coefficientMatrix, varianceMatrix] = signalEncoder(information, p, w);


%% Decoding the signal using LPC model
x_compressed = signalDecoder(coefficientMatrix, varianceMatrix, w, 200/fs);

%% create the output file
audiowrite(['Compressed_Gabbar.wav'],x_compressed, fs); 

