function mmav_value = compute_MMAV(data,decomposition_level,  wavelet_type)

   [C, L] = wavedec(data, decomposition_level, wavelet_type);
    D2 = detcoef(C, L, 2); % Składowa D2

    N = length(D2);
    w = ones(N, 1);

    w(1:floor(0.25*N)) = 0.5;
    w(floor(0.75*N):end) = 0.5;
    mmav_value = mean(w .* abs(D2));

end