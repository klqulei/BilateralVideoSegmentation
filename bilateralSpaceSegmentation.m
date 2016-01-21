function segmentation = bilateralSpaceSegmentation(vidFn,maskFn,maskFrame,intensityGridSize,chromaGridSize,spatialGridSize,temporalGridSize)

%% init
vidReader = VideoReader(vidFn);
vid = read(vidReader);
[h,w,~,f] = size(vid);

%% Lifting (3.1)

%% Splatting (3.2)

%% Graph Cut (3.3)
addpath('GCmex2.0');

%% Splicing (3.4)