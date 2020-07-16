clear
clc
close all


% filtering out only images from upward-facing camera

filter_up = dir('*_1.jpg*')
filter_up = struct2cell(filter_up);
[r,c] = size(filter_up);

pixel_rows = 1944;
pixel_columns = 2592;

%%
  
% process all of the images
Images_of_Interest = []

for i = 1:c;   
    
%load in test shot
test = imread(filter_up{1,i});
test_gray = rgb2gray(test);

%%

%filter using line detection
test_gray_edged = edge(test_gray, 'prewitt', 'nothinning');


%filter returns by area
filtered_image = bwareaopen(test_gray_edged, 7000);


%filter returns by length
lengths = regionprops(filtered_image, 'MajorAxisLength');
Lengths = [lengths.MajorAxisLength];
index = Lengths > 100;
final_test = lengths(index);

if isempty(final_test);
  
else
 info = imfinfo(filter_up{1,i});
 Images_of_Interest = [Images_of_Interest; string(filter_up{1,i}), info.Comment]
    
end
end


 








