function TestRebuildNegSetVals
%     NegSize = 100;
%        Path1 = 'C:\M.Sc\CV\matlab\Data\tempTest\partialFeatureValuesType1Chunk01.mat';
%     Path2 = 'C:\M.Sc\CV\matlab\Data\tempTest\partialFeatureValuesType1Chunk02.mat';
% 
%     NegChunksFileNames = cell(1, 2);
%     NegChunksFileNames{1} = Path2;
%     NegChunksFileNames{2} = Path1;
%    
%     NegAccumVec = ones(1,NegSize);
% 
%     SC = struct('WCVec',{},'threshold',{});
%     SC = [];
% 
%     SC.threshold = 0.5;
    

%    NegSize = 100;
%        Path1 = 'C:\M.Sc\CV\matlab\Data\tempTest\partialFeatureValuesType1Chunk01.mat';
%     Path2 = 'C:\M.Sc\CV\matlab\Data\tempTest\partialFeatureValuesType1Chunk02.mat';
% 
%     NegChunksFileNames = cell(1, 2);
%     NegChunksFileNames{1} = Path2;
%     NegChunksFileNames{2} = Path1;
%     NegAccumVec = rand(1,NegSize);
% 
%     SC = struct('WCVec',{},'threshold',{});
%     SC = [];
% 
%     SC.threshold = 0.5;

    
   NegSize = 100;
   
       Path1 = 'C:\M.Sc\CV\matlab\Data\tempTest\partialFeatureValuesType1Chunk01.mat';
    Path2 = 'C:\M.Sc\CV\matlab\Data\tempTest\partialFeatureValuesType1Chunk02.mat';

    NegChunksFileNames = cell(1, 2);
    NegChunksFileNames{1} = Path2;
    NegChunksFileNames{2} = Path1;
   
   
    NegAccumVec = zeros(1,NegSize);

    SC = struct('WCVec',{},'threshold',{});
    SC = [];

    SC.threshold = 0.5;
    
     RebuildNegSetVals(NegChunksFileNames,NegAccumVec,SC);
end

function  RebuildNegSetVals(NegChunksFileNames,NegAccumVec,SC)
% rebuild negset from only the current false positive examples (currect
% examples need to be discarded
    SCResNegVec = NegAccumVec >= SC.threshold;    
    %populate new Neg Set
    for FileIter = 1:size(NegChunksFileNames,2)
        load(NegChunksFileNames{FileIter});     
        ExampleIter = 1;
        ClassificationIter = 1;
        while ExampleIter <= size(partialFeaturesValues,2)
             if(SCResNegVec(ClassificationIter) ==  1)
                    partialFeaturesValues( :,ExampleIter) = [];
             else
                 ExampleIter = ExampleIter + 1;
             end
             ClassificationIter = ClassificationIter + 1;
        end
        save (NegChunksFileNames{FileIter},'partialFeaturesValues', 'FeatRange','FeatType'); 
    end
end