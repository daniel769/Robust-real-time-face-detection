function TestPostProcess()
%     ImageSizeX = 3;
%     ImageSizeY = 3;
%     FacesWinIdx = [];
%     dist = 2;
%     minBunch = 2;

%     ImageSizeX = 3;
%     ImageSizeY = 3;
%     FacesWinIdx = [2;2;3;3];
%     dist = 2;
%     minBunch = 2;

%     ImageSizeX = 3;
%     ImageSizeY = 3;
%     FacesWinIdx = [2 2; 1 2 ; 3 3; 3 3];
%     dist = 1;
%     minBunch = 2;

%     ImageSizeX = 5;
%     ImageSizeY = 5;
%     FacesWinIdx = [2 2 5; 1 2 5; 3 3 5; 3 3 5];
%     dist = 2;
%     minBunch = 2;

    ImageSizeX = 5;
    ImageSizeY = 5;
    FacesWinIdx = [2 2 5; 1 2 5; 3 3 5; 3 3 5];
    dist = 3;
    minBunch = 2;
    
    FacesWinIdx = PostProcess(ImageSizeX,ImageSizeY,FacesWinIdx,dist,minBunch);
end


function [FacesWinIdx] = PostProcess(ImageSizeX,ImageSizeY,FacesWinIdx,dist,minBunch)
    % create  "neighbors" map. valu is ind/0    
    NeighborMap = zeros(ImageSizeX,ImageSizeY);  
    for i = 1:size(FacesWinIdx,2)
        NeighborMap(FacesWinIdx(1,i),FacesWinIdx(2,i)) = i;
    end
    
    % create  binary "neigbors" map. valu is 1/0
    BinNeighborMap= single((NeighborMap ~=0));
    
    % create  indArray (from FacesWinIdx)
    TempFacesWinIdx = ones(1,size(FacesWinIdx,2));
    
    %build conv mask;
    mask = ones(dist*2+1);
    
    % execute conv;
    ConvolutedMap = conv2(BinNeighborMap,mask,'same');
    
    % if convMat<2 zero in  indArray;
    RejectedIndices = NeighborMap(find((ConvolutedMap < minBunch) & (ConvolutedMap > 0)));
    RejectedIndices(RejectedIndices == 0) = [];
    TempFacesWinIdx(1,RejectedIndices)=0;
    
    % delete values zeros from FacesWinIdx
    FacesWinIdx(:,find(TempFacesWinIdx == 0)) = [];
end