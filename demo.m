% Bilateral Space Video Segmentation
% Nicolas Maerki, Oliver Wang, Federico Perazzi, Alexander Sorkine-Hornung
% 
% Released for research purposes only. If you use this software you must
% cite the above paper!
% 
% This method also uses a third party GraphCut library:
% http://vision.csd.uwo.ca/code/
% If you use this you have to cite their works as well! Please refer to the
% webpage for thge most up to date information.

%% parameters
vidFn = './data/chair.mp4';
maskFn = './data/mask.png';
maskFrame = 1;

intensityGridSize = 35;
chromaGridSize = 30;
spatialGridSize = 30;
temporalGridSize = 2;

%% run video segmentation
segmentation = bilateralSpaceSegmentation(vidFn,maskFn,maskFrame,intensityGridSize,chromaGridSize,spatialGridSize,temporalGridSize);

%% visualize result
implay(segmentation);