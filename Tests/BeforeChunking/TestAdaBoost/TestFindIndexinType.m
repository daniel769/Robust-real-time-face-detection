function [] = TestFindIndexinType
% Features{1} = round(rand(6,100)*20 + 1);
% Features{1}(:,22) = [1; 2; 3; 4; 5; 6];
% Features{2} = round(rand(6,100)*20 + 1);
% Features{2}(:,22) = [10; 20; 30; 40; 50; 60];
% Features{3} = round(rand(8,100)*20 + 1);
% Features{3}(:,22) = [100; 200; 300; 400; 500; 600; 700; 800];
% Features{4} = round(rand(9,100)*20 + 1);
% Features{4}(:,22) =[100; 200; 300; 400; 500; 600; 700; 800; 900];
% 
%  [FeatureType, BestFeatureIndexInType] = FindIndexinType(22,Features);
%  disp(Features{FeatureType}(:,BestFeatureIndexInType));
%  [FeatureType, BestFeatureIndexInType] = FindIndexinType(122,Features);
%   disp(Features{FeatureType}(:,BestFeatureIndexInType));
%  [FeatureType, BestFeatureIndexInType] = FindIndexinType(222,Features);
%   disp(Features{FeatureType}(:,BestFeatureIndexInType));
%  [FeatureType, BestFeatureIndexInType] = FindIndexinType(322,Features);
%   disp(Features{FeatureType}(:,BestFeatureIndexInType));
  
%   Features{1} = round(rand(6,100)*20 + 1);
% Features{1}(:,100) = [1; 2; 3; 4; 5; 6];
% Features{2} = round(rand(6,100)*20 + 1);
% Features{2}(:,100) = [10; 20; 30; 40; 50; 60];
% Features{3} = round(rand(8,100)*20 + 1);
% Features{3}(:,100) = [100; 200; 300; 400; 500; 600; 700; 800];
% Features{4} = round(rand(9,100)*20 + 1);
% Features{4}(:,100) =[100; 200; 300; 400; 500; 600; 700; 800; 900];
% 
%  [FeatureType, BestFeatureIndexInType] = FindIndexinType(100,Features);
%  disp(Features{FeatureType}(:,BestFeatureIndexInType));
%  [FeatureType, BestFeatureIndexInType] = FindIndexinType(200,Features);
%   disp(Features{FeatureType}(:,BestFeatureIndexInType));
%  [FeatureType, BestFeatureIndexInType] = FindIndexinType(300,Features);
%   disp(Features{FeatureType}(:,BestFeatureIndexInType));
%  [FeatureType, BestFeatureIndexInType] = FindIndexinType(400,Features);
%   disp(Features{FeatureType}(:,BestFeatureIndexInType));

% Features{1} = round(rand(6,100)*20 + 1);
% Features{1}(:,1) = [1; 2; 3; 4; 5; 6];
% Features{2} = round(rand(6,100)*20 + 1);
% Features{2}(:,1) = [10; 20; 30; 40; 50; 60];
% Features{3} = round(rand(8,100)*20 + 1);
% Features{3}(:,1) = [100; 200; 300; 400; 500; 600; 700; 800];
% Features{4} = round(rand(9,100)*20 + 1);
% Features{4}(:,1) =[100; 200; 300; 400; 500; 600; 700; 800; 900];
% 
%  [FeatureType, BestFeatureIndexInType] = FindIndexinType(1,Features);
%  disp(Features{FeatureType}(:,BestFeatureIndexInType));
%  [FeatureType, BestFeatureIndexInType] = FindIndexinType(101,Features);
%   disp(Features{FeatureType}(:,BestFeatureIndexInType));
%  [FeatureType, BestFeatureIndexInType] = FindIndexinType(201,Features);
%   disp(Features{FeatureType}(:,BestFeatureIndexInType));
%  [FeatureType, BestFeatureIndexInType] = FindIndexinType(301,Features);
%   disp(Features{FeatureType}(:,BestFeatureIndexInType));
end

function  [FeatureType, BestFeatureIndexInType] = FindIndexinType(Idx, Features) 
BestFeatureIndexInType = Idx;
Type = 1;
lastIdx = size(Features{Type},2);
while(lastIdx < Idx)
    BestFeatureIndexInType = BestFeatureIndexInType - size(Features{Type},2);
     lastIdx  = lastIdx + size(Features{Type + 1},2);
    Type = Type+1;  
end
FeatureType = Type;
end