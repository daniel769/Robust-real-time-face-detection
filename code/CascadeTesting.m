function [Image,FacesWinIdx,amount] = CascadeTesting(Image,SlideSize,SC,SingleStep,EnlargeFactor,deltaX,deltaY, maxHeight, maxWidth, maxMemMB,EnablePP,rejectDist,minFaceBunch,EnablePre,EnablePreGlobal)
% input:
%     image -  given image

%     SC - cell arry of Strong classifiers
%     each Strong Classifier consists of: % SC - vector of WC + ada threshold
%     SC = struct('WCVec',{},'threshold',{});
%     each item in WCVec consists of:
%     WC = struct('feature',{},'featureType',{},'featureOverallIdx',{},'threshold',{},'polarity',{},'weight',{});

%  EnlargeFeatSteps - number of Enlargements of Features ("Detector Pyramid")

% output:
% FacesWinIdx - 2 opposite  vertices of face rectangle

%Downsize in order to be able to account Matlab's memory limitation
%  if size(Image,1) > maxHeight || size(Image,2) > maxWidth
%     Image = Downsize(Image, maxHeight, maxWidth);
%  end
 

% %image pre-processing
if EnablePreGlobal
    Image = PreProcess(2,Image);
end
%Image = imadjust(Image,stretchlim(Image),[]);

 OrigSlideSize = SlideSize;%avoid rounding problems
OrigSC = SC;
OrigDeltaX = deltaX;
OrigDeltaY = deltaY;
OrigEnlargeFactor = EnlargeFactor;
OrigRejectDist = rejectDist;

 if (SingleStep < 0)
     % calculate how many Enlargements are necessary
     HeightSteps = size(Image,1) ./ SlideSize;     
     HeightSteps = floor(  log10(HeightSteps)./ log10(EnlargeFactor) );
     WidthSteps = size(Image,2) ./ SlideSize;
     WidthSteps = floor( log10(WidthSteps) ./ log10(EnlargeFactor) );
     EnlargeFeatSteps = min( HeightSteps, WidthSteps ); 
 else if (SingleStep ==  0)
        EnlargeFeatSteps = 0;
     else 
         EnlargeFeatSteps = 0;
         EnlargeFactor = EnlargeFactor .^ SingleStep;
         SlideSize = round(OrigSlideSize * EnlargeFactor);
         deltaX = round(deltaX*EnlargeFactor);
         deltaY = round(deltaY*EnlargeFactor);
         rejectDist = round(OrigRejectDist * EnlargeFactor);
         SC = prepareSC(OrigSC,EnlargeFactor,OrigSlideSize,OrigSlideSize);   
     end
 end  
     

    %single window size
    [nSlidWinInChunk,nChunks,nSlidWin] = calcChunks(Image,SlideSize,deltaX,deltaY,maxMemMB);
    FacesWinIdx = [];
% % % %     Image = PreProcess(EnablePre,Image);
    FacesWinIdxStep = CascadeStep(Image,SlideSize,deltaX,deltaY,SC,nSlidWinInChunk,nChunks,nSlidWin,EnablePre);   
    FacesWinIdxStep = PostProcess(EnablePP,size(Image,1),size(Image,2),FacesWinIdxStep,rejectDist,minFaceBunch);
    FacesWinIdx = [FacesWinIdx FacesWinIdxStep];
    amount = [nSlidWin; size(FacesWinIdxStep,2)];
    %enlargements
    for i= 1:EnlargeFeatSteps
        % create features,threshols and sliding window indices per size
        SlideSize = round(OrigSlideSize * EnlargeFactor);
        deltaX = round(OrigDeltaX*EnlargeFactor);
        deltaY = round(OrigDeltaY*EnlargeFactor);
        rejectDist = round(OrigRejectDist * EnlargeFactor);
        SC = prepareSC(OrigSC,EnlargeFactor,OrigSlideSize,OrigSlideSize); 
        [nSlidWinInChunk,nChunks,nSlidWin] = calcChunks(Image,SlideSize,deltaX,deltaY,maxMemMB);
        FacesWinIdxStep = CascadeStep(Image,SlideSize,deltaX,deltaY,SC,nSlidWinInChunk,nChunks,nSlidWin,EnablePre);   
        FacesWinIdxStep = PostProcess(EnablePP,size(Image,1),size(Image,2),FacesWinIdxStep,rejectDist,minFaceBunch);
        amount = [amount [nSlidWin; size(FacesWinIdxStep,2)]];
        FacesWinIdx = [FacesWinIdx FacesWinIdxStep];
        EnlargeFactor = OrigEnlargeFactor * EnlargeFactor;
    end
    
    %post processing - 
