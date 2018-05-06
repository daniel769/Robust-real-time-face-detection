%     load SC08;
%     dir_name = 'C:\M.Sc\CV\matlab\Data\test\face';
%     files = dir(dir_name);
%     count = 0 ;
%     countCorrect = 0 ;
%     flag  = 0;
%     SlideSize = 19;
%     EnlargeFactor = 1.25;
%     EnlargeFeatSteps =0;
%     deltaX = 2;
%     deltaY = 2;
%     for i=1:size(files,1)
%        [pathstr,name,ext,versn] = fileparts(files(i).name);
%        if ext == '.pgm'
%            count = count + 1; 
%               img = imread(fullfile(dir_name, files(i).name));
%              [FramedImage,amount] = CascadeTesting(img,SlideSize,SC,EnlargeFactor,EnlargeFeatSteps,deltaX,deltaY);
%              if amount > 0 
%                  countCorrect = countCorrect + 1;
%              end
%        end
%     end
%     DRate = countCorrect / count;
    
    
    
        load SC08;
    dir_name = 'C:\M.Sc\CV\matlab\Data\test\non-face';
    files = dir(dir_name);
    count = 0 ;
    countFP = 0 ;
    flag  = 0;
    SlideSize = 19;
    EnlargeFactor = 1.25;
    EnlargeFeatSteps =0;
    deltaX = 2;
    deltaY = 2;
    maxHeight = 288;
    maxWidth = 384;
    for i=1:5000
       [pathstr,name,ext,versn] = fileparts(files(i).name);
       if ext == '.pgm'
           count = count + 1; 
              img = imread(fullfile(dir_name, files(i).name));
             [FramedImage,amount] = CascadeTesting(img,SlideSize,SC,EnlargeFactor,EnlargeFeatSteps,deltaX,deltaY, );
             if amount > 0 
                 countFP = countFP + 1;
             end
       end
    end
    FPRate = countFP / count;