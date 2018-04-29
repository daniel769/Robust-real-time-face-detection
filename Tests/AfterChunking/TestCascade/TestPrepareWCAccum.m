function TestPrepareWCAccum()
load Features;

nExamples = 100;

PosSet = round(rand(20,20,nExamples)*100) + 1;
NegSet = round(rand(20,20,nExamples)*100) + 1;


    Path1 = 'C:\M.Sc\CV\matlab\Data\tempTest\partialFeatureValuesType1Chunk01.mat';
    Path2 = 'C:\M.Sc\CV\matlab\Data\tempTest\partialFeatureValuesType1Chunk02.mat';

    PosChunksFileNames = cell(1, 2);
    PosChunksFileNames{1} = Path2;
    PosChunksFileNames{2} = Path1;
    NegChunksFileNames = cell(1, 2);
    NegChunksFileNames{1} = Path2;
    NegChunksFileNames{2} = Path1;
    
Fnum = 1;

SC(1) = HandleAdaBoost(Features, Fnum,PosChunksFileNames, NegChunksFileNames,PosSet,NegSet);

Fnum = 2;

SC(1) = HandleAdaBoost(Features, Fnum,PosChunksFileNames, NegChunksFileNames,PosSet,NegSet);
    
%     PosFeatureValues = round(rand(400,50)*10);
% NegFeatureValues = round(rand(400,50)*10);
% PosFeatureValues(22,:) = round(rand(1,50)*10+ 20) ;
% 
% WC = struct('feature',{},'featureType',{},'featureOverallIdx',{},'threshold',{},'polarity',{},'weight',{});
% WC = [];
%     % SC - vector of WC + ada threshold
%     SC = struct('WCVec',{},'threshold',{});
%     SC = [];
%     error = 1/8;
%     Beta = error / (1 - error);
%     classifierWeight = log(1/Beta);
%     
%     WC.feature = PosFeatureValues(22,:);
%     WC.featureType = 1;
%     WC.featureOverallIdx = 22;
%     WC.threshold = 11;
%     WC.polarity = -1;
%     WC.weight = classifierWeight;
%     
%     SC.WCVec = WC;
%     SC.threshold = WC.weight./2;

[PosAccumVec,NegAccumVec] = PrepareWCAccum(SC,Features,PosSet,NegSet);
end

function [PosAccumVec,NegAccumVec] = PrepareWCAccum(SC,Features,PosSet,NegSet)
%     WC = struct('feature',{},'featureType',{},'featureOverallIdx',{},'threshold',{},'polarity',{},'weight',{});
%     % SC - vector of WC + ada threshold
%     SC = struct('WCVec',{},'threshold',{});
% 
%     does linear combination of classifiers on all examples (positive &
%     negative) in one go

    PosAccumVec = zeros(1,size(PosSet, 3) );
    NegAccumVec = zeros(1,size(NegSet, 3) );
    for i=1:numel(SC.WCVec)
        % accumulate For Each WC, Weighted classification results in "accumVec"
                %Use Threshold
                WCThresh = SC.WCVec(i).threshold;
                WCType = SC.WCVec(i).featureType;
                WCIndexInType = SC.WCVec(i).featureIdxInType;
                WCWeight = SC.WCVec(i).weight;
                WCPolarity = SC.WCVec(i).polarity;
                
                functionName = ['CalcValuesFeaturesType'  int2str(WCType) 'Vector'];
                fh = str2func(functionName);
                FeatValPosVec = fh(Features,WCIndexInType,PosSet);     
                FeatValNegVec = fh(Features,WCIndexInType,NegSet);  

                %Classify them (weighted) in one go
                if (WCPolarity >=0) %                 pos is smaller than thresh
                    PosAccumVec = PosAccumVec + (FeatValPosVec <=  WCThresh)*WCWeight;
                    NegAccumVec = NegAccumVec + (FeatValNegVec <=  WCThresh)*WCWeight;
                else %                 pos is bigger than thresh
                    PosAccumVec = PosAccumVec + (FeatValPosVec >  WCThresh)*WCWeight;
                    NegAccumVec = NegAccumVec + (FeatValNegVec >  WCThresh)*WCWeight;
                end
    end
end

function SC = HandleAdaBoost(Features, Fnum,PosChunksFileNames, NegChunksFileNames,PosSet,NegSet)
    % keep global variables - remain after we leave scope
    global WC;
    global Weights;
    global SumClassifierWeights;
    if (Fnum <= 1)
        WC = struct('feature',{},'featureType',{},'featureIdxInType',{},'threshold',{},'polarity',{},'weight',{});

        % initialize weights
        [nPosExamples] = size(PosSet,3);
        PosWeights =( 1 / (2 * nPosExamples)) * ones(1,nPosExamples);

        [nNegExamples] = size(NegSet,3);
        NegWeights =( 1 / (2 * nNegExamples)) * ones(1,nNegExamples);

        Weights = [PosWeights NegWeights];
        SumClassifierWeights = 0;
    end
    
     [SC,Weights,SumClassifierWeights] = AdaBoost(Features, PosSet,NegSet,Fnum,PosChunksFileNames, NegChunksFileNames, WC, Weights,SumClassifierWeights); 
     WC = SC.WCVec;
end
