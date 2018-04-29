    function TestCascadeTesting
%     Image = round(rand(300,280)*255);
%     SlideSize = 19;
%     load SC;
%     SC = Cas;
%     EnlargeFactor = 1.25;
%     EnlargeFeatSteps = 11;
%     deltaX = 5;
%     deltaY = 5;
%      [FacesWinIdx] = CascadeTesting(Image,SlideSize,SC,EnlargeFactor,EnlargeFeatSteps,deltaX,deltaY)

load SC06ext3;
% Image = imread('queen-big.tif');
%Image = readImage('next.tif');
Image = readImage('cast1.tif');
SlideSize = 19;
EnlargeFactor = 1.25;
SingleStep =1;
deltaX = 1;
deltaY = 1;
maxHeight = 288;
maxWidth = 384;
tic
 [FramedImage,amount] = CascadeTesting(Image,SlideSize,SC,SingleStep,EnlargeFactor,deltaX,deltaY,maxHeight, maxWidth);
 toc
 showImage(FramedImage);
end