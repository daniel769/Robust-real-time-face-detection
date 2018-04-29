function TestCalcValuesFeaturesVector
clear;
load Features;
DecFeatures = DecFeatAmount(Features,0);
nExamples = 10;
set = zeros(20,20,nExamples);
set(2:20,11:20,:) = ones(19,10,nExamples);
set = cumsum(set,1);
    set = cumsum(set,2);
%      FeatureType1Values = CalcValuesFeaturesType1Vector(DecFeatures,set);
     FeatureType2Values = CalcValuesFeaturesType2Vector(DecFeatures,set);
     FeatureType3Values = CalcValuesFeaturesType3Vector(DecFeatures,set);
     FeatureType4Values = CalcValuesFeaturesType4Vector(DecFeatures,set);
end

function FeatureType1Values = CalcValuesFeaturesType1Vector(Features,Set)
    nFeaturesType1 = size(Features{1},2);
    nExamples = size(Set,3);
    FeatureType1Values =zeros(nFeaturesType1,nExamples);
    for j = 1:nFeaturesType1
        %subtract rectangle below from rectangle above
        rectangleAboveSum =  FetchIIValue(Features{1}(4,j),Set ) - ...
                                                            FetchIIValue(Features{1}(3,j),Set) - ...
                                                            FetchIIValue(Features{1}(2,j),Set) + ...
                                                            FetchIIValue(Features{1}(1,j),Set);
        rectangleBelowSum =  FetchIIValue(Features{1}(6,j),Set) - ...
                                                            FetchIIValue(Features{1}(4,j),Set) - ...
                                                            FetchIIValue(Features{1}(5,j),Set) + ...
                                                            FetchIIValue(Features{1}(3,j),Set);
        FeatureType1Values(j,:) = rectangleAboveSum - rectangleBelowSum;
    end
end

function FeatureType2Values = CalcValuesFeaturesType2Vector(Features,Set)
    nFeaturesType2 = size(Features{2},2);
    nExamples = size(Set,3);
    FeatureType2Values =zeros(nFeaturesType2,nExamples);
    for j = 1:nFeaturesType2
    %subtract left rectangle  from right rectangle 
    rightRectangleSum =  FetchIIValue(Features{2}(6,j),Set ) - ...
                                                        FetchIIValue(Features{2}(5,j),Set) - ...
                                                        FetchIIValue(Features{2}(3,j),Set) + ...
                                                        FetchIIValue(Features{2}(2,j),Set);
    leftRectangleSum =  FetchIIValue(Features{2}(5,j),Set) - ...
                                                        FetchIIValue(Features{2}(2,j),Set) - ...
                                                        FetchIIValue(Features{2}(4,j),Set) + ...
                                                        FetchIIValue(Features{2}(1,j),Set);
    FeatureType2Values(j,:) = rightRectangleSum - leftRectangleSum;
    end
end

function FeatureType3Values = CalcValuesFeaturesType3Vector(Features,Set)
    nFeaturesType3 = size(Features{3},2);
    nExamples = size(Set,3);
    FeatureType3Values =zeros(nFeaturesType3,nExamples);
    for j = 1:nFeaturesType3
    %subtract left rectangle  and right rectangle from center rectangle
    rightRectangleSum =  FetchIIValue(Features{3}(8,j),Set ) - ...
                                                        FetchIIValue(Features{3}(4,j),Set) - ...
                                                        FetchIIValue(Features{3}(7,j),Set) + ...
                                                        FetchIIValue(Features{3}(3,j),Set);
    leftRectangleSum =  FetchIIValue(Features{3}(6,j),Set) - ...
                                                        FetchIIValue(Features{3}(5,j),Set) - ...
                                                        FetchIIValue(Features{3}(2,j),Set) + ...
                                                        FetchIIValue(Features{3}(1,j),Set);
    centerRectangleSum =  FetchIIValue(Features{3}(7,j),Set) - ...
                                                        FetchIIValue(Features{3}(6,j),Set) - ...
                                                        FetchIIValue(Features{3}(3,j),Set) + ...
                                                        FetchIIValue(Features{3}(2,j),Set);
    FeatureType3Values(j,:) = centerRectangleSum - rightRectangleSum - leftRectangleSum;
    end
end

function FeatureType4Values = CalcValuesFeaturesType4Vector(Features,Set)
    nFeaturesType4 = size(Features{4},2);
    nExamples = size(Set,3);
    FeatureType4Values =zeros(nFeaturesType4,nExamples);
    for j = 1:nFeaturesType4
    %subtract upper left rectangle  and lower right rectangle from lower
    %left rectangle  and upper right rectangle
    upperRightRectangleSum =  FetchIIValue(Features{4}(6,j),Set ) - ...
                                                        FetchIIValue(Features{4}(5,j),Set) - ...
                                                        FetchIIValue(Features{4}(3,j),Set) + ...
                                                        FetchIIValue(Features{4}(2,j),Set);
    upperLeftRectangleSum =  FetchIIValue(Features{4}(5,j),Set) - ...
                                                        FetchIIValue(Features{4}(4,j),Set) - ...
                                                        FetchIIValue(Features{4}(2,j),Set) + ...
                                                        FetchIIValue(Features{4}(1,j),Set);
    lowerRightRectangleSum =  FetchIIValue(Features{4}(9,j),Set ) - ...
                                                        FetchIIValue(Features{4}(6,j),Set) - ...
                                                        FetchIIValue(Features{4}(8,j),Set) + ...
                                                        FetchIIValue(Features{4}(5,j),Set);
    lowerLeftRectangleSum =  FetchIIValue(Features{4}(8,j),Set) - ...
                                                        FetchIIValue(Features{4}(5,j),Set) - ...
                                                        FetchIIValue(Features{4}(7,j),Set) + ...
                                                        FetchIIValue(Features{4}(4,j),Set);
    FeatureType4Values(j,:) = lowerLeftRectangleSum + upperRightRectangleSum - lowerRightRectangleSum - upperLeftRectangleSum;
    end
end


function DecFeatures = DecFeatAmount(Features,DecRate)
% DecRate - percentage to remove from features
    for i = 1:4
        FeaturesSize = size(Features{i},2);
        randIndices = randperm(FeaturesSize);
        DecIndicesAmount = round(FeaturesSize * DecRate);
        FeaturesOfType = Features{i};
        Features{i} = FeaturesOfType(:,randIndices(DecIndicesAmount + 1 :end));
    end 
    DecFeatures = Features;
end