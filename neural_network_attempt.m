

%%
clear
clc
close all
imageFolder = imageDatastore('/Users/colinbrennan/Desktop/test')
imageLabeler(imageFolder);
%%
image_size = [1944 2592 3]

numClasses = 4

anchorBoxes = [1 1;4 6;5 3;9 6];

network = resnet50()

analyzeNetwork(network)

featureLayer = 'activation_49_relu';

lgraph = yolov2Layers(image_size,numClasses,anchorBoxes,network, featureLayer);
%%
training_set = objectDetectorTrainingData(gTruth);

%%
options1 = trainingOptions('sgdm');
%%
detector = trainRCNNObjectDetector(training_set, lgraph);

%%
img = imread('yes190516_124455_1.jpg');

[bboxes,scores] = detect(acfDetector,img);
%%
for i = 1:length(scores)
   annotation = sprintf('Confidence = %.1f',scores(i));
   img = insertObjectAnnotation(img,'rectangle',bboxes(i,:),annotation);
end

figure
imshow(img)