clear
clc 
close all
%%

fullfile(matlabroot,'examples','deeplearning_shared','main','helperCIFAR10Data.m')
addpath(fullfile(matlabroot,'examples','deeplearning_shared','main'))

cifar10Data = cd;



%%

[trainingImages,trainingLabels,testImages,testLabels] = helperCIFAR10Data.load(cifar10Data);



%%
size = [32,32,3]

input_layer = imageInputLayer(size)

middle_layer = [convolution2dLayer([5 5],32,'Padding',2), reluLayer(),maxPooling2dLayer(3,'Stride',2),convolution2dLayer([5 5],32,'Padding',2),reluLayer(),maxPooling2dLayer(3,'Stride',2),convolution2dLayer([5 5],64,'Padding',2), reluLayer(),maxPooling2dLayer(3,'Stride',2)]

closing_layers = [fullyConnectedLayer(64),reluLayer, fullyConnectedLayer(10),softmaxLayer,classificationLayer], 
%%
Layers = [input_layer, middle_layer, closing_layers]
%analyzeNetwork(Layers)

%%
Layers(2).Weights = 0.0001 * randn([[5 5], 3, 32]);


%%

opts = trainingOptions('sgdm', ...
    'Momentum', 0.9, ...
    'InitialLearnRate', 0.001, ...
    'LearnRateSchedule', 'piecewise', ...
    'LearnRateDropFactor', 0.1, ...
    'LearnRateDropPeriod', 8, ...
    'L2Regularization', 0.004, ...
    'MaxEpochs', 40, ...
    'MiniBatchSize', 128, ...
    'Verbose', true, 'Plots', 'training-progress');

%%

doTraining = false;

if doTraining    
   
    network = trainNetwork(trainingImages, trainingLabels, Layers, opts);
    save network
else
     load('network.mat', 'network')
end

%%
%Determine the accuracy of initial network
YTest = classify(network, testImages);
accuracy = sum(YTest == testLabels)/numel(testLabels)


plotconfusion(testLabels, YTest)

%%

%imds = (imageDatastore('/Users/colinbrennan/Desktop/cifar-10-batches-mat/kelp_boat_lines'))
%imageLabeler(imds)

%%
unzip kelp_boat_lines.zip

image_data = load('kelp_boat_lines_groundTruth.mat')

image_data = image_data.gTruth

%%
image_dataset = objectDetectorTrainingData(image_data)

%%

height = height(image_dataset)

%%
rng(0)
shuffled_indicies = randperm(height);
indx = floor(0.8* height);

training_data_indx = 1:indx
training_data_table = image_dataset(shuffled_indicies(training_data_indx),:)

test_indx = training_data_indx(end)+1 : length(shuffled_indicies);
test_data_table = image_dataset(shuffled_indicies(test_indx),:)

%%
options = trainingOptions('sgdm', ...
        'MiniBatchSize', 128, ...
        'InitialLearnRate', .001, ...
        'LearnRateSchedule', 'piecewise', ...
        'LearnRateDropFactor', 0.1, ...
        'LearnRateDropPeriod', 100, ...
        'MaxEpochs', 50, ... 
        'Verbose', true);
%%
options_2 = trainingOptions('sgdm', 'MiniBatchSize',1,'InitialLearnRate',7,'VerboseFrequency',200,'CheckpointPath', tempdir);

%%
do_training_rcnn = true;
  
 if do_training_rcnn   
    rcnn = trainRCNNObjectDetector(training_data_table, network, options, 'NegativeOverlapRange', [0 0.1], 'PositiveOverlapRange',[0.4 1])
    save rcnn
 else
     load('rcnn.mat','rcnn')
 end
      
 %%
 

%%
numImages = height(test_data_table)
%%
numImgaes = 14
results = table('Size',[14 6], 'VariableTypes', {'cell','cell','cell','cell','cell','cell'},'VariableNames',{'boat','Scores_1','kelp','Scores_2','lines','Scores_3'})

%%
test_image_datastore = imageDatastore(test_data_table.imageFilename)

%%
for i = 1:14
    I = readimage(test_image_datastore, i);
    [bboxes, score,label] = detect(rcnn, I,'MiniBatchSize',128);
  for ii = 1:length(score)
      
    if label(ii) == string('kelp')
        if score(ii) > .8
        results.kelp{i} = bboxes(ii,:);
        results.Scores_2{i} = score(ii);
        else
            results.kelp{i} = [];
            results.Scores_2{i} = [];
        end
    end
   
   
    if label(ii) == string('lines')
        if score(ii) > .8
        results.lines{i} = bboxes(ii,:);
        results.Scores_3{i} = score(ii);
        else
            results.lines{i} = [];
            results.Scores_3{i} = [];
        end
    end
    
    if label(index) == string('boat')
        if score(ii) > .8
        results.boat{i} = bboxes(ii,:);
        results.Scores_1{i} = score(ii);
        else
            results.boat{i} = [];
            results.Scores_1{i} = [];
        end
    end
  end
end

%%
results
test_data_table


%%

%%
 I = readimage(test_image_datastore, 13);
    [bboxes, score,label] = detect(rcnn, testImage,'MiniBatchSize',128)
    
 
 
 %%
 label
%%
results(:,1:2)
test_data_table(:,2)

%%

outputImage = insertObjectAnnotation(im, 'rectangle', results.Boxes{5}, 'test', 'FontSize',36, 'LineWidth',8);
figure
imshow(outputImage) 
%%
insertObjectAnnotation(im, 'rectangle', test_data_table(5,2), 'test', 'FontSize',36, 'LineWidth',8);
figure
imshow(outputImage) 


%%

    
%%
[ap,recall,precision]=evaluateDetectionPrecision(results(:,3:4), test_data_table(:,3), .5)
figure 
plot(recall,precision)
grid on
   

%%
results
test_data_table(:,2:4)
    
    %%
      clear label_string
      clear pos_data

%%
testImage = imread('190516_124401_2.jpg');
      
%%
      
[bboxes,score,label] = detect(rcnn,testImage,'MiniBatchSize',128)
  
 
%%
for ii = 1:length(label)
    if  score(ii) >= .7
    label_string{ii} = sprintf('%s: (Confidence = %f)', label(ii,1), score(ii,1))
    pos_data(ii,:) = bboxes(ii,:)
    else
        label_string{ii} = sprintf('%s: (Confidence = %f)', label(ii,1), score(ii,1))
        pos_data(ii,:) = [zeros]
    end
    
end


%%
outputImage = insertObjectAnnotation(testImage, 'rectangle', bboxes, label_string, 'FontSize',36, 'LineWidth',8);
figure
imshow(outputImage)  



%%




