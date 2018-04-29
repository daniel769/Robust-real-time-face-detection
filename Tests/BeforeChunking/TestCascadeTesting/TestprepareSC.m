function TestprepareSC()
PosFeatureValues = round(rand(400,50)*10);
NegFeatureValues = round(rand(400,50)*10);
PosFeatureValues(22,:) = round(rand(1,50)*10+ 10) ;

WC = struct('feature',{},'featureType',{},'featureOverallIdx',{},'threshold',{},'polarity',{},'weight',{});
WC = [];
    % SC - vector of WC + ada threshold
    SC = struct('WCVec',{},'threshold',{});
    SC = [];
    error = 1/8;
    Beta = error / (1 - error);
    classifierWeight = log(1/Beta);
    
%     1,5  7,2  14,12  19,3  10,18  5,14
x=[1;7;14;19;10;5];
y=[5;2;12;3;18;14];
WC.feature = sub2ind([19 19],x,y);
    WC.featureType = 1;
    WC.featureOverallIdx = 22;
    WC.threshold = 9;
    WC.polarity = -1;
    WC.weight = classifierWeight;
    
    SC.WCVec = WC;
    SC.threshold = WC.weight./2;
    
    prepareSC(SC,1.25,19,19);
end

function SC = prepareSC(SC,EnlargeFactor,SizeX,SizeY)
%Enlarges all the features and their threshold
    NewSizeX = round(SizeX .* EnlargeFactor) + 1;
     NewSizeY = round(SizeY .* EnlargeFactor) + 1;
    for i = 1:numel(SC)
        for j = 1:numel(SC(i).WCVec)
             [x y] = ind2sub([SizeX + 1 SizeY + 1],SC(i).WCVec(j).feature);
             x = round((x - 1) .* EnlargeFactor) + 1;
             y = round((y - 1) .* EnlargeFactor) + 1;           
             SC(i).WCVec(j).feature = sub2ind([NewSizeX NewSizeY],x,y);
%             SC(i).WCVec(j).feature = round(SC(i).WCVec(j).feature .* EnlargeFactor);
            SC(i).WCVec(j).threshold = round(SC(i).WCVec(j).threshold .* EnlargeFactor .* EnlargeFactor);
        end
    end
end