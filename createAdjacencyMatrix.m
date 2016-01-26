
function B = createAdjacencyMatrix( gridSize, centerWeight, neighborWeight, existingIndices, dimensionWeights, existingWeights, minGraphWeight )

dim = length(gridSize);
nPotentialVertices = prod(gridSize);

if nargin<4 || isempty(existingIndices)
   existingIndices = (1:prod(gridSize))'; 
   existingWeights = ones(prod(gridSize),1);
end
if nargin < 5
    dimensionWeights = ones(1,dim);
    minGraphWeight = 0;
end

for i=find(dimensionWeights)

    if i==1
        offset = 1;
    else
        offset = prod(gridSize(1:i-1));
    end
    if nargin > 3
        centerIndices = existingIndices;
    else
        centerIndices = (1:nPotentialVertices)';
    end
    leftIndices = centerIndices - offset;
    rightIndices = centerIndices + offset;
    
    % compute invalid indices and remove them
    maxidx = prod(gridSize(1:i));
    centerModulo = floor((centerIndices-1) / maxidx) * maxidx;
    leftIndices = leftIndices - centerModulo;
    rightIndices = rightIndices - centerModulo;
    invalidLeft = leftIndices < 1;
    invalidRight = rightIndices > maxidx;
    leftIndices = leftIndices + centerModulo;
    rightIndices = rightIndices + centerModulo;
    leftIndices(invalidLeft) = 0;
    rightIndices(invalidRight) = 0;
    
    % Get the indices relative to the vector of exising indices
    [~, leftIndices, leftCenterIndices] = intersect(existingIndices, leftIndices);
    [~, rightIndices, rightCenterIndices] = intersect(existingIndices, rightIndices);
    
    
    % Construct sparse matrix
    sp_i = [leftCenterIndices; leftCenterIndices; rightCenterIndices; rightCenterIndices];
    sp_j = [leftCenterIndices; leftIndices; rightCenterIndices; rightIndices];
    w1 = existingWeights(leftCenterIndices) + existingWeights(leftCenterIndices);
    w2 = existingWeights(leftCenterIndices) + existingWeights(leftIndices);
    w3 = existingWeights(rightCenterIndices) + existingWeights(rightCenterIndices);
    w4 = existingWeights(rightCenterIndices) + existingWeights(rightIndices);
    sp_v = [w1.*(dimensionWeights(i)*centerWeight*ones(size(leftCenterIndices,1),1)); ...
            w2.*(dimensionWeights(i)*neighborWeight*ones(size(leftCenterIndices,1),1)); ...
            w3.*(dimensionWeights(i)*centerWeight*ones(size(rightCenterIndices,1),1)); ...
            w4.*(dimensionWeights(i)*neighborWeight*ones(size(rightCenterIndices,1),1))];
    sp_v = max(sp_v, minGraphWeight);
    Bd = sparse(sp_i, sp_j, sp_v, size(existingIndices,1), size(existingIndices,1));
    if i==1
        B = Bd;
    else
        B = Bd + B;
    end
end