%1. reject likely false alarams
%2. TODO: merging detections 

    
    Image = FrameFaces(Image,FacesWinIdx);
%     amount = size(FacesWinIdx,2);
end

function [FacesWinIdx] = PostProcess(Enable,ImageSizeX,ImageSizeY,FacesWinIdx,dist,minBunch)
    if Enable
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
end


function [Image] = FrameFaces(Image,FacesWinIdx)
    for i=1:size(FacesWinIdx,2)
        upX = FacesWinIdx(1,i);
        downX = FacesWinIdx(3,i);
        leftY = FacesWinIdx(2,i);
        rightY = FacesWinIdx(4,i);
        Image( upX,leftY:rightY)=255;
        Image( downX,leftY:rightY)=255;
        Image(upX:downX,leftY)=255;
        Image(upX:downX,rightY)=255;
    end
end

function [nSlidWinInChunk,nChunks,nSlidWin] = calcChunks(Image,SlideSize,deltaX,deltaY,maxMemMB)
    hSlidWin = floor((size(Image,1 )-SlideSize)/ deltaX) + 1;
    wSlidWin = floor((size(Image,2 )-SlideSize)/ deltaY) + 1;
    nSlidWin =  hSlidWin * wSlidWin;
    MB = 2^20;
    maxMemSize = maxMemMB * MB;
    % we wanted to find acquivalent to size of 'single' but lacked the time
    nChunks = ceil ((nSlidWin * ((SlideSize+1)^2) * 4) / maxMemSize); % integer division
    if (nChunks > 1)
        nSlidWinInChunk = floor(maxMemSize / (((SlideSize+1)^2) * 4));
    else
        nSlidWinInChunk = nSlidWin;
    end
end

function [Box,SlideWinIdxVec,nextX,nextY] = preparePartialBox(LastX,LastY,Image,SlideSize,deltaX,deltaY,nSlidWinInChunk,PreProcess)
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
    
    if PreProcess == 1
        [Box] = PreProcessSet(Box);
    end
    
    Box = cumsum(Box,1);
    Box = cumsum(Box,2);
end

% % function [Box,SlideWinIdxVec] = prepareRemainderBox(LastX,LastY,Image,SlideSize,deltaX,deltaY,Remainder)
% %     IterOnRows = size(Image,1) - SlideSize + 1;
% %     IterOnCols = size(Image,2) - SlideSize + 1;
% %     Box = single(zeros(SlideSize +1 ,SlideSize + 1,Remainder));
% %     SlideWinIdxVec = zeros(4,Remainder);
% % 
% %     RowIdx = LastX;
% %     ColIdx = LastY;
% %     while RowIdx <= IterOnRows
% %         while ColIdx <= IterOnCols
% %             Box(2:end,2:end,BoxIdx) = Image(RowIdx:RowIdx+SlideSize - 1,ColIdx:ColIdx + SlideSize - 1);
% %             SlideWinIdxVec(1,BoxIdx) = RowIdx;
% %             SlideWinIdxVec(2,BoxIdx) = ColIdx;
% %             SlideWinIdxVec(3,BoxIdx) = RowIdx + SlideSize - 1;
% %             SlideWinIdxVec(4,BoxIdx) = ColIdx + SlideSize - 1;
% %             ColIdx = ColIdx + deltaY;
% %         end
% %         RowIdx = RowIdx + deltaX;
% %         ColIdx = 1;
% %     end
% %     
% %     Box = cumsum(Box,1);
% %     Box = cumsum(Box,2);
% % end

