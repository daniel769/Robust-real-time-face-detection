clear;



% %SC 01
% 
% load features;
% load PosSet1000;
% load NegSet2000;
% 
% MaxFPRate = 0.1;
% MinDRate = 0.99;
% FPTarget = 0.01;
% DecFeatRate = 0.80;
% SCThreshDecRate = 0.05;
% 
% tic
% SC=Cascade(MaxFPRate, MinDRate,  FPTarget, Features, PosSet, NegSet,SCThreshDecRate,DecFeatRate);
% toc
% save SC01.mat SC


% %SC 02
% 
% load features;
% load PosSet1000;
% load NegSet2000;
% 
% MaxFPRate = 0.3;
% MinDRate = 0.99;
% FPTarget = 0.05;
% DecFeatRate = 0.80;
% SCThreshDecRate = 0.05;
% 
% tic
% SC=Cascade(MaxFPRate, MinDRate,  FPTarget, Features, PosSet, NegSet,SCThreshDecRate,DecFeatRate);
% toc
% save SC02.mat SC

% load features;
% load PosSet1000;
% load NegSet2000;
% 
% MaxFPRate = 0.3;
% MinDRate = 0.99;
% FPTarget = 0.005;
% DecFeatRate = 0.80;
% SCThreshDecRate = 0.05;
% 
% tic
% SC=Cascade(MaxFPRate, MinDRate,  FPTarget, Features, PosSet, NegSet,SCThreshDecRate,DecFeatRate);
% toc
% save SC02.mat SC

% load features;
% load PosSet1000;
% load NegSet2000;
% 
% MaxFPRate = 0.3;
% MinDRate = 0.99;
% FPTarget = 0.0025;
% DecFeatRate = 0.6;
% SCThreshDecRate = 0.05;
% 
% tic
% SC=Cascade(MaxFPRate, MinDRate,  FPTarget, Features, PosSet, NegSet,SCThreshDecRate,DecFeatRate);
% toc
% save SC03.mat SC

% load features;
% load PosSet1000;
% load NegSet2000;
% 
% MaxFPRate = 0.3;
% MinDRate = 0.99;
% FPTarget = 0.0025;
% DecFeatRate = 0.2;
% SCThreshDecRate = 0.05;
% 
% tic
% SC=Cascade(MaxFPRate, MinDRate,  FPTarget, Features, PosSet, NegSet,SCThreshDecRate,DecFeatRate);
% toc
% save SC04.mat SC

% load features;
% load PosSet1000;
% load NegSet2000;
% 
% MaxFPRate = 0.3;
% MinDRate = 0.99;
% FPTarget = 0.0025;
% DecFeatRate = 0;
% SCThreshDecRate = 0.05;
% 
% tic
% SC=Cascade(MaxFPRate, MinDRate,  FPTarget, Features, PosSet, NegSet,SCThreshDecRate,DecFeatRate);
% toc
% save SC05.mat SC

% load features;
% load PosSet;
% load NegSet;
% 
% MaxFPRate = 0.3;
% MinDRate = 0.99;
% FPTarget = 0.0025;
% DecFeatRate = 0.6;
% SCThreshDecRate = 0.05;
% 
% tic
% SC=Cascade(MaxFPRate, MinDRate,  FPTarget, Features, PosSet, NegSet,SCThreshDecRate,DecFeatRate);
% toc
% save SC06.mat SC

% load features;
% load PosSet;
% load NegSet;
% 
% MaxFPRate = 0.3;
% MinDRate = 0.997;
% FPTarget = 0.0001;
% DecFeatRate = 0.6;
% SCThreshDecRate = 0.05;
% 
% tic
% SC=Cascade(MaxFPRate, MinDRate,  FPTarget, Features, PosSet, NegSet,SCThreshDecRate,DecFeatRate);
% toc
% save SC07.mat SC

