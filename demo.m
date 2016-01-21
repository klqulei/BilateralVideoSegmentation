% Bilateral Space Video Segmentation
% Nicolas Maerki, Oliver Wang, Federico Perazzi, Alexander Sorkine-Hornung
% 
% Released for research purposes only. If you use this software you must
% cite the above paper!
% 
%

%% parameters
vidFn = './data/vid1.MP4';
maskFn = '';
maskFrame = 1;

intensityGridSize = 35;
chromaGridSize = 30;
spatialGridSize = 30;
temporalGridSize = 2;

%% run video segmentation
segmentation = bilateralSpaceSegmentation(vidFn,maskFn,maskFrame,intensityGridSize,chromaGridSize,spatialGridSize,temporalGridSize);

%% visualize result
implay(segmentation);