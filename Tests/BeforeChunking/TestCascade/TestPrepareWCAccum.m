function TestPrepareWCAccum()
% PosFeatureValues = round(rand(400,50)*10);
% NegFeatureValues = round(rand(400,50)*10);
% PosFeatureValues(22,:) = round(rand(1,50)*10+ 10) ;
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
%     WC.threshold = 9;
%     WC.polarity = -1;
%     WC.weight = classifierWeight;
%     
%     SC.WCVec = WC;
%     SC.threshold = WC.weight./2;
    
    PosFeatureValues = round(rand(400,50)*10);
NegFeatureValues = round(rand(400,50)*10);
PosFeatureValues(22,:) = round(rand(1,50)*10+ 20) ;

WC = struct('feature',{},'featureType',{},'featureOverallIdx',{},'threshold',{},'polarity',{},'weight',{});
WC = [];
    % SC - vector of WC + ada threshold
    SC = struct('WCVec',{},'threshold',{});
    SC = [];
    error = 1/8;
    Beta = error / (1 - error);
    classifierWeight = log(1/Beta);
    
    WC.feature = PosFeatureValues(22,:);
    WC.featureType = 1;
    WC.featureOverallIdx = 22;
    WC.threshold = 11;
    WC.polarity = -1;
    WC.weight = classifierWeight;
    
    SC.WCVec = WC;
    SC.threshold = WC.weight./2;

[PosAccumVec,NegAccumVec] = PrepareWCAccum(SC,PosFeatureValues,NegFeatureValues)
end

function [PosAccumVec,NegAccumVec] = PrepareWCAccum(SC,PosFeatureValues,NegFeatureValues)
%     WC = struct('feature',{},'featureType',{},'featureOverallIdx',{},'threshold',{},'polarity',{},'weight',{});
%     % SC - vector of WC + ada threshold
%     SC = struct('WCVec',{},'threshold',{});
% 
%     does linear combination of classifiers on all examples (positive &
%     negative) in one go

    E=0;
    PosAccumVec = zeros(1,size(PosFeatureValues, 2) );
    NegAccumVec = zeros(1,size(NegFeatureValues, 2) );
    for i=1:numel(SC.WCVec)
        % accumulate For Each WC, Weighted classification results in "accumVec"
                %Use Threshold
                WCThresh = SC.WCVec(i).threshold;
                WCIndex = SC.WCVec(i).featureOverallIdx;
                WCWeight = SC.WCVec(i).weight;
                WCPolarity = SC.WCVec(i).polarity;

                %Classify them (weighted) in one go
                if (WCPolarity >=0) %                 pos is smaller than thresh
                    PosAccumVec = PosAccumVec + (PosFeatureValues(WCIndex, :) <=  WCThresh)*WCWeight;
                    NegAccumVec = NegAccumVec + (NegFeatureValues(WCIndex, :) <=  WCThresh)*WCWeight;
                else %                 pos is bigger than thresh
                    PosAccumVec = PosAccumVec + (PosFeatureValues(WCIndex, :) >  WCThresh)*WCWeight;
                    NegAccumVec = NegAccumVec + (NegFeatureValues(WCIndex, :) >  WCThresh)*WCWeight;
                end
    end
end