input_dir_name = 'C:\M.Sc\CV\matlab\Data\NonFaces4';
output_dir_name = 'C:\M.Sc\CV\matlab\Data\NonFaces4\Results';
load SCMerged+02;
mkdir(output_dir_name);
ImageResults = struct('name',{},'elapsedTime',{},'DecAmount',{});
SlideSize = 19;
SingleStep = 0;
EnlargeFactor = 1.25;
deltaX = 1;
deltaY = 1;
maxHeight = 288;
maxWidth = 384;
maxMemMB = 50;
EnablePre = 0;
EnablePreGlobal = 1;
EnablePP = 0;
rejectDist = 1;
minFacesBunch = 2;
files = dir(input_dir_name);
tocCounter = 0;
count = 1;
NegsWindows = [];
for i=1:numel(files)
   [pathstr,name,ext,versn] = fileparts(files(i).name);
   %if strcmp(ext,'.tiff') == 1 

   if strcmp(ext,'.gif') == 1 || strcmp(ext,'.tif') == 1 || strcmp(ext,'.tiff') == 1 || strcmp(ext,'.jpg') == 1 
        Image = readImage(fullfile(input_dir_name,files(i).name),ext(2:end));
        tic
         [FramedImage,FacesWinIdx,amount] = CascadeTesting(Image,SlideSize,SC,SingleStep,EnlargeFactor,deltaX,deltaY,maxHeight, maxWidth,maxMemMB,EnablePP,rejectDist,minFacesBunch,EnablePre,EnablePreGlobal);
         elapsedTime = toc;
         tocCounter = tocCounter + elapsedTime;
         ImageResults(count).name = name;
         ImageResults(count).elapsedTime = elapsedTime;
         ImageResults(count).DecAmount = amount;
         writeImage(FramedImage,[output_dir_name '\' name 'Result.tif']);
         NegsWindows = [NegsWindows createNegWindows(Image,FacesWinIdx)];
         count = count + 1;
   end
end    

negsAmount = min(10000,numel(NegsWindows));

box = zeros( SlideSize + 1,SlideSize + 1,negsAmount);
    
for i=1:negsAmount
    img = NegsWindows{i};
    box(2:size(img,1) +1 ,2:size(img,2) + 1,i) = img;
end
%the testing part, we currently avoid it
box = cumsum(box,1);
box = cumsum(box,2);
NegSet = box;
    
save([output_dir_name '\negs04.mat'],'NegSet');