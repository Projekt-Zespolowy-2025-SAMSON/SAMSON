function [MDF_value] = compute_MDF(data, fs)

    % Oblicz widmo mocy z oknem Hamminga
    N = length(data);
    %window = hamming(N);
    %signal_windowed = data .* window;
    % X = abs(fft(signal_windowed)).^2 / (sum(window.^2));
    X = abs(fft(data)).^2;
    f = (0:N-1)*(fs/N);
    
    % Tylko dodatnie częstotliwości
    X = (X(1:floor(N/2)+1))';
    f = f(1:floor(N/2)+1);
    
    % Oblicz całkowitą moc i połowę mocy
    P_total = sum(X);
    P_half = P_total / 2;
    
    % Znajdź MDF (częstotliwość medianalną)
    cumsum_P = cumsum(X);
    MDF_index = find(cumsum_P >= P_half, 1);
    MDF_value = f(MDF_index);
end