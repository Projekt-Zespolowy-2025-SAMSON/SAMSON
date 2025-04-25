function [MNF_value] = compute_MNF(data, fs)
%data=data';
    % 1. Oblicz widmo mocy z oknem Hamminga (redukcja przecieku)
    N = length(data);
    %window = hamming(N);
    %signal_windowed = data .* window;
    %X = abs(fft(signal_windowed)).^2 / sum(window.^2); % Normalizacja
   X = abs(fft(data)).^2; % Normalizacja
    f = (0:N-1)*(fs/N); % Wektor częstotliwości
    
    % 2. Tylko dodatnie częstotliwości (symetria FFT)
    X = X(1:floor(N/2)+1);
    f = f(1:floor(N/2)+1);
    f=f(:); %żeby zgadzały się wymiary
  
    % 3. Oblicz MNF
    MNF_value = sum(f .* X)/sum(X);
end