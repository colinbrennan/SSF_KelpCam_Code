clear
clc
close all






yew = [0,0,0,0];
hi = pixel_values(yew);


mini = fminsearch(@pixel_values, yew);

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


