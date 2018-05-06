function  [box,cumsumbox] = prepareBox(dir_name, amount,PreProcess)

    files = dir(dir_name);
    flag  = 0;
    if (numel(files) < amount)
        amount = numel(files)-2;
        %printf 'there are only %d pgm files in this folder'  amount;
    end
    
    count = 0;
    while(count < amount)
       [pathstr,name,ext,versn] = fileparts(files(count+1).name);
       if strcmp(ext, '.pgm') 
           if flag == 0
              flag = 1; % Image size checked
              img = imread(fullfile(dir_name, files(count+1).name));
              sz = size(img);
           end
           count = count + 1;
       else
         files(count+1) = [];
       end
    end

    %represent images in a box
    box = zeros( size(img,1) + 1,size(img,2) + 1,length(count));
    
    for i=1:count
      [pathstr,name,ext,versn] = fileparts(files(i).name);
      if strcmp(ext,'.pgm')
        img = imread(fullfile(dir_name, files(i).name));
        box(2:size(img,1) +1 ,2:size(img,2) + 1,i) = img;
      end
    end
    if PreProcess
        box = PreProcessSet(box); 
    end  
    %the testing part, we currently avoid it
    cumsumbox = BuildIntegral(box);
end

function cumsumBox = BuildIntegral(box)
    box = cumsum(box,1);
    box = cumsum(box,2);
    cumsumBox = box;
    % save box.mat box; % pos & neg!!!!!!!!!!!!!!!!!
end