function SC = prepareSC(SC,EnlargeFactor,SizeX,SizeY)
%Enlarges all the features and their threshold
% get original sides
% enlarge original sides. calculate new indices
% calculate new side enlarge factor from old side. enlarge threshold
    NewSizeX = round(SizeX .* EnlargeFactor) + 1;
     NewSizeY = round(SizeY .* EnlargeFactor) + 1;
    for i = 1:numel(SC)
        for j = 1:numel(SC(i).WCVec)
            [x y] = ind2sub([SizeX + 1 SizeY + 1],SC(i).WCVec(j).feature);
            if SC(i).WCVec(j).featureType == 1
                [NewX,NewY,  EnlargeFactorX, EnlargeFactorY] = prepareWCType1(x,y,EnlargeFactor);
            else if SC(i).WCVec(j).featureType == 2
                [NewX,NewY,  EnlargeFactorX, EnlargeFactorY] = prepareWCType2(x,y,EnlargeFactor);
            else if SC(i).WCVec(j).featureType == 3
                [NewX,NewY,  EnlargeFactorX, EnlargeFactorY] = prepareWCType3(x,y,EnlargeFactor);
            else if SC(i).WCVec(j).featureType == 4
                [NewX,NewY,  EnlargeFactorX, EnlargeFactorY] = prepareWCType4(x,y,EnlargeFactor);
            end
            end
            end
            end

            SC(i).WCVec(j).feature = sub2ind([NewSizeX NewSizeY],NewX,NewY);
             %  enlarge threshold
            SC(i).WCVec(j).threshold = round(SC(i).WCVec(j).threshold .* EnlargeFactorX .* EnlargeFactorY);
        end
    end
end

function [x,y,  EnlargeFactorX, EnlargeFactorY] = prepareWCType1(x,y,EnlargeFactor)        
         % get original sides
         % enlarge original sides. 
         OldSideX = x(3,1) - x(1,1);
         OldSideY = y(2,1) - y(1,1);
         
         newSideX = floor(OldSideX .* EnlargeFactor);
         newSideY = floor(OldSideY .* EnlargeFactor);
         
         EnlargeFactorX = newSideX ./ OldSideX;
         EnlargeFactorY = newSideY ./ OldSideY;
         
         %          calculate new indices
         
         %enlarge first index
         x(1,1) = round((x(1,1) - 1) .* EnlargeFactor) + 1;
         x(2,1) = round((x(2,1) - 1) .* EnlargeFactor) + 1;
         y(1,1) = round((y(1,1) - 1) .* EnlargeFactor) + 1;   
         y(3,1) = round((y(3,1) - 1) .* EnlargeFactor) + 1;   
         y(5,1) = round((y(5,1) - 1) .* EnlargeFactor) + 1;   
         
         % account for newSideX
         x(3,1) = x(1,1) + newSideX ;
         x(4,1) = x(2,1) + newSideX ;
         x(5,1) = x(3,1) + newSideX ;
         x(6,1) = x(4,1) + newSideX ;
         
         % account for newSideY
         y(2,1) = y(1,1) + newSideY;   
         y(4,1) = y(3,1) + newSideY;     
         y(6,1) = y(5,1) + newSideY;                   
end

