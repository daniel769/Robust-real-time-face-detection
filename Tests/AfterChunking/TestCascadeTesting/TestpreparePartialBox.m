function TestpreparePartialBox()
% LastX = 1
% LastY = 1
% Image = ones(5,6);
% SlideSize = 3;
% deltaX = 2;
% deltaY = 2;
% nSlidWinInChunk = 4;
% ChunkIdx = 1;

% LastX = 1
% LastY = 1
% Image = ones(5,6);
% SlideSize = 3;
% deltaX = 2;
% deltaY = 2;
% nSlidWinInChunk = 2;
% ChunkIdx = 1;

LastX = 1;
LastY = 5;
Image = ones(5,6);
SlideSize = 3;
deltaX = 2;
deltaY = 2;
nSlidWinInChunk = 2;
ChunkIdx = 2;

[Box,SlideWinIdxVec,nextX,nextY] = preparePartialBox(LastX,LastY,Image,SlideSize,deltaX,deltaY,nSlidWinInChunk)

end

function [Box,SlideWinIdxVec,nextX,nextY] = preparePartialBox(LastX,LastY,Image,SlideSize,deltaX,deltaY,nSlidWinInChunk)
    IterOnRows = size(Image,1) - SlideSize + 1;
    IterOnCols = size(Image,2) - SlideSize + 1;
    Box = single(zeros(SlideSize +1 ,SlideSize + 1,nSlidWinInChunk));
    SlideWinIdxVec = zeros(4,nSlidWinInChunk);

    BoxIdx = 1;
    RowIdx = LastX;
    ColIdx = LastY;
    while RowIdx <= IterOnRows && BoxIdx <= nSlidWinInChunk
        while ColIdx <= IterOnCols && BoxIdx <= nSlidWinInChunk
            Box(2:end,2:end,BoxIdx) = Image(RowIdx:RowIdx+SlideSize - 1,ColIdx:ColIdx + SlideSize - 1);
            SlideWinIdxVec(1,BoxIdx) = RowIdx;
            SlideWinIdxVec(2,BoxIdx) = ColIdx;
            SlideWinIdxVec(3,BoxIdx) = RowIdx + SlideSize - 1;
            SlideWinIdxVec(4,BoxIdx) = ColIdx + SlideSize - 1;
            BoxIdx = BoxIdx + 1;
            ColIdx = ColIdx + deltaY;
        end
        nextX = RowIdx;
        RowIdx = RowIdx + deltaX;
        nextY = ColIdx;
        ColIdx = 1;
    end
    
    Box = cumsum(Box,1);
    Box = cumsum(Box,2);
end