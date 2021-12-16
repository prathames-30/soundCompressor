% Encodes the input signal into lpc 
% coefficients using overlaping technique 
% x - single channel input signal
% p - the number of previous values on which new data depends
% lw - window length
% coefficientMatrix - the coefficients
% varianceMatrix - the signal power
% E - Innovation signal
function [coefficientMatrix, varianceMatrix, E] = signalEncoder(x, p, w)

X = createChunks(x, w); % stack the windowed signals
[lw, l] = size(X);

% LPC encode
coefficientMatrix = zeros(p, l);
varianceMatrix = zeros(1, l);
E = zeros(lw, l);
for i = 1:l
    [w, g, e] = LPC(X(:,i), p);
    coefficientMatrix(:, i) = w;
    varianceMatrix(i) = g;
    E(2:lw, i) = e;
end