function [x,y,   EnlargeFactorX, EnlargeFactorY] = prepareWCType2(x,y,EnlargeFactor)
         % get original sides
         % enlarge original sides. 
         OldSideX = x(4,1) - x(1,1);
         OldSideY = y(2,1) - y(1,1);
         
         newSideX = floor(OldSideX .* EnlargeFactor);
         newSideY = floor(OldSideY .* EnlargeFactor);
         
         EnlargeFactorX = newSideX ./ OldSideX;
         EnlargeFactorY = newSideY ./ OldSideY;
         
         %          calculate new indices
         
         %enlarge first index        
         x(1,1) = round((x(1,1) - 1) .* EnlargeFactor) + 1;
         x(2,1) = round((x(2,1) - 1) .* EnlargeFactor) + 1;
         x(3,1) = round((x(3,1) - 1) .* EnlargeFactor) + 1;        
         y(1,1) = round((y(1,1) - 1) .* EnlargeFactor) + 1;   
         y(4,1) = round((y(4,1) - 1) .* EnlargeFactor) + 1;   
         
         % account for newSideX
         x(4,1) = x(1,1) + newSideX ;
         x(5,1) = x(2,1) + newSideX ;
         x(6,1) = x(3,1) + newSideX ;
         
         % account for newSideY
         y(2,1) = y(1,1) + newSideY;   
         y(5,1) = y(4,1) + newSideY;  
         y(3,1) = y(2,1) + newSideY;
         y(6,1) = y(5,1) + newSideY;     
end

function [x,y,   EnlargeFactorX, EnlargeFactorY] = prepareWCType3(x,y,EnlargeFactor)
         % get original sides
         % enlarge original sides. 
         OldSideX = x(5,1) - x(1,1);
         OldSideY = y(2,1) - y(1,1);
         
         newSideX = floor(OldSideX .* EnlargeFactor);
         newSideY = floor(OldSideY .* EnlargeFactor);
         
         EnlargeFactorX = newSideX ./ OldSideX;
         EnlargeFactorY = newSideY ./ OldSideY;
         
         %          calculate new indices
         
         %enlarge first index        
         x(1,1) = round((x(1,1) - 1) .* EnlargeFactor) + 1;
         x(2,1) = round((x(2,1) - 1) .* EnlargeFactor) + 1;
         x(3,1) = round((x(3,1) - 1) .* EnlargeFactor) + 1;    
         x(4,1) = round((x(4,1) - 1) .* EnlargeFactor) + 1;   
         y(1,1) = round((y(1,1) - 1) .* EnlargeFactor) + 1;   
         y(5,1) = round((y(5,1) - 1) .* EnlargeFactor) + 1;   
         
         % account for newSideX
         x(5,1) = x(1,1) + newSideX ;
         x(6,1) = x(2,1) + newSideX ;
         x(7,1) = x(3,1) + newSideX ;
         x(8,1) = x(4,1) + newSideX ;
         
         % account for newSideY
         y(2,1) = y(1,1) + newSideY;   
         y(6,1) = y(5,1) + newSideY;  
         y(3,1) = y(2,1) + newSideY;
         y(7,1) = y(6,1) + newSideY;     
         y(4,1) = y(3,1) + newSideY;
         y(8,1) = y(7,1) + newSideY;  
end

function [x,y,   EnlargeFactorX, EnlargeFactorY] = prepareWCType4(x,y,EnlargeFactor)
         % get original sides
         % enlarge original sides. 
         OldSideX = x(4,1) - x(1,1);
         OldSideY = y(2,1) - y(1,1);
         
         newSideX = floor(OldSideX .* EnlargeFactor);
         newSideY = floor(OldSideY .* EnlargeFactor);
         
         EnlargeFactorX = newSideX ./ OldSideX;
         EnlargeFactorY = newSideY ./ OldSideY;
         
         %          calculate new indices
         
         %enlarge first index        
         x(1,1) = round((x(1,1) - 1) .* EnlargeFactor) + 1;
         x(2,1) = round((x(2,1) - 1) .* EnlargeFactor) + 1;
         x(3,1) = round((x(3,1) - 1) .* EnlargeFactor) + 1;        
         y(1,1) = round((y(1,1) - 1) .* EnlargeFactor) + 1;   
         y(4,1) = round((y(4,1) - 1) .* EnlargeFactor) + 1;   
         y(7,1) = round((y(7,1) - 1) .* EnlargeFactor) + 1;  
         
         % account for newSideX
         x(4,1) = x(1,1) + newSideX ;
         x(5,1) = x(2,1) + newSideX ;
         x(6,1) = x(3,1) + newSideX ;
         x(7,1) = x(4,1) + newSideX ;
         x(8,1) = x(5,1) + newSideX ;
         x(9,1) = x(6,1) + newSideX ;
         
         % account for newSideY
         y(2,1) = y(1,1) + newSideY;   
         y(5,1) = y(4,1) + newSideY;  
         y(8,1) = y(7,1) + newSideY;  
         y(3,1) = y(2,1) + newSideY;
         y(6,1) = y(5,1) + newSideY;    
         y(9,1) = y(8,1) + newSideY; 
