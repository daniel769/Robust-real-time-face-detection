function TestRebuildNegSetVals
%     NegSize = 50;
%     NegFeatureValues = round(rand(400,NegSize)*10);
%     NegAccumVec = ones(1,NegSize);
% 
%     SC = struct('WCVec',{},'threshold',{});
%     SC = [];
% 
%     SC.threshold = 0.5;

%    NegSize = 50;
%     NegFeatureValues = round(rand(400,NegSize)*10);
%     NegAccumVec = rand(1,NegSize);
% 
%     SC = struct('WCVec',{},'threshold',{});
%     SC = [];
% 
%     SC.threshold = 0.5;

%    NegSize = 50;
%     NegFeatureValues = round(rand(400,NegSize)*10);
%     NegAccumVec = zeros(1,NegSize);
% 
%     SC = struct('WCVec',{},'threshold',{});
%     SC = [];
% 
%     SC.threshold = 0.5;

   NegSize = 90;
    NegFeatureValues = round(rand(400,NegSize)*10);
    NegAccumVec = [zeros(1,NegSize/3) ones(1,2*NegSize/3)] ;
    

    SC = struct('WCVec',{},'threshold',{});
    SC = [];

    SC.threshold = 0.5;
    
     [NewNegFeatureValues] = RebuildNegSetVals(NegFeatureValues,NegAccumVec,SC);
end

function [NewNegFeatureValues] = RebuildNegSetVals(NegFeatureValues,NegAccumVec,SC)
% rebuild negset from only the current false positive examples (currect
% examples need to be discarded
    SCResNegVec = NegAccumVec >= SC.threshold;
    FPcurrSize = sum(SCResNegVec);
    NewNegFeatureValues = zeros(size(NegFeatureValues,1),FPcurrSize);
    j = 1;
    %populate new Neg Set
    for i = 1:size(NegFeatureValues,2)
        if(SCResNegVec(i) ==  1)
            NewNegFeatureValues(:,j) = NegFeatureValues(:,i);
            j = j+1;
        end
    end
end