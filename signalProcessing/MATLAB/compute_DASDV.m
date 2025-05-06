function [dasdv_value] = compute_DASDV(data)
data = data - mean(data);
      % Oblicz różnice między kolejnymi próbkami
    differences = diff(data);
    
    % DASDV = odchylenie standardowe różnic
    dasdv_value = sqrt(sum(differences.^2)/(length(differences)-1)); 
  
end