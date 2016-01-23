% Bilateral Space Video Segmentation
% Nicolas Maerki, Oliver Wang, Federico Perazzi, Alexander Sorkine-Hornung
% 
% Released for research purposes only. If you use this software you must
% cite the above paper!
%
% This is a simplified, unoptimized version of our paper. It only performs
% one task, which is to take a single mask, and propagate it over a video. 
% 
% This method also uses a third party GraphCut library:
% http://vision.csd.uwo.ca/code/
% If you use this you have to cite their works as well! Please refer to the
% webpage for thge most up to date information.
%


%% parameters
vidFn = './data/chair.mp4';
maskFn = './data/mask.png';
maskFrame = 1;

intensityGridSize = 35;
chromaGridSize = 30;
spatialGridSize = 30;
temporalGridSize = 2;

params.firstVideo = 20;
params.maxVideos = 1000;
params.outputName = 'default';
params.writeResult = true;


% GENERAL
params.stride = 8;
params.inputRatio = 1;
params.colorMode = 'ntsc';
params.medianFilterRefinement = true;
params.pairwiseWeight = 1;
params.unaryWeight = 100000;
params.temporalWeight = 0.999;
params.intensityWeight = 0.05;
params.colorWeight = 0.03;
params.spatialWeight = 0.3;
params.minGraphWeight = 0.01;
params.connectAllComponents = false;
params.splatFirstFrameGT = true;



%% run video segmentation
segmentation = bilateralSpaceSegmentation(vidFn,maskFn,maskFrame,intensityGridSize,chromaGridSize,spatialGridSize,temporalGridSize);

%% visualize result
implay(segmentation);