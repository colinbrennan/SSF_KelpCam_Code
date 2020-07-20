

%%

imageFolder = imageDatastore('/Users/colinbrennan/Desktop/test')
imageLabeler(imageFolder);
%%
yo = objectDetectorTrainingData(gTruth);

%%
acfDetector = trainACFObjectDetector(yo,'NegativeSamplesFactor',2);

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