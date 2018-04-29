function [] = testUpdateWeights()
% FeatValPosVec = [20 ,40, 60, 80];
% FeatValNegVec = [50,90,110,120];
% nPosFeat = numel(FeatValPosVec);
% nNegFeat = numel(FeatValNegVec);
% threshold = 100;
% polarity = 0;
% Weights = ones(1,  nPosFeat+nNegFeat)/( nPosFeat+nNegFeat);
% %LabelMask = [1,1,1,1,0,0,0,0]; 
% ErrorVector = [0,0,0,0,1,1,0,0];
% error = sum( Weights.*ErrorVector) ; %need to calcualte this
% Beta  = error / (1 - error);

% FeatValNegVec = [20 ,40, 60, 80];
% FeatValPosVec = [50,90,110,120];
% nPosFeat = numel(FeatValPosVec);
% nNegFeat = numel(FeatValNegVec);
% threshold = 100;
% polarity = -1;
% Weights = ones(1,  nPosFeat+nNegFeat)/( nPosFeat+nNegFeat);
% %LabelMask = [1,1,1,1,0,0,0,0]; 
% ErrorVector = [1,1,0,0,0,0,0,0];
% error = sum( Weights.*ErrorVector) ; %need to calcualte this
% Beta  = error / (1 - error);

% FeatValNegVec = [20 ,40, 60, 80];
% FeatValPosVec = [150,200,110,120];
% nPosFeat = numel(FeatValPosVec);
% nNegFeat = numel(FeatValNegVec);
% threshold = 100;
% polarity = -1;
% Weights = ones(1,  nPosFeat+nNegFeat)/( nPosFeat+nNegFeat);
% %LabelMask = [1,1,1,1,0,0,0,0]; 
% ErrorVector = [0,0,0,0,0,0,0,0];
% error = sum( Weights.*ErrorVector) ; %need to calcualte this
% Beta  = error / (1 - error);

FeatValNegVec = [20 ,20, 20, 20];
FeatValPosVec = [150,150,150,180];
nPosFeat = numel(FeatValPosVec);
nNegFeat = numel(FeatValNegVec);
threshold = 150;
polarity = -1;
Weights = ones(1,  nPosFeat+nNegFeat)/( nPosFeat+nNegFeat);
%LabelMask = [1,1,1,1,0,0,0,0]; 
ErrorVector = [1,1,1,0,0,0,0,0];
error = sum( Weights.*ErrorVector) ; %need to calcualte this
Beta  = error / (1 - error);

[Weights] = UpdateWeights (FeatValPosVec,FeatValNegVec,nPosFeat,nNegFeat,threshold,polarity,Weights,Beta);

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
