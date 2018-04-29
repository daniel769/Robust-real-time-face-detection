function TestHandleAdaBoost
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
