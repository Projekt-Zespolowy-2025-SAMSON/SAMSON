function [MNF_value] = compute_MNF(data, fs)

    %Usunięcie składowej stałej
    data = data - mean(data);
    
    % Widmo mocy
    N = length(data);
    X = abs(fft(data)).^2/N; % Normalizacja
    f = (0:N-1)*(fs/N); % Wektor częstotliwości
    
    % 2. Tylko dodatnie częstotliwości (symetria FFT)
    X = X(1:floor(N/2)+1);
    f = f(1:floor(N/2)+1);
    f=f(:); %żeby zgadzały się wymiary
  
    % 3. Oblicz MNF
    MNF_value = sum(f .* X)/sum(X);
end