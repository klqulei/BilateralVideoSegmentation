function labels = graphcut(existing,existingVertexWeights,splattedValues,gridSize,dimensionWeights,unaryWeight,pairwiseWeight)

addpath('GCMex2.0');

minGraphWeight = 0.01;

splattedValues = splattedValues(existing, :);

% Build pairwise cost matrix
A = createAdjacencyMatrix(gridSize, 0, 1, existing, dimensionWeights, double(existingVertexWeights), minGraphWeight);

% splattedCost = [splattedCost; zeros(size(A,1)-size(splattedCost,1),2)];

% Solve GraphCut
gch = GraphCut('open', splattedValues'*unaryWeight, [0,1;1,0]*pairwiseWeight, A);
[gch, L] = GraphCut('expand',gch);
[gch, smoothnessEnergy, dataEnergy] = GraphCut('energy', gch);
%disp(['smoothnessEnergy: ' num2str(smoothnessEnergy)', dataEnergy: ' num2str(dataEnergy)]);
GraphCut('close', gch);

% L = max(splattedCost(:,2), splattedCost(:,1));
labels = zeros(prod(gridSize),1);
labels(existing) = L;
