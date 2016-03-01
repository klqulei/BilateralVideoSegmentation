%% helper function to do the splatting
function [vidIndices, vidWeights] = nlinearSplat(bilateralData,gridSize)

[nPoints,nDims] = size(bilateralData);
computeWeights = nargout==2;

% get ceil/floor for n-linear interpolation
floors = floor(bilateralData);
ceils = ceil(bilateralData);
remainders = bilateralData - floors;

% create dense matrix by adding weights to all neighboring vertices
% each neighboring vertex is a combination of floor or ceil in each
% dimension
vidIndices = zeros(nPoints,2^nDims,'uint32');
if computeWeights
    vidWeights = zeros(nPoints,2^nDims,'double');
end
for i=1:2^nDims
    % use the binary representation as floor (0) and ceil (1)
    bin = dec2bin(i-1,nDims);
    
    weights = ones(nPoints,1);
    % multiply weights for each dimension
    for j=1:nDims
        if bin(j)=='0' % floor
            if computeWeights
                weights = weights .* (1-remainders(:,j));
            end
            if j==1
                indices = floors(:,j);
            else
                indices = indices + prod(gridSize(1:j-1)).*(floors(:,j)-1);
            end
            
        else % ceil
            if computeWeights
                weights = weights .* remainders(:,j);
            end
            if j==1
                indices = ceils(:,j);
            else
                indices = indices + prod(gridSize(1:j-1)).*(ceils(:,j)-1);
            end
            
        end
    end
    vidIndices(:,i) = indices;
    if computeWeights
        vidWeights(:,i) = weights;
    end
end
end