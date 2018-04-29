function TestPrepareChunksPerSet()
% load Features;
% nExamples = 100;
% PosSet = zeros(20,20,nExamples);
% FeatType = 1;
% ChunkSizeMB = 1;
% Path = 'C:\M.Sc\CV\matlab\Data\tempTest';
%   PosChunksFileNames = [];

load Features;
nExamples = 100;
PosSet = round(rand(20,20,nExamples)*100) + 1;
FeatType = 1;
ChunkSizeMB = 1;
Path = 'C:\M.Sc\CV\matlab\Data\tempTest';
  PosChunksFileNames = [];
  
        mkdir(Path);
        [nChunks, nFeatInChunk] = CalcChunks(Features,FeatType,PosSet,ChunkSizeMB);
        
        
         TempPosChunksFileNames = PrepareChunksPerSet(Features,FeatType,PosSet,nChunks,nFeatInChunk,Path);
        PosChunksFileNames = [PosChunksFileNames TempPosChunksFileNames];
        
        FeatType = 2;
         TempPosChunksFileNames = PrepareChunksPerSet(Features,FeatType,PosSet,nChunks,nFeatInChunk,Path);
        PosChunksFileNames = [PosChunksFileNames TempPosChunksFileNames];
end

function [nChunks, nFeatInChunk] = CalcChunks(Features,fType,Set,ChunkSizeMB)
     MB = 2^20;
     maxMemSize = ChunkSizeMB * MB;
    nFeatures = size(Features{fType},2);
    SetSize = size(Set,3);
    OverAllSize = nFeatures * SetSize * 4;
    nChunks = ceil(OverAllSize / maxMemSize);
    if (nChunks > 1)
        nFeatInChunk = floor(maxMemSize / (SetSize * 4));
    else
        nFeatInChunk = nFeatures;
    end
end

function  [ChunksFileNames]  = PrepareChunksPerSet(Features,FeatType,Set,nChunks,nFeatInChunk,Path)
     ChunksFileNames = cell(1, nChunks);
     nFeatures = size(Features{FeatType},2);
     RemainingFeatures = nFeatures;
     LastIdx = 1;
     for j = 1:nChunks
         [partialFeaturesValues,LastIdx] = CalcValuesFeaturesOfType(Features,FeatType,Set,nFeatInChunk,LastIdx);
         FirstIdx = LastIdx-nFeatInChunk;
         FeatRange = [FirstIdx LastIdx-1];
         ChunksFileNames{j}= sprintf('%s\\partialFeatureValuesType%dChunk%.2d.mat',Path,FeatType,j);
         save (ChunksFileNames{j},'partialFeaturesValues', 'FeatRange','FeatType');       
         clear('partialFeaturesValues');
         RemainingFeatures = RemainingFeatures - nFeatInChunk;
         if RemainingFeatures < nFeatInChunk
            nFeatInChunk = RemainingFeatures;
        end
     end
end

function [FeatureOfTypeChunkValues,nextIdx] = CalcValuesFeaturesOfType(Features,FeatType,Set,nFeatInChunk,LastFeature)
    FeatureIdx = 1;
    j = LastFeature;
    nFeaturesOfType= size(Features{FeatType},2);
    nExamples = size(Set,3);
    FeatureOfTypeChunkValues =zeros(nFeatInChunk,nExamples);
    
    functionName = ['CalcValuesFeaturesType'  int2str(FeatType) 'Vector'];
    fh = str2func(functionName);
    
    while j<=nFeaturesOfType && FeatureIdx <= nFeatInChunk
        FeatureOfTypeChunkValues(FeatureIdx,:) = fh(Features,j,Set);      
        j = j + 1;
        FeatureIdx = FeatureIdx + 1;
    end  
    nextIdx = j;
end

function [FeatureType1Value] = CalcValuesFeaturesType1Vector(Features,j,Set)
%subtract rectangle below from rectangle above
    rectangleAboveSum =  FetchIIValue(Features{1}(4,j),Set ) - ...
                                                        FetchIIValue(Features{1}(3,j),Set) - ...
                                                        FetchIIValue(Features{1}(2,j),Set) + ...
                                                        FetchIIValue(Features{1}(1,j),Set);
    rectangleBelowSum =  FetchIIValue(Features{1}(6,j),Set) - ...
                                                        FetchIIValue(Features{1}(4,j),Set) - ...
                                                        FetchIIValue(Features{1}(5,j),Set) + ...
                                                        FetchIIValue(Features{1}(3,j),Set);
     FeatureType1Value = rectangleAboveSum - rectangleBelowSum;
end

function FeatureType2Value = CalcValuesFeaturesType2Vector(Features,j,Set)
    %subtract left rectangle  from right rectangle 
    rightRectangleSum =  FetchIIValue(Features{2}(6,j),Set ) - ...
                                                        FetchIIValue(Features{2}(5,j),Set) - ...
                                                        FetchIIValue(Features{2}(3,j),Set) + ...
                                                        FetchIIValue(Features{2}(2,j),Set);
    leftRectangleSum =  FetchIIValue(Features{2}(5,j),Set) - ...
                                                        FetchIIValue(Features{2}(2,j),Set) - ...
                                                        FetchIIValue(Features{2}(4,j),Set) + ...
                                                        FetchIIValue(Features{2}(1,j),Set);
    FeatureType2Value = rightRectangleSum - leftRectangleSum;
end