function [FARate, FA] = SumDetections()
%SUMDETECTIONS Summary of this function goes here
%   Detailed explanation goes here
load ImageResults;
nImages = size(ImageResults,2);
sum = 0;
% for i=1:nImages
%     Det(i,:) = ImageResults(i).DecAmount(2,:);
% end
% sum = sum(Det(:));
for i=1:nImages
    dets = (ImageResults(i).DecAmount(2,:))';
    for j=1:length(dets)
        sum = sum + dets(j);
        
    end
    FARate(i) = mean((ImageResults(i).DecAmount(2,:))./(ImageResults(i).DecAmount(1,:)));    
end
FA = sum/nImages;
FARate = mean(FARate);
