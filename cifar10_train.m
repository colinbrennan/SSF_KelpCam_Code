

fullfile(matlabroot,'examples','deeplearning_shared','main','helperCIFAR10Data.m')
addpath(fullfile(matlabroot,'examples','deeplearning_shared','main'))

cifar10Data = tempdir;

url = 'https://www.cs.toronto.edu/~kriz/cifar-10-matlab.tar.gz';

helperCIFAR10Data.download(url,cifar10Data);


%%

[trainingImages,trainingLabels,testImages,testLabels] = helperCIFAR10Data.load(cifar10Data);

%%

numImageCategories = 10;
categories(trainingLabels)

%%


%%
size = [32,32,3]

input_layer = imageInputLayer(size)

middle_layer = [convolution2dLayer([5 5],31,'Padding',2), reluLayer(),maxPooling2dLayer(3,'Stride',2),convolution2dLayer([5 5],31,'Padding',2),reluLayer(),maxPooling2dLayer(3,'Stride',2),convolution2dLayer([5 5],62,'Padding',2), reluLayer(),maxPooling2dLayer(3,'Stride',2)]

closing_layers = [fullyConnectedLayer(64),reluLayer, fullyConnectedLayer(10),softmaxLayer,classificationLayer], 
%%
Layers = [input_layer, middle_layer, closing_layers]
analyzeNetwork(Layers)

%%
Layers(2).Weights = 0.0001 * randn([[5 5], 3, 64]);


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

doTraining = true;

if doTraining    
   
    network = trainNetwork(trainingImages, trainingLabels, Layers, opts);
else
     
end
