function [PSR_value] = compute_PSR(data, fs, f_center, bandwidth, show)
    
    %Usunięcie składowej stałej
    data = data - mean(data);

    % Obliczenie FFT
    N = length(data);
    X=abs(fft(data)).^2/N;
    f = (0:N-1)*(fs/N);
    
    % Tylko dodatnie częstotliwości
    X = X(1:floor(N/2)+1);
    f = f(1:floor(N/2)+1);
    
    % Definicja pasma
    lower_bound = f_center - bandwidth/2;
    upper_bound = f_center + bandwidth/2;
    
    % Obliczenie PSR
    idx_band = (f >= lower_bound) & (f <= upper_bound);
    P0 = sum(X(idx_band));
    P_total = sum(X);
    PSR_value = P0 / P_total;
    
    % Wizualizacja
    if show
        figure;
        plot(f, 10*log10(X));
        hold on;
        xline(lower_bound, 'r--');
        xline(upper_bound, 'r--');
      %  title(['Widmo mocy: PSR = ', num2str(PSR), ' dla ', num2str(f0), ' Hz ±', num2str(bandwidth/2), ' Hz']);
        xlabel('Częstotliwość [Hz]');
        ylabel('Moc [dB]');
        grid on;
    end
end
