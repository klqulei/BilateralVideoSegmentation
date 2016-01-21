% This function lifts data to [y,u,v,x,y,t] bilateral space
%
function bilateralData = lift(vid,gridsize)

[h,w,~,f] = size(vid);
numDims = 6;
bilateralData = zeros([h*w*f, numDims], 'single');

%% add color features
colors = reshape(im2double(vid),[h*w*f 3]);
colors = rgb2ntsc(colors); 
bilateralData(:,1:3) = colors;
clear colors;

%% add location features
[Y,X] = ndgrid(1:h,1:w);
Y = repmat(Y(:),[1 f]);
X = repmat(X(:),[1 f]);
bilateralData(:,4) = Y(:);
bilateralData(:,5) = X(:);

%% add temporal features
bilateralData(:,6) = repelem(1:f, w*h);
    
%% scale to grid size
eps = 0.001;
lBounds = min(bilateralData)-eps;
uBounds = max(bilateralData)+eps;
scaleFactors = (gridsize-1) ./ (uBounds - lBounds);
bilateralData = bsxfun(@minus, bilateralData, lBounds);
bilateralData = bsxfun(@times, bilateralData, scaleFactors)+1;