end

function [Box,FacesWinIdx] =  ApplySC(Box,SC,FacesWinIdx)
    WeightedClassifiedValues = zeros(1,size(Box,3));
    % iterate on features
     for i = 1:numel(SC.WCVec)
         feature = SC.WCVec(i).feature;
         if SC.WCVec(i).featureType == 1
                 FeatureValues = CalcValuesFeaturesType1(feature,Box);
         else if SC.WCVec(i).featureType == 2
                 FeatureValues = CalcValuesFeaturesType2(feature,Box);
         else if SC.WCVec(i).featureType == 3
                 FeatureValues = CalcValuesFeaturesType3(feature,Box);
         else if SC.WCVec(i).featureType == 4
                 FeatureValues = CalcValuesFeaturesType4(feature,Box);
         end
         end
         end
         end
         % apply threshold, multiply by weights
         if SC.WCVec(i).polarity < 0
             weakclassifiedValues = FeatureValues > SC.WCVec(i).threshold;
         else
             weakclassifiedValues = FeatureValues <= SC.WCVec(i).threshold;
         end 
         %  insert into adaboost summer
         WeightedClassifiedValues = WeightedClassifiedValues +  (SC.WCVec(i).weight * weakclassifiedValues);         
     end
    % classify
    classifiedValues = WeightedClassifiedValues > SC.threshold;
    % shrink Box and Indices
    nonFacesIdx = find(classifiedValues == 0);
    Box(:,:,nonFacesIdx) = [];
    FacesWinIdx(:,nonFacesIdx) = [];
end
 
function FacesWinIdxStep = CascadeStep(Image,SlideSize,deltaX,deltaY,SC,nSlidWinInChunk,nChunks,nSlidWin,PreProcess)
    FacesWinIdxStep = [];
    LastX = 1;
    LastY = 1;
    RemainingSlidWIn = nSlidWin;
    for i=1:nChunks
        [PartialBox,SlideWinIdx,LastX,LastY] = preparePartialBox(LastX,LastY,Image,SlideSize,deltaX,deltaY,nSlidWinInChunk,PreProcess);
        [FacesWinIdxChunkStep] = CascadeStepOfChunk(SC,SlideWinIdx,PartialBox);
        FacesWinIdxStep = [FacesWinIdxStep FacesWinIdxChunkStep];
        
        RemainingSlidWIn = RemainingSlidWIn - nSlidWinInChunk;
        if RemainingSlidWIn < nSlidWinInChunk
            nSlidWinInChunk = RemainingSlidWIn;
        end
    end
end

function [FacesWinIdxChunkStep] = CascadeStepOfChunk(SC,SlideWinIdx,PartialBox)
   FacesLeft = true;
    Counter = 1;
    FacesWinIdx = SlideWinIdx;
    while FacesLeft
        if Counter <= numel(SC)
             [PartialBox,FacesWinIdx] = ApplySC(PartialBox,SC(Counter),FacesWinIdx);
            Counter = Counter + 1;
            if numel(PartialBox) == 0
                FacesLeft = false;
            end
        else
            break; % no more SC left
        end
    end
    FacesWinIdxChunkStep = FacesWinIdx;
