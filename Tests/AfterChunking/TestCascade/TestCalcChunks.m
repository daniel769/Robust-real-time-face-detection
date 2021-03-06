function TestCalcChunks()

load Features;
fType = 1;
nExamples = 170;
Set = zeros(20,20,nExamples);
    ChunkSizeMB = 10;
 [nChunks, nFeatInChunk]= CalcChunks(Features,fType,Set,ChunkSizeMB)
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