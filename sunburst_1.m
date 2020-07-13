







%%




x_o = 0
y_o = 0
r_1 = 0
r_2 = 0

x = (0:1:2591)
y = (0:1:1943)
y_T = transpose(y)

r = sqrt(((x-x_o).^2)+(y_T-y_o).^2);

%%
pv = (r-r_1)/(r_2-r_1);
pv_grad = gradient(pv);

%%
Pv_resize = pv/(max(max(pv)));
imshow(pv);
%%
pv_resize_bw = mat2gray(pv);

test1 = imread('200123_181506_2.jpg');
imshow(test1);

%%
test = rgb2gray(test2);


boi = (imsubtract(test, I));
imshow(boi)

test

hello world
yoyo

hiii



