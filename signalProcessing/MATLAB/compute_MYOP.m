function myop_value = compute_MYOP(data,decomposition_level,wavelet_type,threshold_percent)

[C,L]=wavedec(data,decomposition_level,wavelet_type);
D=detcoef(C, L,1); % domyślnie D1, bo to mam sens dla MFL
threshold = threshold_percent*max(abs(D));
above_threshold = sum(abs(D)>=threshold);
myop_value=(above_threshold/numel(D))*100;

end