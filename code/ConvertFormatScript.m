    input_dir_name = 'C:\M.Sc\CV\matlab\Data\CMU_Test.gif\test';
    output_dir_name = 'C:\M.Sc\CV\matlab\Data\CMU_Test\test';
    mkdir(output_dir_name);   
    files = dir(input_dir_name);
    for i=1:numel(files)
       [pathstr,name,ext,versn] = fileparts(files(i).name);
       %if strcmp(ext,'.tiff') == 1 
       if strcmp(ext,'.gif') == 1 || strcmp(ext,'.tif') == 1 || strcmp(ext,'.jpg') == 1 
            Image = readImage(fullfile(input_dir_name,files(i).name),ext(2:end));
            Max = max(max(Image));
            Min = min(min(Image));
            Range = Max - Min;
            str = sprintf('for %s, range is %.3d', name,Range);
            disp(str);
       end
    end    

%     input_dir_name = 'C:\M.Sc\CV\matlab\Data\CMU_Test.gif\test';
%     output_dir_name = 'C:\M.Sc\CV\matlab\Data\CMU_Test\test';
%     mkdir(output_dir_name);   
%     files = dir(input_dir_name);
%     for i=1:numel(files)
%        [pathstr,name,ext,versn] = fileparts(files(i).name);
%        %if strcmp(ext,'.tiff') == 1 
%        if strcmp(ext,'.jpg') == 1 || strcmp(ext,'.gif') == 1 || strcmp(ext,'.tif') == 1
%             %Image = readImage(fullfile(input_dir_name, files(i).name));
%              [Image,map] = imread(fullfile(input_dir_name,files(i).name));
%              imshow(Image,map);
%              if size(Image,3)==3
%                  Image = rgb2gray(Image);
%              end
%              imwrite(Image,map,'test.tif','tif');
%        end
%     end    