% slice bilateral data from the bilateral grid
function sliced = slice(labels,vidIndices,vidWeights)

sliced = zeros(size(vidIndices,1),size(labels,2));
for i=1:size(vidIndices,2)
     sliced = sliced + labels(vidIndices(:,i),:) .* ...
        repmat(double(vidWeights(:,i)),1,size(labels,2));
end