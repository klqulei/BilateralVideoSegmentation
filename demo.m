% Bilateral Space Video Segmentation
% Nicolas Maerki, Oliver Wang, Federico Perazzi, Alexander Sorkine-Hornung
% 
% Released for research purposes only. If you use this software you must
% cite the above paper!
%
% Read the README.txt before proceeding. 
%
% This is a simplified, unoptimized version of our paper. It only performs
% one task, which is to propagate a mask over a video. 
% 
%


%% parameters
vidFn = './data/ducks.mp4';
maskFn = {'./data/ducks01_0001_gt.ppm',...
          './data/ducks01_0100_gt.ppm',...
          './data/ducks01_0200_gt.ppm',...
          './data/ducks01_0300_gt.ppm',...
          './data/ducks01_0400_gt.ppm'};
maskFrame = [1,100,200,300,400];

% Grid parameters
intensityGridSize = 30;
chromaGridSize = 25;
spatialGridSize = 25;
temporalGridSize = 2;

% Graph Cut Parameters
pairwiseWeight = 1;
unaryWeight = 100000;
temporalWeight = 0.999;
intensityWeight = 0.05;
colorWeight = 0.03;
spatialWeight = 0.3;
minGraphWeight = 0.01;
connectAllComponents = false;
splatFirstFrameGT = true;

% Display parameters
threshold = .2;

dimensionWeights = [colorWeight, colorWeight, colorWeight, spatialWeight, spatialWeight, temporalWeight];
gridSize = [intensityGridSize chromaGridSize chromaGridSize spatialGridSize spatialGridSize temporalGridSize];

%% load video
vidReader = VideoReader(vidFn);
vid = read(vidReader);
%for debugging, smaller video
f = 400;
scale = .5;
vid=vid(:,:,:,1:f);
vid = imresize(vid,scale);
[h,w,~,l] = size(vid);
mask = zeros(h,w,length(maskFn));
for i=1:length(maskFn)    
    mask(:,:,i) = rgb2gray(im2double(imresize(imread(maskFn{i}),scale,'nearest')))~=1;
end

%% run video segmentation
tic
segmentation = bilateralSpaceSegmentation(vid,mask,maskFrame,gridSize,dimensionWeights,unaryWeight,pairwiseWeight);
endtime = toc;
disp(['Segmentation took ' num2str(endtime/f) 's per frame']);

%% postprocess video
segmentationf = segmentation;
segmentationf = imdilate(segmentationf,strel('disk',1));
segmentationf = imerode(segmentationf,strel('disk',1));

%% visualize result
implay(segmentationf);