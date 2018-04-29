function TestFindBestFeatureInChunkPair()
    PosFeatureValues = round(rand(100,50)*10);
    NegFeatureValues = round(rand(100,50)*10);
    Weights = round(rand(1,100)*100);
    Weights = Weights./sum(Weights);
    
    [BestFeatureIndexInChunk,threshold,polarity,error] = ...
                        FindBestFeatureInChunkPair(PosFeatureValues, NegFeatureValues, Weights)
end

function [BestFeatureIndexInChunk,threshold,polarity,error] = ...
                        FindBestFeatureInChunkPair(PosFeatureValues, NegFeatureValues, Weights)
     % For each feature
    %        Do the feature operation in one go on all slices of the box
    %        Multiply with weights
    %        Determine threshold
    %        Save threshold
    %        Calculate error of feature
    %       Do the feature operation in one go on all blocks, apply threshold, inverse
    %       faces results, multiply by weights and summate to achieve the error rate.
    %       Save data if current feature has lowest error so far.
    % Select the feature with the lowest error
                    
    nFeatures = size(PosFeatureValues,1) ;
    
    nPosFeat = size(PosFeatureValues,2);
    nNegFeat = size(NegFeatureValues,2);

%     nPosFeat = numel(PosFeatureValues{1}(1,:));
%     nNegFeat = numel(NegFeatureValues{2}(1,:));
   
    FeatLabelVec = [ones(1, nPosFeat)        zeros(1, nNegFeat)];

    error = 100;
    for i=1:nFeatures
        [Thresh,polar, currError] = DetermineThresh(PosFeatureValues(i,:),NegFeatureValues(i,:),FeatLabelVec,Weights);
        if (currError < error)
            error = currError;
            threshold = Thresh;
            polarity = polar;
            BestFeatureIndexInChunk = i;
        end
    end
end

function [Th , Polarity,error] = DetermineThresh ( FeatValPosVec, FeatValNegVec, FeatLabelVec,WeightsVec)
    % concatenate pos + neg
    % sort pos + neg labels, values, weights, remember indices, neg offset
    % multiply labels times weights
    %accumulate pos weighted labels
    %accumulate neg  weighted labels
    % subtract one from the other
    % find max, determine threshold
    % count num of pos before threshold to determine polarity

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
%                 pos is left (smaller than or equals thresh) (Faces |
%                 Non-Faces)
   Polarity =  sign ( SumPosVec(MaxIdx) - SumNegVec(MaxIdx) );
   
   %calculate error
%    MaxIdx,Weights,Th
%    prepare 11111100000  

%                 pos is left (smaller than or equals thresh) (Faces |
%                 Non-Faces)
       errorIdx = [ones(MaxIdx,1) ; zeros(nPosFeat + nNegFeat - MaxIdx,1)];
       if (Polarity < 0)
           errorIdx = not(errorIdx);
       end
       errorIdx = xor(FeatTuple(:,2),errorIdx(:,1));
       weightedErrorVec = errorIdx .* FeatTuple(:,3);
       error = sum(weightedErrorVec);
end
