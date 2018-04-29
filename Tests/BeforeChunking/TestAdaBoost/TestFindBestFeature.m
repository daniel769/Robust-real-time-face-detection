function TestFindBestFeature()
    PosFeatureValues = round(rand(100,50)*10);
    NegFeatureValues = round(rand(100,50)*10);
    Weights = round(rand(1,100)*100);
    Weights = Weights./sum(Weights);
    Features = [];

[BestFeatureIndexInType, OverallIndex, FeatureType,threshold,polarity,error] = ...
    FindBestFeature(Features, PosFeatureValues, NegFeatureValues, Weights)
end



function [BestFeatureIndexInType, OverallIndex, FeatureType,threshold,polarity,error] = ...
    FindBestFeature(Features, PosFeatureValues, NegFeatureValues, Weights)

    nFeatures = size(PosFeatureValues,1) ;

    nPosFeat = size(PosFeatureValues,2);
    nNegFeat = size(NegFeatureValues,2);

%     nPosFeat = numel(PosFeatureValues{1}(1,:));
%     nNegFeat = numel(NegFeatureValues{2}(1,:));
   
    FeatLabelVec = [ones(1, nPosFeat)        zeros(1, nNegFeat)];

    error = 100;
    for (i=1:nFeatures)      
        [Thresh,polar, currError] = DetermineThresh(PosFeatureValues(i,:),NegFeatureValues(i,:),FeatLabelVec,Weights);
        if (currError < error)
            error = currError;
            threshold = Thresh;
            polarity = polar;
            OverallIndex = i;
%             [FeatureType, BestFeatureIndexInType] = FindIndexinType(i,Features);
        end
    end
BestFeatureIndexInType = [];
FeatureType = [];
end


% bugs fixed
%     nPosFeat = size(PosFeatureValues,2);
%     nNegFeat = size(NegFeatureValues,2);

function  [FeatureType, BestFeatureIndexInType] = FindIndexinType(Idx, Features) 
BestFeatureIndexInType = Idx;
Type = 1;
lastIdx = size(Features{Type},2);
while(lastIdx < Idx)
    BestFeatureIndexInType = BestFeatureIndexInType - size(Features{Type},2);
     lastIdx  = lastIdx + size(Features{Type + 1},2);
    Type = Type+1;  
end
FeatureType = Type;
end


function [Th , Polarity,error] = DetermineThresh ( FeatValPosVec, FeatValNegVec, FeatLabelVec,WeightsVec)

    nPosFeat = numel ( FeatValPosVec);
    nNegFeat = numel ( FeatValNegVec);

    FeatValVec      = [FeatValPosVec          FeatValNegVec];
    FeatTuple        = [FeatValVec'     FeatLabelVec'       WeightsVec'        (1:(nPosFeat + nNegFeat))'];
    
    %Looks like: [ FeatVal_1,  0/1,  W_1, Index_1 ]
    %                          [FeatVal_2,   0/1,  W_2, Index_2 ]
    %                           ...
    %                          [FeatVal_N,  0/1,  W_N, Index_N]
    FeatTuple = sortrows(FeatTuple,1); % sort rows by 1st column

   %find index and value 
    SumPosVec = cumsum(FeatTuple(:,2)        .* FeatTuple(:,3) );
    SumNegVec = cumsum((1 - FeatTuple(:,2)) .* FeatTuple(:,3) );
    
    %threshold = maximum value of difference
   [Th,MaxIdx] = max (  abs(SumPosVec - SumNegVec));
   Th = FeatTuple(MaxIdx,1);
   %find polarity - check pos values
    % if Polarity is positive 
%                 pos is left (smaller than thresh) (Faces |  Non-Faces)
   Polarity =  sign ( SumPosVec(MaxIdx) - SumNegVec(MaxIdx) );
   
   %calculate error
%    MaxIdx,Weights,Th
%    prepare 11111100000  
       errorIdx = [ones(MaxIdx,1) ; zeros(nPosFeat + nNegFeat - MaxIdx,1)];
       if (Polarity < 0)
           errorIdx = not(errorIdx);
       end
       errorIdx = xor(FeatTuple(:,2),errorIdx(:,1));
       weightedErrorVec = errorIdx .* FeatTuple(:,3);
       error = sum(weightedErrorVec);
end
