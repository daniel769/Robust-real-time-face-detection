function  [PosChunksFileNames, NegChunksFileNames] = PrepFeatsVals(Features,PosSet,NegSet,ChunkSizeMB,FeatureValuesPath)
    TempPosPath =[FeatureValuesPath '\Pos'];
    mkdir(TempPosPath);
    TempNegPath =[FeatureValuesPath '\Neg'];
    mkdir(TempNegPath);
    PosChunksFileNames = [];
    NegChunksFileNames = [];
    for FeatType=1:4       
        [nChunks, nFeatInChunk] = CalcChunks(Features,FeatType,NegSet,ChunkSizeMB); % assumption NegSet is Bigger than Pos Set
        TempNegChunksFileNames =  PrepareChunksPerSet(Features,FeatType,NegSet,nChunks,nFeatInChunk,TempNegPath);   
        NegChunksFileNames = [NegChunksFileNames  TempNegChunksFileNames];
        TempPosChunksFileNames = PrepareChunksPerSet(Features,FeatType,PosSet,nChunks,nFeatInChunk,TempPosPath);
        PosChunksFileNames = [PosChunksFileNames TempPosChunksFileNames];
        
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

