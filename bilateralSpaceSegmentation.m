function segmentation = bilateralSpaceSegmentation(vidFn,maskFn,maskFrame,gridSize,dimensionWeights)

%% init
vidReader = VideoReader(vidFn);
vid = read(vidReader);
[h,w,~,f] = size(vid);
mask = imread(maskFn);

%for debugging, smaller video
vid = imresize(vid,.25);
mask = rgb2gray(im2double(imresize(mask,.25)));
f = 100;
vid=vid(:,:,:,1:f);

%% Lifting (3.1)
bilateralData = lift(vid,gridSize);
bilateralMask = lift(vid(:,:,:,maskFrame),gridSize);
maskValues = cat(2,mask(:)==0.,mask(:)~=0);

%% Splatting (3.2)
splattedMask = splat(bilateralMask,maskValues,gridSize);

%% Graph Cut (3.3)
addpath('GCmex2.0');
labels = graphcut(bilateralData,splattedMask,gridSize,dimensionWeights);

%% Splicing (3.4)
segmentation = slice(bilateralGrid,bilateralData);
