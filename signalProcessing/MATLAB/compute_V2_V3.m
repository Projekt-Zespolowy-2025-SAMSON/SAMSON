function [v2_value,v3_value] = compute_V2_V3(data,wavelet_type)
cD1 =dwt(data, wavelet_type);

v2_value=(mean((cD1).^2))^(1/2);
v3_value=(mean(abs(cD1).^3))^(1/3);
end