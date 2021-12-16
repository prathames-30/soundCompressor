% Creating overlapping chunks to get a smooth transition between 
% different chunks
% x - a single channel signal
% w - the window function
% X - the overlap-add stack

function X = createChunks(x, w)

l = length(x);
lw = length(w);
step = floor(lw*0.5);

count = floor((l-lw)/step) + 1;

X = zeros(lw, count);

for i = 1:count
    X(:, i) = w .* x( (1:lw) + (i-1)*step );
end