% load features;
% load PosSet;
% load NegSet;
% 
% MaxFPRate = 0.3;
% MinDRate = 0.999;
% FPTarget = 0.0001;
% DecFeatRate = 0.6;
% SCThreshDecRate = 0.05;
% 
% tic
% SC=Cascade(MaxFPRate, MinDRate,  FPTarget, Features, PosSet, NegSet,SCThreshDecRate,DecFeatRate);
% toc
% save SC08.mat SC

% load features;
% load PosSet;
% load NegSet;
% 
% MaxFPRate = 0.3;
% MinDRate = 0.9997;
% FPTarget = 0.0001;
% DecFeatRate = 0.6;
% SCThreshDecRate = 0.05;
% 
% tic
% SC=Cascade(MaxFPRate, MinDRate,  FPTarget, Features, PosSet, NegSet,SCThreshDecRate,DecFeatRate);
% toc
% save SC09.mat SC

% load features;
% load PosSet;
% load Negs1;
% 
% MaxFPRate = 0.001;
% MinDRate = 0.997;
% FPTarget = MaxFPRate;
% DecFeatRate = 0.6;
% SCThreshDecRate = 0.05;
% 
% tic
% SC=Cascade(MaxFPRate, MinDRate,  FPTarget, Features, PosSet, NegSet,SCThreshDecRate,DecFeatRate);
% toc
% save SC06+01.mat SC;
% clear;
% 
% load features;
% load PosSet;
% load Negs2;
% 
% MaxFPRate = 0.001;
% MinDRate = 0.997;
% FPTarget = MaxFPRate;
% DecFeatRate = 0.6;
% SCThreshDecRate = 0.05;
% 
% tic
% SC=Cascade(MaxFPRate, MinDRate,  FPTarget, Features, PosSet, NegSet,SCThreshDecRate,DecFeatRate);
% toc
% save SC06+02.mat SC;
% clear;
% 
% load features;
% load PosSet;
% load Negs3;
% 
% MaxFPRate = 0.001;
% MinDRate = 0.997;
% FPTarget = MaxFPRate;
% DecFeatRate = 0.6;
% SCThreshDecRate = 0.05;
% 
% tic
% SC=Cascade(MaxFPRate, MinDRate,  FPTarget, Features, PosSet, NegSet,SCThreshDecRate,DecFeatRate);
% toc
% save SC06+03.mat SC;
% clear;

% load features;
% load PosSet1000;
% load NegSet2000;
% 
% MaxFPRate = 0.3;
% MinDRate = 0.99;
% FPTarget = 0.0025;
% DecFeatRate = 0;
% SCThreshDecRate = 0.05;
% 
% tic
% SC=Cascade(MaxFPRate, MinDRate,  FPTarget, Features, PosSet, NegSet,SCThreshDecRate,DecFeatRate,2);
% toc
% save SC05.mat SC


% load features;
% load PosSetPP;
% load NegSetPP;
% 
% MaxFPRate = 0.3;
% MinDRate = 0.99;
% FPTarget = 0.0025;
% DecFeatRate = 0.6;
% SCThreshDecRate = 0.05;
% FeatureValuesPath = 'C:\M.Sc\CV\matlab\Data\TempFeatureValuesChunks';
% logLevel = 2;
% ChunkSizeMB = 50;
% 
% tic
% SC=Cascade(MaxFPRate, MinDRate,  FPTarget, Features, PosSet, NegSet,SCThreshDecRate,DecFeatRate,logLevel,ChunkSizeMB,FeatureValuesPath);
% toc
% save SCPP.mat SC


load features;
load PosSetMerged;
%load NegSetMerged;
load NegsStage3;


MaxFPRate = 0.001;
MinDRate = 0.99;
FPTarget = MaxFPRate;
DecFeatRate = 0.0;
SCThreshDecRate = 0.05;

logLevel = 2;
ChunkSizeMB = 200;
FeatureValuesPath = 'C:\M.Sc\CV\matlab\Data\TempFeatureValuesChunks';

tic
SC=Cascade(MaxFPRate, MinDRate,  FPTarget, Features, PosSet, NegSet,SCThreshDecRate,DecFeatRate,logLevel,ChunkSizeMB,FeatureValuesPath);
toc
save SCMerged_03.mat SC
