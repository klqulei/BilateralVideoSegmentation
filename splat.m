% splat bilateral data to the bilateral grid
function [occupiedVertices, occupiedVertexWeights, vidIndices, vidWeights, splattedMask] = splat(bilateralData,maskData,maskValues,gridSize)

[~,nDims] = size(bilateralData);
nPotentialVertices = prod(gridSize);
nClasses = size(maskValues,2);

[maskIndices,maskWeights] = bilinearSplat(maskData,gridSize);

splattedMask = zeros(nPotentialVertices, size(maskValues,2));
for i=1:nClasses
    values = repmat(maskValues(:,i), 2^nDims, 1);
    splattedMask(:,i) = accumarray(maskIndices(:),maskWeights(:) .* values,[nPotentialVertices,1], @sum, 0);
end

[vidIndices,vidWeights] = bilinearSplat(bilateralData,gridSize);

occupiedVertexWeights = accumarray(vidIndices(:),vidWeights(:),[prod(gridSize), 1]);
occupiedVertices = find(occupiedVertexWeights);
occupiedVertexWeights = occupiedVertexWeights(occupiedVertices);

end

