function Cas = Cascade(MaxFPRate, MinDRate,  FPTarget, Features, PosSet, NegSet,SCThreshDecRate,DecFeatRate,logLevel,ChunkSizeMB,FeatureValuesPath)

%MaxFPRate - maximum false positive rate per one iteration
%MinDRate - minimum acceptable detection rate per one iteration
%FPTarget - Overall false positive rate selected by user
%Features -  Offline created Viola&Jones  Haar like features. is given as a
%vector of integral image indices. 
%PosSet -  Box of II of Faces
%NegSet -  ""                  of Non-Faces
%SCThreshDecRate - rate of lowering of adaboosted SC threshold, (threshold -
%SCThreshDecRate)
% DecFeatRate - rate of decreasing features, portion to throw away

% User selects values for f  , the maximum acceptable false positive rate per layer and d  , the minimum  acceptable detection rate per layer. 
% 
%       1. User selects target overall false positive rate, Ftarg et 
% 
%       2. P    = set of positive examples 
% 
%       3. N    = set of negative examples 
% 
%       4. F0    =  1.0 ; D0 =  1.0 
% 
%       5. i  =  0 
% 
%       6. while Fi     >  Ftarget 
% 
%             –  i =i +  1 
% 
%             –  ni  =  0 ; Fi  = Fi-1 
% 
%             –  while Fi   >  f  * Fi-1
% 
%                  *ni   =    ni +  1 
% 
%                  *Use P     and N   to train a classifier with ni  features using AdaBoost 
%                  *Evaluate current cascaded classifier on validation set to determine Fi            and Di    .                                    
% 
%                  *Decrease threshold for the ith classifier until the current cascaded classifier has a detection 
%                     rate of at least d *Di-1       (this also affects Fi  ) 
% 
%             –  N   ={}; 
% 
%             –  If Fi  >  Ftarget     then evaluate the current cascaded detector on the set of non-face images and put 
%                         any false dectections into the set N 

