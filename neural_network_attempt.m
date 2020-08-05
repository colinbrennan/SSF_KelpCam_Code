

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


%%


%%
data = pixelLabelImageDatastore(gTruth);


%%
layers = [imageInputLayer([1944 2592 3]), convolution2dLayer(5,20), reluLayer, maxPooling2dLayer(2, 'Name','maxPooling1','Stride',1, 'Padding', [1,1]), fullyConnectedLayer(2), softmaxLayer, classificationLayer];
%%
training_set = objectDetectorTrainingData(gTruth);

%%
options1 = trainingOptions('sgdm', 'MiniBatchSize', 16, 'InitialLearnRate', 1e-3, 'MaxEpochs', 20);
%%
detector = trainNetwork(data, layers, options1);

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