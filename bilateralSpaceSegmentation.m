function segmentation = bilateralSpaceSegmentation(vid,mask,maskFrame,gridSize,dimensionWeights,unaryWeight,pairwiseWeight)
[h,w,~,f] = size(vid);

%% Lifting (3.1)
bilateralData = lift(vid,gridSize);
bilateralMask = lift(vid(:,:,:,maskFrame),gridSize,maskFrame);
maskValues = cat(2,mask(:)~=0.,mask(:)==0);

%% Splatting (3.2)
[occupiedVertices, occupiedVertexWeights, vidIndices, vidWeigths] = splatVideo(bilateralData, gridSize);
splattedMask = splat(bilateralMask,maskValues,gridSize);

%% Graph Cut (3.3)
labels = graphcut(occupiedVertices,occupiedVertexWeights,splattedMask,gridSize,dimensionWeights,unaryWeight,pairwiseWeight);

%% Splicing (3.4)
sliced = slice(labels,vidIndices,vidWeigths);

%% visualize output
segmentation = reshape(sliced,[h,w,f]);
%implay(segmentation);