%lets assume we have structs of weak classifiers in adaboost.each struct
%contains:
% feature,threshold,polarity,weight
% SC - vecotr of structs + threshold
    InitLog(logLevel,'.\logs\');
    Fcurr = 1.0;
    Fprev = 1.0;
    Dcurr = 1.0;
    Dprev = 1.0;

%     nCascadedClassifiers = 0;

    Features = DecFeatAmount(Features,DecFeatRate);
     [PosChunksFileNames,NegChunksFileNames] = PrepFeatsVals(Features,PosSet,NegSet,ChunkSizeMB,FeatureValuesPath);

    CurrNegSize = size(NegSet,3);
    PosSize = size(PosSet,3);

    SCCtr = 1;

    NegsClassifiedVec = zeros(1, CurrNegSize);
    while Fcurr > FPTarget % stop only after achieving the required false positive rate (much smaller than iteration false postive rate)
%         nCascadedClassifiers = nCascadedClassifiers + 1;
        Fnum = 0;
        Fcurr = Fprev;
        while Fcurr >  MaxFPRate*Fprev % add another feature to adaboost until current false positive rate gets below maximum
            Fnum = Fnum + 1;

            SC(SCCtr) = HandleAdaBoost(Features, Fnum,PosChunksFileNames, NegChunksFileNames,PosSet,NegSet);   

            [PosAccumVec,NegAccumVec] = PrepareWCAccum(SC(SCCtr),Features,PosSet,NegSet);
            [Fcurr,Dcurr] = EvalRate(PosAccumVec,NegAccumVec,SC(SCCtr),PosSize,CurrNegSize);

           while (Dcurr < MinDRate * Dprev)  % lower threshold until current detection positive rate gets above minmimum
               SC(SCCtr).threshold = SC(SCCtr).threshold - SCThreshDecRate;
                [Fcurr,Dcurr] = EvalRate(PosAccumVec,NegAccumVec,SC(SCCtr),PosSize,CurrNegSize);       
           end                   
        end
        
        if (Fcurr > FPTarget)
               [NegsClassifiedVec, NegSet] = RebuildNegSetVals(NegChunksFileNames,NegAccumVec,SC(SCCtr),NegSet); %remove Non-"Faces"  from the set. remove unneeded feature values from that vec!!
        end
        Fprev = Fcurr;
        Dprev = Dcurr;
        SCCtr = SCCtr + 1;
    end
    
    Cas = SC;
    CloseLog();
end

function SC = HandleAdaBoost(Features, Fnum,PosChunksFileNames, NegChunksFileNames,PosSet,NegSet)
    % keep global variables - remain after we leave scope
    global WC;
    global Weights;
    global SumClassifierWeights;
    if (Fnum <= 1)
        WC = struct('feature',{},'featureType',{},'featureIdxInType',{},'threshold',{},'polarity',{},'weight',{});
        
        % initialize weights
        [nPosExamples] = size(PosSet,3);
        PosWeights =( 1 / (2 * nPosExamples)) * ones(1,nPosExamples);

         [nNegExamples] = size(NegSet,3);
        NegWeights =( 1 / (2 * nNegExamples)) * ones(1,nNegExamples);
       

        Weights = [PosWeights NegWeights];
        SumClassifierWeights = 0;
    end
    
     [SC,Weights,SumClassifierWeights] = AdaBoost(Features, PosSet,NegSet,Fnum,PosChunksFileNames, NegChunksFileNames, WC, Weights,SumClassifierWeights); 
     WC = SC.WCVec;
end

function [PosAccumVec,NegAccumVec] = PrepareWCAccum(SC,Features,PosSet,NegSet)
%     WC = struct('feature',{},'featureType',{},'featureOverallIdx',{},'threshold',{},'polarity',{},'weight',{});
%     % SC - vector of WC + ada threshold
%     SC = struct('WCVec',{},'threshold',{});
% 
%     does linear combination of classifiers on all examples (positive &
%     negative) in one go

    PosAccumVec = zeros(1,size(PosSet, 3) );
    NegAccumVec = zeros(1,size(NegSet, 3) );
    for i=1:numel(SC.WCVec)
        % accumulate For Each WC, Weighted classification results in "accumVec"
                %Use Threshold
                WCThresh = SC.WCVec(i).threshold;
                WCType = SC.WCVec(i).featureType;
                WCIndexInType = SC.WCVec(i).featureIdxInType;
                WCWeight = SC.WCVec(i).weight;
                WCPolarity = SC.WCVec(i).polarity;
                
                functionName = ['CalcValuesFeaturesType'  int2str(WCType) 'Vector'];
                fh = str2func(functionName);
                FeatValPosVec = fh(Features,WCIndexInType,PosSet);     
                FeatValNegVec = fh(Features,WCIndexInType,NegSet);  

                %Classify them (weighted) in one go
                if (WCPolarity >=0) %                 pos is smaller than thresh
                    PosAccumVec = PosAccumVec + (FeatValPosVec <=  WCThresh)*WCWeight;
                    NegAccumVec = NegAccumVec + (FeatValNegVec <=  WCThresh)*WCWeight;
                else %                 pos is bigger than thresh
                    PosAccumVec = PosAccumVec + (FeatValPosVec >  WCThresh)*WCWeight;
                    NegAccumVec = NegAccumVec + (FeatValNegVec >  WCThresh)*WCWeight;
                end
    end
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

function  [SCResNegVec, NegSet] = RebuildNegSetVals(NegChunksFileNames,NegAccumVec,SC, NegSet)
% rebuild negset from only the current false positive examples (currect
% examples need to be discarded
    SCResNegVec = NegAccumVec >= SC.threshold;
    
    %delete NegSet ClassifiedExamples
    NegSet(:,:,(SCResNegVec == 0)) = []; %Bug Fixed 29/04
       
    %populate new Neg Set
    for FileIter = 1:size(NegChunksFileNames,2)
        load(NegChunksFileNames{FileIter});     
        ExampleIter = 1;
        ClassificationIter = 1;
        while ExampleIter <= size(partialFeaturesValues,2)
             if(SCResNegVec(ClassificationIter) ==  0) %Bug Fixed 29/04
                    partialFeaturesValues( :,ExampleIter) = [];
             else
                 ExampleIter = ExampleIter + 1;
             end
             ClassificationIter = ClassificationIter + 1;
        end
        save (NegChunksFileNames{FileIter},'partialFeaturesValues', 'FeatRange','FeatType'); 
        clear partialFeaturesValues;
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