clear
clc
close all

% setting up initial reference image for "just water"

reference = imread('190516_125414_4.jpg');
reference_gray = rgb2gray(reference);

% removing sun glare

[rows, columns] = size(reference_gray);

for i = 1:rows
    for x = 1:columns
 
    if reference_gray(i, x) < 210
       
    else
        reference_gray(i,x) = 120;
    end
 
    end

end

% filtering out only images from upward-facing camera

filter_up = dir('*_1.jpg*')
filter_up_cell = struct2cell(filter_up);

%%
  
% process all of the images

Images_of_Interest = []

for i = 1:10;   
    
%load in test shot
test = imread(filter_up_cell{1,i});
test_gray = rgb2gray(test);

% cut out sun glare
for a = 1:rows
    for b = 1:columns
 
    if test_gray(a, b) < 210
       
    else
        test_gray(a,b) = 120;
    end
    end
end

%compare
difference = imsubtract(reference_gray, test_gray);

%filter by intensity
limit = difference > 55;

%filter by area
filtered_image = bwareaopen(limit, 200000);


%filter by length
lengths = regionprops(filtered_image, 'MajorAxisLength');
Lengths = [lengths.MajorAxisLength];
index = Lengths > 20;
final_test = lengths(index);

if isempty(final_test);
  
else
 info = imfinfo(filter_up_cell{1,i});
 Images_of_Interest = [Images_of_Interest; string(filter_up_cell{1,i}), info.Comment]
    
end
end


 








