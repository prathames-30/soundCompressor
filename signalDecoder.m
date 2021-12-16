% Decodes the LPC coefficients into
% coefficientMatrix - the LPC filter coefficients
% w - the window function
% lowcut - the cutoff frequency in normalized frequencies for a lowcut
% filter.

function x_compressed = signalDecoder(coefficientMatrix, varianceMatrix, w, lowcut)
if nargin < 4 %default values assigned
    lowcut = 0;
end

[le, l] = size(varianceMatrix);
lw = length(w);

% synthesize estimates for each chunk
xCompressed = zeros(lw, l);

if le < 2 % GFE is only the signal power
    
    for i = 1:l
        src = randn(lw, 1); % noise
        xCompressed(:,i) = w .* filter( 1, [-1; coefficientMatrix(:,i)], sqrt(varianceMatrix(i))*src);
    end
    
    % render down to signal
    x_compressed = mergeChunks(xCompressed);
    
elseif le < 3 % GFE is the pitch fequency and signal power
    F = varianceMatrix(2,:); % pitch frequency
    G = varianceMatrix(1,:); % power
    offset = 0;
    
    lw2 = round(lw/2);
    x_compressed = zeros(lw2*l, 1);
    
    for i = 1:l
        
        % create source
        if F(i) > 0 % pitched
            src = zeros(lw2,1);
            
            step = round(1/F(i));
            pts = (offset+1):step:lw2;
            
            if ~isempty(pts)
                offset = step + pts(end) - lw2;
                src(pts) = sqrt(step); % impulse train, compensate power
            end
            
        else
            src = randn(lw2, 1); % noise
            offset = 0;
        end
        
        % filter
        x_compressed( lw2*i + (1:lw2) ) = filter( 1, [-1; coefficientMatrix(:,i)], sqrt(G(i))*src);
    end
    
else % GFE is the error signal
    for i = 1:l
        xCompressed(:,i) = w .* filter( 1, [-1; coefficientMatrix(:,i)], varianceMatrix(:,i));
    end

    % render down to signal
    x_compressed = pressStack(xCompressed);
end
    
% dc blocker hack
if lowcut > 0
    [b,a] = butter(10, lowcut, 'high'); 
    x_compressed = filter(b,a,x_compressed);
end    