end

function value = CalcValuesFeaturesType1(feature,Box)
    %subtract rectangle below from rectangle above
    rectangleAboveSum = FetchIIValue(feature(4),Box) -...
                                                    FetchIIValue(feature(3),Box)-...
                                                    FetchIIValue(feature(2),Box)+...
                                                    FetchIIValue(feature(1),Box);

    rectangleBelowSum = FetchIIValue(feature(6),Box) -...
                                                   FetchIIValue(feature(4),Box)-...
                                                   FetchIIValue(feature(5),Box)+...
                                                   FetchIIValue(feature(3),Box);
    value = rectangleAboveSum - rectangleBelowSum;
end

function value = CalcValuesFeaturesType2(feature,Box)
    %subtract left rectangle  from right rectangle 
    rightRectangleSum =  FetchIIValue(feature(6),Box ) - ...
                                                        FetchIIValue(feature(5),Box) - ...
                                                        FetchIIValue(feature(3),Box) + ...
                                                        FetchIIValue(feature(2),Box);
    leftRectangleSum =  FetchIIValue(feature(5),Box) - ...
                                                        FetchIIValue(feature(2),Box) - ...
                                                        FetchIIValue(feature(4),Box) + ...
                                                        FetchIIValue(feature(1),Box);
    value = rightRectangleSum - leftRectangleSum;
end

function value = CalcValuesFeaturesType3(feature,Box)
   %subtract left rectangle  and right rectangle from center rectangle
    rightRectangleSum =  FetchIIValue(feature(8),Box ) - ...
                                                        FetchIIValue(feature(4),Box) - ...
                                                        FetchIIValue(feature(7),Box) + ...
                                                        FetchIIValue(feature(3),Box);
    leftRectangleSum =  FetchIIValue(feature(6),Box) - ...
                                                        FetchIIValue(feature(5),Box) - ...
                                                        FetchIIValue(feature(2),Box) + ...
                                                        FetchIIValue(feature(1),Box);
    centerRectangleSum =  FetchIIValue(feature(7),Box) - ...
                                                        FetchIIValue(feature(6),Box) - ...
                                                        FetchIIValue(feature(3),Box) + ...
                                                        FetchIIValue(feature(2),Box);
    value = centerRectangleSum - rightRectangleSum - leftRectangleSum;
end

function value = CalcValuesFeaturesType4(feature,Box)
%subtract upper left rectangle  and lower right rectangle from lower
    %left rectangle  and upper right rectangle
    upperRightRectangleSum =  FetchIIValue(feature(6),Box ) - ...
                                                        FetchIIValue(feature(5),Box) - ...
                                                        FetchIIValue(feature(3),Box) + ...
                                                        FetchIIValue(feature(2),Box);
    upperLeftRectangleSum =  FetchIIValue(feature(5),Box) - ...
                                                        FetchIIValue(feature(4),Box) - ...
                                                        FetchIIValue(feature(2),Box) + ...
                                                        FetchIIValue(feature(1),Box);
    lowerRightRectangleSum =  FetchIIValue(feature(9),Box ) - ...
                                                        FetchIIValue(feature(6),Box) - ...
                                                        FetchIIValue(feature(8),Box) + ...
                                                        FetchIIValue(feature(5),Box);
    lowerLeftRectangleSum =  FetchIIValue(feature(8),Box) - ...
                                                        FetchIIValue(feature(5),Box) - ...
                                                        FetchIIValue(feature(7),Box) + ...
                                                        FetchIIValue(feature(4),Box);
    value = lowerLeftRectangleSum + upperRightRectangleSum - lowerRightRectangleSum - upperLeftRectangleSum;
end

function Image = Downsize(Image, maxHeight, maxWidth)
    r1 = maxHeight/size(Image,1);
    r2 = maxWidth/size(Image,2);
    if (r1 < r2) 
        Image=imresize(Image, r1);
    else
        Image=imresize(Image, r2);
    end 
end


