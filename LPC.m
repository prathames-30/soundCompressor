% An implementation of LPC.
% x - a single channel audio signal
% p - the number of previous values on which new data depends
% w - the coefficients used in encoding
% g - the variance of the source
% e - the full error signal
function [w, g, e] = LPC(x, p)
N = length(x);
% form the matrices
b = x(2:N);
xz = [x; zeros(p,1)];
A = zeros(N-1, p);
for i=1:p
    temp = circshift(xz, i-1);
    A(:, i) = temp(1:(N-1));
end
% solve for a
w = A\b;
% calculate variance of errors
e = b - A*w;
g = var(e);

