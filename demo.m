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
maskFrames = [1,100,200,300,400];

% Grid parameters
intensityGridSize = 35;
chromaGridSize = 25;
spatialGridSize = 25;
temporalGridSize = 3;

% Graph Cut Parameters
pairwiseWeight = 1;
unaryWeight = 100000;
temporalWeight = 0.999;
intensityWeight = 0.05;
colorWeight = 0.03;
spatialWeight = 0.3;
minGraphWeight = 0.01;

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
speedscale = 2;
vid=vid(:,:,:,1:speedscale:f);
vid = imresize(vid,scale);
[h,w,~,f] = size(vid);
mask = zeros(h,w,length(maskFn));
for i=1:length(maskFn)    
    mask(:,:,i) = rgb2gray(im2double(imresize(imread(maskFn{i}),scale,'nearest')))~=1;
end
maskFrames = ceil(maskFrames/speedscale);

%% run video segmentation
tic
segmentation = bilateralSpaceSegmentation(vid,mask,maskFrames,gridSize,dimensionWeights,unaryWeight,pairwiseWeight);
endtime = toc;
disp(['Segmentation took ' num2str(endtime/f) 's per frame']);

%% postprocess video
segmentation = uint8(255*segmentation);
%segmentation = imdilate(segmentation,strel('disk',1));
%segmentation = imerode(segmentation,strel('disk',1));

%% visualize result
segmentation = reshape(segmentation,[h,w,1,f]);
implay([segmentation(:,:,[1 1 1],:) vid]);