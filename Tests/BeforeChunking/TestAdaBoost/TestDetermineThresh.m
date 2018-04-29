function TestDetermineThresh()
%     FeatValPosVec = round(rand(1,50)*10);
%     FeatValNegVec = round(rand(1,50)*10)+10;
%     FeatLabelVec = [ones(1, 50)        zeros(1, 50)];
%     WeightsVec = round(rand(1,100)*100);
%     WeightsVec = WeightsVec./sum(WeightsVec);
%     
%     FeatValPosVec = round(rand(1,50)*10)+10;
%     FeatValNegVec = round(rand(1,50)*10);
%     FeatLabelVec = [ones(1, 50)        zeros(1, 50)];
%     WeightsVec = round(rand(1,100)*100);
%     WeightsVec = WeightsVec./sum(WeightsVec);
    
%     FeatValPosVec = round(rand(1,50)*10)+5;
%     FeatValNegVec = round(rand(1,50)*10);
%     FeatLabelVec = [ones(1, 50)        zeros(1, 50)];
%     WeightsVec = round(rand(1,100)*100);
%     WeightsVec = WeightsVec./sum(WeightsVec);

%     FeatValPosVec = round(rand(1,50)*10);
%     FeatValNegVec = round(rand(1,50)*10)+5;
%     FeatLabelVec = [ones(1, 50)        zeros(1, 50)];
%     WeightsVec = round(rand(1,100)*100);
%     WeightsVec = WeightsVec./sum(WeightsVec);
    
%     FeatValPosVec = round(rand(1,50)*10);
%     FeatValNegVec = round(rand(1,50)*10);
%     FeatLabelVec = [ones(1, 50)        zeros(1, 50)];
%     WeightsVec = round(rand(1,100)*100);
%     WeightsVec = WeightsVec./sum(WeightsVec);

%     posSize = 50;
%     negSize = 30;
%     FeatValPosVec = round(rand(1,posSize)*10)+5;
%     FeatValNegVec = round(rand(1,negSize)*10);
%     FeatLabelVec = [ones(1, posSize)        zeros(1, negSize)];
%     WeightsVec = round(rand(1,posSize + negSize)*100);
%     WeightsVec = WeightsVec./sum(WeightsVec);
    
%     posSize = 50;
%     negSize = 0;
%     FeatValPosVec = round(rand(1,posSize)*10)+5;
%     FeatValNegVec = round(rand(1,negSize)*10);
%     FeatLabelVec = [ones(1, posSize)        zeros(1, negSize)];
%     WeightsVec = round(rand(1,posSize + negSize)*100);
%     WeightsVec = WeightsVec./sum(WeightsVec);
    
        posSize = 50;
    negSize = 100;
    FeatValPosVec = round(rand(1,posSize)*10)+5;
    FeatValNegVec = round(rand(1,negSize)*10);
    FeatLabelVec = [ones(1, posSize)        zeros(1, negSize)];
    WeightsVec = round(rand(1,posSize + negSize)*100);
    WeightsVec = WeightsVec./sum(WeightsVec);
    
    [Thresh,polar, currError] = DetermineThresh(FeatValPosVec,FeatValNegVec,FeatLabelVec,WeightsVec);
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