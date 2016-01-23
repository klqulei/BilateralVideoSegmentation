function segmentation = bilateralSpaceSegmentation(vidFn,maskFn,maskFrame,intensityGridSize,chromaGridSize,spatialGridSize,temporalGridSize)

%% init
vidReader = VideoReader(vidFn);
vid = read(vidReader);
[h,w,~,f] = size(vid);
gridSize = [intensityGridSize chromaGridSize chromaGridSize spatialGridSize spatialGridSize temporalGridSize];
mask = imread(maskFn);

%for debugging, smaller video
vid = imresize(vid,.25);
mask = imresize(mask,.25);
f = 100;
vid=vid(:,:,:,1:f);

vid = imresize(vid,.25);

%% Lifting (3.1)
bilateralData = lift(vid,gridSize);
maskData = lift(mask,gridSize);

%% Splatting (3.2)
bilateralGrid = splat(maskData, gridSize);

%% Graph Cut (3.3)
addpath('GCmex2.0');

%% Splicing (3.4)
segmentation = slice(bilateralGrid,bilateralData);
