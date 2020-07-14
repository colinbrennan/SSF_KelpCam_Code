clear
clc
close all


start = [1000,1000,50,100];
test = pixel_values(start);
imshow(test)


%%

function 
test_image = imread('200123_171546_1.jpg');
    test_gray = rgb2gray(test_image);
    
    test_gray_1 = double(test_gray);
    test_gray_2 = mat2gray(test_gray_1);
    diference = imsubtract(test, test_gray_2);
    imshow(diference);

%%


function pv = pixel_values(p)
    x_o = p(1);
    y_o = p(2);
    r_1 = p(3);
    r_2 = p(4);
    x = (0:1:2591);
    y = (0:1:1943);
    y_T = transpose(y);
    r = sqrt(((x-x_o).^2)+(y_T-y_o).^2);
    pv_raw = (r-r_1)/(r_2-r_1);
    pv = pv_raw/(max(max(pv_raw)));
    
    
end

