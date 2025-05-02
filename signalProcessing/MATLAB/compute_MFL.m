function mfl_value = compute_MFL(data,decomposition_level,wavelet_type)
[C,L]=wavedec(data,decomposition_level,wavelet_type);
D=detcoef(C, L,1); % domyślnie D1, bo to mam sens dla MFL
 D = D / max(abs(D));
mfl_value=log10(sqrt(sum(diff(D).^2)));
end