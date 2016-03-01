% Bilateral Space Video Segmentation
% CVPR 2016
% Nicolas Maerki, Oliver Wang, Federico Perazzi, Alexander Sorkine-Hornung
%
% This is a personal reimplementation of the method described in the above paper.
% The code is released for research purposes only. If you use this software you must
% cite the above paper!
%
% Read the README.txt before proceeding.
%
% This is a simplified, unoptimized version of our paper. It only performs
% one task, which is to propagate a mask over a video.

%%
% Splat bilateral data to the bilateral grid.  Note: this function splats both
% the mask and the video into bilateral space. NOT SPARSE - requires lots
% of memory
function [occupiedVertices, occupiedVertexWeights, vidIndices, vidWeights, splattedMask] = splat(bilateralData,maskData,maskValues,gridSize)

[~,nDims] = size(bilateralData);
nPotentialVertices = prod(gridSize);
nClasses = size(maskValues,2);

% splat the mask
[maskIndices,maskWeights] = nlinearSplat(maskData,gridSize);

% accumulate mask weights on bilateral vertices
splattedMask = zeros(nPotentialVertices, size(maskValues,2),'double');
for i=1:nClasses
    values = repmat(maskValues(:,i), 2^nDims, 1);
    splattedMask(:,i) = accumarray(maskIndices(:),maskWeights(:) .* values,[nPotentialVertices,1], @sum, 0);
end

% splat the video
[vidIndices,vidWeights] = nlinearSplat(bilateralData,gridSize);

% accumulate video weights on bilateral vertices
occupiedVertexWeights = accumarray(vidIndices(:),vidWeights(:),[prod(gridSize), 1]);

% keep only occupied vertices
occupiedVertices = find(occupiedVertexWeights);
occupiedVertexWeights = occupiedVertexWeights(occupiedVertices);

end

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

