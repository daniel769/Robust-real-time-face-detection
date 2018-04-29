function TestCascadeStep

load Features;
nExamples = 10;
set = zeros(20,20,nExamples);
set(2:20,2:20,:) = round(rand(19,19,nExamples)*10);
set = cumsum(set,1);
set = cumsum(set,2);

load SC;
SC = Cas;
    
    FacesWinIdx = ones(4,10);
    FacesWinIdx = cumsum(FacesWinIdx,2);
    
    FacesWinIdxStep = CascadeStep(set,SC,FacesWinIdx);

end

function FacesWinIdxStep = CascadeStep(Box,SC,SlideWinIdx)
    FacesLeft = true;
    Counter = 1;
    FacesWinIdx = SlideWinIdx;
    while FacesLeft
        if Counter <= numel(SC)
             [Box,FacesWinIdx] = ApplySC(Box,SC(Counter),FacesWinIdx);
            Counter = Counter + 1;
            if numel(Box) == 0
                FacesLeft = false;
            end
        else
            break; % no more SC left
        end
    end
    FacesWinIdxStep = FacesWinIdx;
end

function [Box,FacesWinIdx] =  ApplySC(Box,SC,FacesWinIdx)
    WeightedClassifiedValues = zeros(1,size(Box,3));
    % iterate on features
     for i = 1:numel(SC.WCVec)
         feature = SC.WCVec(i).feature;
         if SC.WCVec(i).featureType == 1
                 FeatureValues = CalcValuesFeaturesType1(feature,Box);
         else if SC.WCVec(i).featureType == 2
                 FeatureValues = CalcValuesFeaturesType2(feature,Box);
         else if SC.WCVec(i).featureType == 3
                 FeatureValues = CalcValuesFeaturesType3(feature,Box);
         else if SC.WCVec(i).featureType == 4
                 FeatureValues = CalcValuesFeaturesType4(feature,Box);
         end
         end
         end
         end
         % apply threshold, multiply by weights
         if SC.WCVec(i).polarity < 0
             weakclassifiedValues = FeatureValues > SC.WCVec(i).threshold;
         else
             weakclassifiedValues = FeatureValues <= SC.WCVec(i).threshold;
         end 
         %  insert into adaboost summer
         WeightedClassifiedValues = WeightedClassifiedValues +  (SC.WCVec(i).weight * weakclassifiedValues);         
     end
    % classify
    classifiedValues = WeightedClassifiedValues > SC.threshold;
    % shrink Box and Indices
    nonFacesIdx = find(classifiedValues == 0);
    Box(:,:,nonFacesIdx) = [];
    FacesWinIdx(:,nonFacesIdx) = [];
end

function value = CalcValuesFeaturesType1(feature,Box)
    %subtract rectangle below from rectangle above
    rectangleAboveSum = FetchIIValue(feature(4),Box) -...
                                                    FetchIIValue(feature(3),Box)-...
                                                    FetchIIValue(feature(2),Box)+...
                                                    FetchIIValue(feature(1),Box);

    rectangleBelowSum = FetchIIValue(feature(6),Box) -...
                                                   FetchIIValue(feature(4),Box)-...
                                                   FetchIIValue(feature(5),Box)+...
                                                   FetchIIValue(feature(3),Box);
    value = rectangleAboveSum - rectangleBelowSum;
end

function value = CalcValuesFeaturesType2(feature,Box)
    %subtract left rectangle  from right rectangle 
    rightRectangleSum =  FetchIIValue(feature(6),Box ) - ...
                                                        FetchIIValue(feature(5),Box) - ...
                                                        FetchIIValue(feature(3),Box) + ...
                                                        FetchIIValue(feature(2),Box);
    leftRectangleSum =  FetchIIValue(feature(5),Box) - ...
                                                        FetchIIValue(feature(2),Box) - ...
                                                        FetchIIValue(feature(4),Box) + ...
                                                        FetchIIValue(feature(1),Box);
    value = rightRectangleSum - leftRectangleSum;
end

function value = CalcValuesFeaturesType3(feature,Box)
   %subtract left rectangle  and right rectangle from center rectangle
    rightRectangleSum =  FetchIIValue(feature(8),Box ) - ...
                                                        FetchIIValue(feature(4),Box) - ...
                                                        FetchIIValue(feature(7),Box) + ...
                                                        FetchIIValue(feature(3),Box);
    leftRectangleSum =  FetchIIValue(feature(6),Box) - ...
                                                        FetchIIValue(feature(5),Box) - ...
                                                        FetchIIValue(feature(2),Box) + ...
                                                        FetchIIValue(feature(1),Box);
    centerRectangleSum =  FetchIIValue(feature(7),Box) - ...
                                                        FetchIIValue(feature(6),Box) - ...
                                                        FetchIIValue(feature(3),Box) + ...
                                                        FetchIIValue(feature(2),Box);
    value = centerRectangleSum - rightRectangleSum - leftRectangleSum;
end

function value = CalcValuesFeaturesType4(feature,Box)
%subtract upper left rectangle  and lower right rectangle from lower
    %left rectangle  and upper right rectangle
    upperRightRectangleSum =  FetchIIValue(feature(6),Box ) - ...
                                                        FetchIIValue(feature(5),Box) - ...
                                                        FetchIIValue(feature(3),Box) + ...
                                                        FetchIIValue(feature(2),Box);
    upperLeftRectangleSum =  FetchIIValue(feature(5),Box) - ...
                                                        FetchIIValue(feature(4),Box) - ...
                                                        FetchIIValue(feature(2),Box) + ...
                                                        FetchIIValue(feature(1),Box);
    lowerRightRectangleSum =  FetchIIValue(feature(9),Box ) - ...
                                                        FetchIIValue(feature(6),Box) - ...
                                                        FetchIIValue(feature(8),Box) + ...
                                                        FetchIIValue(feature(5),Box);
    lowerLeftRectangleSum =  FetchIIValue(feature(8),Box) - ...
                                                        FetchIIValue(feature(5),Box) - ...
                                                        FetchIIValue(feature(7),Box) + ...
                                                        FetchIIValue(feature(4),Box);
    value = lowerLeftRectangleSum + upperRightRectangleSum - lowerRightRectangleSum - upperLeftRectangleSum;
end