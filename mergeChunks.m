% Renders an overlap-add stack into the original signal.
% It assumes the stacked signals are already windowed.
% X - a stacked overlap-add
% x - the rendered signal

function x = mergeChunks(X)

[lw, count] = size(X);
step = floor(lw*0.5);
l = (count-1)*step+lw;

x = zeros(l, 1);

for i = 1:count
   x( (1:lw) + step*(i-1) ) = x( (1:lw) + step*(i-1) ) + X(:, i);
end
