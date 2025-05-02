function [sm2_value,sm3_value] = compute_SM2_SM3(data,decomposition_level,wavelet_type)


[C, L] = wavedec(data, decomposition_level,  wavelet_type);

% Wyciąganie szczegółów z poziomu 1
cD1 = detcoef(C, L, 1);

% Obliczanie SM2 i SM3
sm2_value=mean((cD1 - mean(cD1)).^2);
sm3_value=mean((cD1 - mean(cD1)).^3);
end