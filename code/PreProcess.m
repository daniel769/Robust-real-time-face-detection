function [NormalizedImage] = PreProcess(Enable,Image)

% %new Version
%     if Enable
%        % Image = 255*imadjust(Image/255,stretchlim(Image/255),[0 1]);
%       
%       %Fix to stretching
% %       Mean = mean(Image(:));
% %       Max = max(Image(:));
% %       Min = min(Image(:));
% %       Image = round(255.0*(Image - Min)/(Max - Min));
%       
%       FacesStd = 42.4325; % ???????????????
%       
%       ImageMean = mean(Image(:));
%       ImageStd = sqrt(var(Image(:)));
%       
%       NormalizedImage = (Image-ImageMean) ./ ImageStd; 
%       NormalizedImage = NormalizedImage .* FacesStd;
%       NormalizedImage = round(NormalizedImage + (ImageMean .* (FacesStd ./ ImageStd)));
%       
%     end
    
    %older Version
     if Enable == 2
         Mean = mean(Image(:));
         Max = max(Image(:));
         Min = min(Image(:));
         NormalizedImage = round(255.0*(Image - Min)/(Max - Min));
      end
    
end