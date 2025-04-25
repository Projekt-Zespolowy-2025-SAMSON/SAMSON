function [dasdv_value] = compute_DASDV(data)
      % Oblicz różnice między kolejnymi próbkami
    differences = diff(data);
    
    % DASDV = odchylenie standardowe różnic
    dasdv_value = sqrt(sum(differences.^2)/length(differences)); 
    % Uwaga: W oryginalnym wzorze dzielimy przez (N-1), ale 'mean' dzieli przez N,
    % więc dla dokładności możesz użyć:
    % dasdv = sqrt(sum(differences.^2) / (length(differences)));
end