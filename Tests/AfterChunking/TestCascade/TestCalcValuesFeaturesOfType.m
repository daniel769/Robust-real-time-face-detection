function TestCalcValuesFeaturesOfType()
load Features;
nExamples = 1;
Set = zeros(20,20,nExamples);
FeatType = 1;

nFeatInChunk = 100;
LastFeature = 17001;
    CalcValuesFeaturesOfType(Features,FeatType,Set,nFeatInChunk,LastFeature);

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

function [FeatureType1ChunkValue] = CalcValuesFeaturesType1Vector(Features,j,Set)
%subtract rectangle below from rectangle above
    rectangleAboveSum =  FetchIIValue(Features{1}(4,j),Set ) - ...
                                                        FetchIIValue(Features{1}(3,j),Set) - ...
                                                        FetchIIValue(Features{1}(2,j),Set) + ...
                                                        FetchIIValue(Features{1}(1,j),Set);
    rectangleBelowSum =  FetchIIValue(Features{1}(6,j),Set) - ...
                                                        FetchIIValue(Features{1}(4,j),Set) - ...
                                                        FetchIIValue(Features{1}(5,j),Set) + ...
                                                        FetchIIValue(Features{1}(3,j),Set);
     FeatureType1ChunkValue = rectangleAboveSum - rectangleBelowSum;
end