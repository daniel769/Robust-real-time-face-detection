function TestAdaBoost()
load Features;

nExamples = 100;

PosSet = round(rand(20,20,nExamples)*100) + 1;
NegSet = round(rand(20,20,nExamples)*100) + 1;

WC = [];

Weights = round(rand(1,200)*100);
    Weights = Weights./sum(Weights);
    
    SumClassifierWeights = 0;

    Path1 = 'C:\M.Sc\CV\matlab\Data\tempTest\partialFeatureValuesType1Chunk01.mat';
    Path2 = 'C:\M.Sc\CV\matlab\Data\tempTest\partialFeatureValuesType1Chunk02.mat';

    PosChunksFileNames = cell(1, 2);
    PosChunksFileNames{1} = Path2;
    PosChunksFileNames{2} = Path1;
    NegChunksFileNames = cell(1, 2);
    NegChunksFileNames{1} = Path2;
    NegChunksFileNames{2} = Path1;
    
FeatNum = 1;


% Features{1} = round(rand(6,100)*20 + 1);
% Features{1}(:,22) = [1; 2; 3; 4; 5; 6];
% Features{2} = round(rand(6,100)*20 + 1);
% Features{2}(:,22) = [10; 20; 30; 40; 50; 60];
% Features{3} = round(rand(8,100)*20 + 1);
% Features{3}(:,22) = [100; 200; 300; 400; 500; 600; 700; 800];
% Features{4} = round(rand(9,100)*20 + 1);
% Features{4}(:,22) =[100; 200; 300; 400; 500; 600; 700; 800; 900];
% 
% PosFeatureValues = round(rand(400,50)*10);
% NegFeatureValues = round(rand(400,50)*10);
% PosFeatureValues(22,:) = round(rand(1,50)*10+ 20) ;
% 
% nFeatures = 1;

% Features{1} = round(rand(6,100)*20 + 1);
% Features{1}(:,22) = [1; 2; 3; 4; 5; 6];
% Features{2} = round(rand(6,100)*20 + 1);
% Features{2}(:,22) = [10; 20; 30; 40; 50; 60];
% Features{3} = round(rand(8,100)*20 + 1);
% Features{3}(:,22) = [100; 200; 300; 400; 500; 600; 700; 800];
% Features{4} = round(rand(9,100)*20 + 1);
% Features{4}(:,22) =[100; 200; 300; 400; 500; 600; 700; 800; 900];
% 
% PosFeatureValues = round(rand(400,50)*10);
% NegFeatureValues = round(rand(400,50)*10);
% 
% nFeatures = 2;

[SC,Weights,SumClassifierWeights]  =   AdaBoost(Features, PosSet,NegSet,FeatNum,PosChunksFileNames, NegChunksFileNames, WC, Weights,SumClassifierWeights)
%  check wc weights
end