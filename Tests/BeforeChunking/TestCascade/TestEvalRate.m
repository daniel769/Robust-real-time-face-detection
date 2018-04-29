function TestEvalRate()
%     PosSize = 100;
%     OrigNegSize = 100;
%     PosAccumVec = ones(1,PosSize);
% 
%     NegAccumVec = zeros(1,OrigNegSize ./ 2);
% 
%     SC = struct('WCVec',{},'threshold',{});
%     SC = [];

%     SC.threshold = 0.5;
    
%     PosSize = 100;
%     OrigNegSize = 100;
%     PosAccumVec = rand(1,PosSize);
% 
%     NegAccumVec = rand(1,OrigNegSize./2);
% 
%     SC = struct('WCVec',{},'threshold',{});
%     SC = [];
% 
%     SC.threshold = 0.5;

    PosSize = 100;
    OrigNegSize = 100;
    PosAccumVec = rand(1,PosSize);

    NegAccumVec = ones(1,OrigNegSize./2);

    SC = struct('WCVec',{},'threshold',{});
    SC = [];

    SC.threshold = 0.5;
    
EvalRate(PosAccumVec,NegAccumVec,SC,PosSize,OrigNegSize);
end

function  [FPcurr,Dcurr] = EvalRate(PosAccumVec,NegAccumVec,SC,PosSize,OrigNegSize)
    %     Evaluate 1.False Positive Rate 2. Detection Rate
    %     apply strong threshold to accumVec -> SCResVec
    %     
    %     false postive rate is calculated as a percentage from all of the neg set, 
    %     in order to accurately calculate over all false postive rate (which is a multiplication of iteration fpRate)
    
    SCResPosVec = PosAccumVec >= SC.threshold;
    SCResNegVec = NegAccumVec >= SC.threshold;
    % calc detection rate,(summate "SCResVec", devide by numofset) same for
    % fP rate
    Dcurr = sum(SCResPosVec)/PosSize;
    FPcurr = sum(SCResNegVec)/OrigNegSize;
end