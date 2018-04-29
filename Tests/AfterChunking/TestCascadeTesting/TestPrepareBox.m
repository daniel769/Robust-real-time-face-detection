function TestPrepareBox()

% image = round(rand(300,280)*255);
% SlideSize = 19;
% deltaX = 5;
% deltaY = 5;

image = ones(300,280);
image = cumsum(image,2);
SlideSize = 19;
deltaX = 5;
deltaY = 5;
[Box,SlideWinIdxVec] = prepareBox(image,SlideSize,deltaX,deltaY);
end

function [Box,SlideWinIdxVec] = prepareBox(Image,SlideSize,deltaX,deltaY)
%Input:SlideSize - without the zero padding
% delta - integer only
%Output:
%Description: Copy Given Image Regions to Box slices (after zero padding), and save region
%indices
%SlideWinIdx = [upX; leftY; downX; rightY)
IterOnRows = size(Image,1) - SlideSize + 1;
IterOnCols = size(Image,2) - SlideSize + 1;
BoxIdx = 1;
numOfSlidingWindow = ceil(IterOnRows/deltaX) * ceil(IterOnCols/deltaY);
Box = zeros(SlideSize +1 ,SlideSize + 1,numOfSlidingWindow);
SlideWinIdxVec = zeros(4,numOfSlidingWindow);
    for i=1:deltaX:IterOnRows
        for j=1:deltaY:IterOnCols
            Box(2:end,2:end,BoxIdx) = Image(i:i+SlideSize - 1,j:j + SlideSize - 1);
            SlideWinIdxVec(1,BoxIdx) = i;
            SlideWinIdxVec(2,BoxIdx) = j;
            SlideWinIdxVec(3,BoxIdx) = i + SlideSize - 1;
            SlideWinIdxVec(4,BoxIdx) = j + SlideSize - 1;
            BoxIdx = BoxIdx + 1;
        end
    end
end