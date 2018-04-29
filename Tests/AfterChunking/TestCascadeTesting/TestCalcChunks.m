function TestCalcChunks()

% Image = ones(800,1000);
% SlideSize = 19;
% deltaX = 1;
% deltaY = 1;
% maxMemMB = 100;
% 
% [nSlidWinInChunk,nChunks,nSlidWin,Remainder] = calcChunks(Image,SlideSize,deltaX,deltaY,maxMemMB)
% 
% calculatedSizeBytes = nSlidWinInChunk  * ((SlideSize+1)^2)* 4;
% calculatedSizeMB = calculatedSizeBytes / (2^20);

% Image = ones(800,1000);
% SlideSize = 30;
% deltaX = 2;
% deltaY = 2;
% maxMemMB = 100;
% 
% [nSlidWinInChunk,nChunks,nSlidWin,Remainder] = calcChunks(Image,SlideSize,deltaX,deltaY,maxMemMB)
% 
% calculatedSizeBytes = nSlidWinInChunk  * ((SlideSize+1)^2)* 4;
% calculatedSizeMB = calculatedSizeBytes / (2^20);

% Image = ones(80,100);
% SlideSize = 30;
% deltaX = 2;
% deltaY = 2;
% maxMemMB = 100;
% 
% [nSlidWinInChunk,nChunks,nSlidWin,Remainder] = calcChunks(Image,SlideSize,deltaX,deltaY,maxMemMB)
% 
% calculatedSizeBytes = nSlidWinInChunk  * ((SlideSize+1)^2)* 4;
% calculatedSizeMB = calculatedSizeBytes / (2^20);

Image = ones(5,6);
SlideSize = 3;
deltaX = 2;
deltaY = 2;
maxMemMB = 100;

[nSlidWinInChunk,nChunks,nSlidWin,Remainder] = calcChunks(Image,SlideSize,deltaX,deltaY,maxMemMB)

calculatedSizeBytes = nSlidWinInChunk  * ((SlideSize+1)^2)* 4;
calculatedSizeMB = calculatedSizeBytes / (2^20);
end

function [nSlidWinInChunk,nWholeChunks,nSlidWin,Remainder] = calcChunks(Image,SlideSize,deltaX,deltaY,maxMemMB)
    hSlidWin = floor((size(Image,1 )-SlideSize)/ deltaX) + 1;
    wSlidWin = floor((size(Image,2 )-SlideSize)/ deltaY) + 1;
    nSlidWin =  hSlidWin * wSlidWin;
    MB = 2^20;
    maxMemSize = maxMemMB * MB;
    % we wanted to find acquivalent to size of 'single' but lacked the time
    nChunks = ceil ((nSlidWin * ((SlideSize+1)^2) * 4) / maxMemSize); % integer division
    if (nChunks > 1)
        nSlidWinInChunk = floor(maxMemSize / (((SlideSize+1)^2) * 4));
        Remainder = mod((nChunks * nSlidWinInChunk),nSlidWin);    
        nWholeChunks = nChunks - 1;
    else
        nSlidWinInChunk = nSlidWin;
        Remainder = 0;
    end
end