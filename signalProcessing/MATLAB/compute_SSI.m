function ssi_value = compute_SSI(data,decomposition_level,  wavelet_typ)

    [C, L] = wavedec(data, decomposition_level,  wavelet_typ);
    D2 = detcoef(C, L, 2);
    D2_normalized = D2 / max(abs(D2));
   ssi_value = sum(D2_normalized.^2);

end