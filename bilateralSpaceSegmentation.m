function segmentation = bilateralSpaceSegmentation(vidFn,maskFn,maskFrame,intensityGridSize,chromaGridSize,spatialGridSize,temporalGridSize)

%% init
vidReader = VideoReader(vidFn);
vid = read(vidReader);
[h,w,~,f] = size(vid);

%% lifting
