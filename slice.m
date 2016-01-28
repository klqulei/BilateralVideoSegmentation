% slice bilateral data from the bilateral grid
function sliced = slice(splatted,allIndices,allWeights)

sliced = zeros(size(allIndices,1),size(splatted,2));
for i=1:size(allIndices,2)
     sliced = sliced + splatted(allIndices(:,i),:) .* ...
        repmat(double(allWeights(:,i)),1,size(splatted,2));
end