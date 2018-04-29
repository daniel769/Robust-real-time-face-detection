function TestDecFeatAmount

    Features{1} = round(rand(6,100)*20 + 1);
    Features{1}(:,22) = [1; 2; 3; 4; 5; 6];
    Features{2} = round(rand(6,100)*20 + 1);
    Features{2}(:,22) = [10; 20; 30; 40; 50; 60];
    Features{3} = round(rand(8,100)*20 + 1);
    Features{3}(:,22) = [100; 200; 300; 400; 500; 600; 700; 800];
    Features{4} = round(rand(9,100)*20 + 1);
    Features{4}(:,22) =[100; 200; 300; 400; 500; 600; 700; 800; 900];

    DecRate = 0.25;
    
    DecFeatures = DecFeatAmount(Features,DecRate);
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