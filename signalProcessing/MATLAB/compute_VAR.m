function var_value = compute_VAR(data,decomposition_level,  wavelet_type)

  % Dekompozycja falkowa (Db7, poziom 2)
    [C, L] = wavedec(data, decomposition_level, wavelet_type);
    D2 = detcoef(C, L, 2); % Ekstrakcja D2
    
    % Obliczenie wariancji (dzielenie przez N)
    var_value = var(D2, 1); 

end