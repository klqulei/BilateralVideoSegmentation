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
% the mask and the video into bilateral space.
function [occupiedVertices, occupiedVertexWeights, vidWeights, vidIndices, splattedMask] = splat(data,maskData,maskValues,gridSize)

[nPoints,nDims] = size(data);
nPotentialVertices = prod(gridSize);
nClasses = size(maskValues,2);

% splat the mask
%splattedMask = nlinearSplat2(maskData,maskValues,gridSize);

[maskIndices,maskWeights] = nlinearSplat(maskData,gridSize);

%
%accumulate mask weights on bilateral vertices
splattedMask = zeros(nPotentialVertices, size(maskValues,2),'double');
for i=1:nClasses
    values = repmat(maskValues(:,i), 2^nDims, 1);
    splattedMask(:,i) = accumarray(maskIndices(:),maskWeights(:) .* values,[nPotentialVertices,1], @sum, 0);
end


% splat the video
%occupiedVertexWeights = nlinearSplat2(data,,gridSize);

[vidIndices,vidWeights] = nlinearSplat(data,gridSize);
% accumulate video weights on bilateral vertices
occupiedVertexWeights = accumarray(vidIndices(:),vidWeights(:),[prod(gridSize), 1]);
occupiedVertices = find(occupiedVertexWeights);
occupiedVertexWeights = occupiedVertexWeights(occupiedVertices);
% keep only occupied vertices


end


