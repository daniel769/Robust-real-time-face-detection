function [Set] = PreProcessSet(Set)
%     for i = 1:size(Set,3)
%         Set(2:end,2:end,i) = round(PreProcess(1,Set(2:end,2:end,i)));
%     end

      FacesStd = 42.4325; % ???????????????
      
      ImageMean = mean(Image,1);
      ImageMean = mean(ImageMean,2);
      
      ImageStd = sqrt(var(Image(:)));
      
      NormalizedImage = (Image-ImageMean) ./ ImageStd; 
      NormalizedImage = NormalizedImage .* FacesStd;
      NormalizedImage = round(NormalizedImage + (ImageMean .* (FacesStd ./ ImageStd)));
      
      
      
      
      
          %older Version
     if Enable == 2
          Mean = mean(Image(:));
      Max = max(Image(:));
      Min = min(Image(:));
      NormalizedImage = round(255.0*(Image - Min)/(Max - Min));
     end

%       MaxVec = max(Set,[],1);
%       MaxVec = max(MaxVec,[],2);
%       
%       MinVec = Min(Set,[],1);
%       MinVec = Min(MinVec,[],2);
%       
%      
%       reshapeSet = Reshape(Set(2:end,2:end,:),(size(Set,1)-1)*(size(Set,2)-1),size(Set,3));
%       reshapeSet - 
      
end
