% function [ ImageResults,tocCounter ] = TestBenchmark( input_dir_name,output_dir_name )
%TESTBENCHMARK Summary of this function goes here
%   Detailed explanation goes here

%run test cascade testing
% create report - 
% Time per Image

%input parameters
input_dir_name = 'C:\M.Sc\CV\matlab\Data\CMU_Test\test';
output_dir_name = 'C:\M.Sc\CV\matlab\Data\BenchmarkResults\SC_1_2_3_WGPrePro';
SlideSize = 19;
SingleStep = -1;
EnlargeFactor = 1.25;
deltaX = 1;
deltaY = 1;
maxHeight = 288;
maxWidth = 384;
maxMemMB = 200;
EnablePre = 0;
EnablePreGlobal = 1;
EnablePP = 0;
rejectDist = 1;
minFacesBunch = 2;
files = dir(input_dir_name);
    
    
% for loop - ever smaller cascade
%load SC06ext;
%load SCPP;
load SC_1_2_3;
for CasIter=numel(SC):-1:1
    resultsPath = [output_dir_name sprintf('%.2d',CasIter)];
    mkdir(resultsPath);
    ImageResults = struct('name',{},'elapsedTime',{},'DecAmount',{});
    tocCounter = 0;
    count = 1;
    for i=1:numel(files)
       [pathstr,name,ext,versn] = fileparts(files(i).name);
       %if strcmp(ext,'.tiff') == 1 
       
       if strcmp(ext,'.gif') == 1 || strcmp(ext,'.tif') == 1 || strcmp(ext,'.jpg') == 1 
            Image = readImage(fullfile(input_dir_name,files(i).name),ext(2:end));
            tic
             [FramedImage,FacesWinIdx,amount] = CascadeTesting(Image,SlideSize,SC,SingleStep,EnlargeFactor,deltaX,deltaY,maxHeight, maxWidth,maxMemMB,EnablePP,rejectDist,minFacesBunch,EnablePre,EnablePreGlobal);
             elapsedTime = toc;
             tocCounter = tocCounter + elapsedTime;
             ImageResults(count).name = name;
             ImageResults(count).elapsedTime = elapsedTime;
             ImageResults(count).DecAmount = amount;
             writeImage(FramedImage,[resultsPath '\' name 'Result.tif']);
             count = count + 1;
       end
    end    
    save([resultsPath '\ImageResults.mat'],'ImageResults');
    SC(CasIter)=[];
end
