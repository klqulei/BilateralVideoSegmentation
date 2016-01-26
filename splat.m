% splat bilateral data to the bilateral grid
function splatted = splat(bilateralData,pointValues,gridSize)

nDims = length(gridSize);
nPoints = size(bilateralData,1);
nPotentialVertices = prod(gridSize);

% get ceil/floor for linear interpolation
floors = floor(bilateralData);
ceils = ceil(bilateralData);
remainders = bilateralData - floors;

% create sparse matrix by adding weights to all neighboring vertices
% each neighboring vertex is a combination of floor or ceil in each
% dimension
sp_i = zeros(2^nDims*(nPoints),1);
sp_v = zeros(2^nDims*(nPoints),1);
for i=1:2^nDims
    % use the binary representation as floor (0) and ceil (1)
    bin = dec2bin(i-1,nDims);
    
    weights = ones(nPoints,1);
    % multiply weights for each dimension
    for j=1:nDims
        if bin(j)=='0' % floor
            weights = weights .* (1-remainders(:,j));
            if j==1
                indices = floors(:,j);
            else
                indices = indices + prod(gridSize(1:j-1)).*(floors(:,j)-1);
            end
            
        else % ceil
            weights = weights .* remainders(:,j);
            if j==1
                indices = ceils(:,j);
            else
                indices = indices + prod(gridSize(1:j-1)).*(ceils(:,j)-1);
            end
            
        end
    end       
    sp_i((i-1)*nPoints+1:i*nPoints) = indices;
    sp_v((i-1)*nPoints+1:i*nPoints) = weights;
end


splatted = zeros(nPotentialVertices, size(pointValues,2));
for i=1:size(pointValues,2)
    values = repmat(pointValues(:,i), 2^nDims, 1);
    splatted(:,i) = accumarray(sp_i,sp_v .* values,[nPotentialVertices,1], @sum, 0);
end

end

