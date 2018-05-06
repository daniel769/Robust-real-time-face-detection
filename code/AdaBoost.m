function [SC,Weights,SumClassifierWeights] =  AdaBoost(Features, PosSet,NegSet,FeatNum,PosChunksFileNames, NegChunksFileNames, WC, Weights,SumClassifierWeights)

    %Features -  Offline created Viola&Jones  Haar like features. is given as a
    %vector of integral image indices. 
    %PosSet -  Box of II of Faces
    %NegSet -  ""                  of Non-Faces
    
    nPosExamples = size(PosSet,3);
    nNegExamples = size(NegSet,3);
    
    %train classifier with features
    [IdxInType, FeatureType, threshold,polarity,error] = ...
        FindBestFeature(PosChunksFileNames,NegChunksFileNames,Weights);
    BestFeature =  Features{FeatureType}(:,IdxInType) ;
    WC(FeatNum).feature = BestFeature;
    WC(FeatNum).featureType = FeatureType;
    WC(FeatNum).featureIdxInType = IdxInType;
    WC(FeatNum).threshold = threshold;
    WC(FeatNum).polarity = polarity;
    if error > 0 % error will never be equal or greater than 0.5, 
        Beta = error / (1 - error);
        % update weights     

        % prepare 2 vectors for UpdateWeights
        functionName = ['CalcValuesFeaturesType'  int2str(FeatureType) 'Vector'];
        fh = str2func(functionName);
        FeatValPosVec = fh(Features,IdxInType,PosSet);     
        FeatValNegVec = fh(Features,IdxInType,NegSet);             

        Weights = UpdateWeights (FeatValPosVec,FeatValNegVec,nPosExamples,nNegExamples,threshold,polarity,Weights,Beta);
        classifierWeight = log(1/Beta);
        WC(FeatNum).weight = classifierWeight;
        SumClassifierWeights = SumClassifierWeights + classifierWeight;
    else
        WC(FeatNum).weight = 1; % error is 0, there can be more than 1 feature
        SumClassifierWeights = WC(FeatNum).weight;
    end
    adaThreshold = SumClassifierWeights / 2;
    SC.WCVec = WC;
    SC.threshold = adaThreshold;
end

function [Weights] = UpdateWeights (FeatValPosVec,FeatValNegVec,nPosExamples,nNegExamples,threshold,polarity,Weights,Beta)
    %sort by examples values
    %apply threshold
    %xor with labels
    %update weighte for every missclassified example
    FeatLabelVec = [ones(1, nPosExamples)        zeros(1, nNegExamples)];

    FeatValVec      = [FeatValPosVec          FeatValNegVec];

    FeatTuple        = [FeatValVec'     FeatLabelVec'      Weights'      (1:(nPosExamples + nNegExamples))'];   


    FeatTuple = sortrows(FeatTuple, 1);
    Idx = max(find(FeatTuple(:,1) <= threshold));

    thresholdMask = [ones(Idx,1) ; zeros(nPosExamples + nNegExamples - Idx,1)];
   if (polarity < 0)
       thresholdMask = not(thresholdMask);
   end

   SuccessIdx = not(xor(FeatTuple(:,2),thresholdMask(:,1)));

   %weights updating Formula
   BetaVec = ones(nPosExamples + nNegExamples,1)*Beta;
   FeatTuple(:,3) = FeatTuple(:,3).*(BetaVec.^SuccessIdx);

   %sort the examples back to the original order
   FeatTuple = sortrows(FeatTuple,4);

   Weights = FeatTuple(:,3)';

   %normalize weights
    sumWeights =  sum(Weights);
    Weights = Weights./sumWeights;
end



function [BestFeatureIndexInType, FeatureType,threshold,polarity,error] = ...
                         FindBestFeature(PosChunksFileNames, NegChunksFileNames, Weights)
    error = 100;

    for i = 1: size(PosChunksFileNames,2)
        load(PosChunksFileNames{i});
        PosPartialFeaturesValues = partialFeaturesValues;
        clear partialFeaturesValues;
        load(NegChunksFileNames{i});
        NegPartialFeaturesValues = partialFeaturesValues;
        clear partialFeaturesValues;
        [BestFeatureIndexInChunk,Thresh,polar,currError] = ...
               FindBestFeatureInChunkPair(PosPartialFeaturesValues, NegPartialFeaturesValues, Weights);
        if (currError < error)
            error = currError;
            threshold = Thresh;
            polarity = polar;
            BestFeatureIndexInType = BestFeatureIndexInChunk + FeatRange(1) - 1;
            FeatureType = FeatType;
        end
        clear PosPartialFeaturesValues;
        clear NegPartialFeaturesValues;
    end
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

% function  [FeatureType, BestFeatureIndexInType] = FindIndexinType(Idx, Features) 
%     BestFeatureIndexInType = Idx;
%     Type = 1;
%     lastIdx = size(Features{Type},2);
%     while(lastIdx < Idx)
%         BestFeatureIndexInType = BestFeatureIndexInType - size(Features{Type},2);
%          lastIdx  = lastIdx + size(Features{Type + 1},2);
%         Type = Type+1;  
%     end
%     FeatureType = Type;
% end

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
