function rms_value =compute_RMS(data,decomposition_level,wavelet_type)

[C,L]=wavedec(data,decomposition_level,wavelet_type);

cD1 = detcoef(C,L, 1); 

rms_value=sqrt(mean(cD1.^2));
end