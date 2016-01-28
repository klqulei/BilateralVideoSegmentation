function [occupiedVertices, occupiedVertexWeights, vidIndices, vidWeights] = splatVideo(bilateralData, gridSize);
    
    [nPoints, dim] = size(bilateralData);

    % get ceil/floor for linear interpolation
    floors = floor(bilateralData);
    ceils = ceil(bilateralData);
    remainders = bilateralData - floors;

    % create sparse matrix by adding weights to all neighboring vertices
    % each neighboring vertex is a combination of floor or ceil in each
    % dimension
    vidIndices = zeros(nPoints,2^dim, 'uint32');
    vidWeights = zeros(nPoints,2^dim, 'single');
    indices = zeros(nPoints,1, 'uint32');
    for i=1:2^dim
        % use the binary representation as floor (0) and ceil (1)
        bin = dec2bin(i-1,dim);

        % multiply weights for each dimension
        weights = ones(nPoints,1,'single');
        
        for j=1:dim
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

        vidIndices(:,i) = indices;
        vidWeights(:,i) = weights;
    end

    occupiedVertexWeights = accumarray(vidIndices(:),vidWeights(:),[prod(gridSize), 1]);
    occupiedVertices = find(occupiedVertexWeights);
    occupiedVertexWeights = occupiedVertexWeights(occupiedVertices);  
end
