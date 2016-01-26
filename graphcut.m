function labels = graphcut(bilateralData,splattedValues,gridSize,dimensionWeights)

minGraphWeight = 0.01;

% Determine the non-zero vertices of the grid
[existing, allIndices, allWeights, existingVertexWeights] = existingVertices(bilateralData, gridSize);

splattedValues = splattedValues(existing, :);

% Build pairwise cost matrix
A = createAdjacencyMatrix(gridSize, 0, 1, existing, dimensionWeights, double(existingVertexWeights), minGraphWeight);

% splattedCost = [splattedCost; zeros(size(A,1)-size(splattedCost,1),2)];

% Solve GraphCut
gch = GraphCut('open', splattedCost'*params.unaryWeight, [0,1;1,0]*params.pairwiseWeight, A);
[gch, L] = GraphCut('expand',gch);
[gch, smoothnessEnergy, dataEnergy] = GraphCut('energy', gch);
disp(['smoothnessEnergy: ' num2str(smoothnessEnergy) ...
    ', dataEnergy: ' num2str(dataEnergy)]);
GraphCut('close', gch);

% L = max(splattedCost(:,2), splattedCost(:,1));
allL = zeros(prod(params.gridSize),1);
allL(existing) = L;
