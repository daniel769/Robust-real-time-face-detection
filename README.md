# Robust-real-time-face-detection---training-and-classification

#### About
Developed from scratch  - a fully vectorized algorithm based on the original paper of Viola&Jones (Supervised learning: Ada-boost and classifier cascading) robust real time face detection - training and classification. Very large amount of skewed class training data, continuous training over several weeks. Detection rates were very close to the ones in the original paper (w/o any code reference);

#### To use our Code

First, add to Matlab path, Code folder + all subfolders

#### To Use Viola Jones Training

Run TrainingScript with the following parameters:

| Parameter         | Description                                                  | Default Value |
| :---------------- | ------------------------------------------------------------ | ------------- |
| load features     | Features to use (you can use FeaturesBuilder to build them again) |               |
| load PosSetMerged | positive training data (you can use prepareBoxScript to build them) |               |
| load NegsStage3   | negative training data (you can use prepareBoxScript to build them) |               |
| MaxFPRate         | false positive rate for each cascade iteration               | 0.001         |
| MinDRate          | minimal detection rate to reach                              | 0.99          |
| FPTarget          | overall false positive rate                                  | MaxFPRate     |
| DecFeatRate       | how many features to ignore (in percentage) (these will not be used at all during training) | 0.0           |
| SCThreshDecRate   | how fast to lower detection rate to reach                    | 0.05          |
| logLevel          | which log prints to log                                      | 2             |
| ChunkSizeMB       | how to split data - how big one chunk of data should be (according to your computer memory limitations) | 200           |
| FeatureValuesPath | folder path to save temp data during training                |               |



#### To Use Viola Jones Testing

Run TestBenchmark with the following parameters:

| parameter       | description                                                  | default value |
| --------------- | ------------------------------------------------------------ | ------------- |
| input_dir_name  | path of folder with test images                              |               |
| output_dir_name | path of folder to house results                              |               |
| SlideSize       | detector size                                                | 19            |
| SingleStep      | how many/which scales to use (-1 all scales, 0 base scale, 1 scale wich is one enlargement, 2 scale which means 2 enlargements) | -1            |
| EnlargeFactor   | how much to enalrge the detector size in each scale          | 1.25          |
| deltaX          | how many sub-windows to skip in X axis                       | 1             |
| deltaY          | how many sub-windows to skip in X axis                       | 1             |
| maxHeight       | maximal input image height (deprecated)                      | 288           |
| maxWidth        | maximal input image width (deprecated)                       | 384           |
| maxMemMB        | maximal chunk of data at once to operate on (according to your computer limitations) | 200           |
| EnablePre       | enable preprocessing on each subwindow of image (boolean)    | 0             |
| EnablePreGlobal | enable preprocesing globaly on image (boolean)               | 1             |
| EnablePP        | enable postprocessing (for better false alarm rate)          | 0             |
| rejectDist      | how many false alrams to reject according to distance from other false alarm windows | 1             |
| minFacesBunch   | how many faces windows should be together in order to be considered a good detection so not reject it |               |
| load SC_1_2_3   | load result of training (the classifier)                     |               |
