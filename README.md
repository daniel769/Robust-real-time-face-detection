# Robust-real-time-face-detection---training-and-classification

To use our Code:

- First, add to Matlab path, Code folder + all subfolders


To Use Viola Jones Training:
Run TrainingScript with the following parameters:

load features;               -  features to use (you can use FeaturesBuilder to build them again)
load PosSetMerged;           -  positive training data (you can use prepareBoxScript to build them)
load NegsStage3;             -  negative training data (you can use prepareBoxScript to build them)


MaxFPRate = 0.001;           -  false positive rate for each cascade iteration     
MinDRate = 0.99;             -  minimal detection rate to reach
FPTarget = MaxFPRate;        -  overall false positive rate
DecFeatRate = 0.0;           -  how many features to ignore (in percentage) (these will not be used at all during training)
SCThreshDecRate = 0.05;      -  how fast to lower detection rate to reach

logLevel = 2;                -  which log prints to log
ChunkSizeMB = 200;           -  how to split data - how big one chunk of data should be (according to your computer memory limitations)
FeatureValuesPath = 'C:\M.Sc\CV\matlab\Data\TempFeatureValuesChunks';      -  folder path to save temp data during training



To Use Viola Jones Testing:
Run TestBenchmark with the following parameters:


input_dir_name = 'C:\M.Sc\CV\matlab\Data\CMU_Test\test';                        -  path of folder with test images
output_dir_name = 'C:\M.Sc\CV\matlab\Data\BenchmarkResults\SC_1_2_3_WGPrePro';  -  path of folder to house results
SlideSize = 19;              -  detector size
SingleStep = -1;             -  how many/which scales to use (-1 all scales, 0 base scale, 1 scale wich is one enlargement, 2 scale which means 2 enlargements)
EnlargeFactor = 1.25;        -  how much to enalrge the detector size in each scale
deltaX = 1;                  -  how many sub-windows to skip in X axis
deltaY = 1;                  -  how many sub-windows to skip in X axis
maxHeight = 288;             -  maximal input image height (deprecated)
maxWidth = 384;              -  maximal input image width (deprecated)
maxMemMB = 200;              -  maximal chunk of data at once to operate on (according to your computer limitations)
EnablePre = 0;               -  enable preprocessing on each subwindow of image (boolean)
EnablePreGlobal = 1;         -  enable preprocesing globaly on image (boolean)
EnablePP = 0;                -  enable postprocessing (for better false alarm rate)
rejectDist = 1;              -  how many false alrams to reject according to distance from other false alarm windows
minFacesBunch = 2;           -  how many faces windows should be together in order to be considered a good detection so not reject it.

load SC_1_2_3;               -  load result of training (the classifier)
