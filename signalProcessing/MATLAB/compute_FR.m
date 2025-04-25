function [FR_value] = compute_FR(data,sampling_frequency,bandL, bandH,show)
% Przykładowy sygnał EMG

% Obliczenie FFT
N = length(data);
f = (0:N-1)*(sampling_frequency/N); % Wektor częstotliwości
X = abs(fft(data)).^2 / N; % Widmo mocy

% Tylko dodatnie częstotliwości (symetria FFT)
X = X(1:floor(N/2)+1);
f = f(1:floor(N/2)+1);

% Znajdź indeksy odpowiadające pasmom
idx_low = (f >= bandL(1)) & (f <= bandL(2));   % Dolne pasmo
idx_high = (f >= bandH(1)) & (f <= bandH(2));  % Górne pasmo

% Suma mocy w pasmach
P_low = sum(X(idx_low));
P_high = sum(X(idx_high));

% Frequency Ratio (FR)
FR_value = P_low / P_high;
%disp(['Frequency Ratio (FR) = ', num2str(FR)]);

if show
figure;
plot(f, 10*log10(X)); % Widmo w dB
xlabel('Częstotliwość [Hz]');
ylabel('Moc [dB]');
title('Widmo mocy sygnału EMG');
hold on;
xline(bandL(1), 'r--'); xline(bandL(2), 'r--'); % Zaznaczenie dolnego pasma
xline(bandH(1), 'b--'); xline(bandH(2), 'b--'); % Zaznaczenie górnego pasma
%legend('Widmo', 'Dolne pasmo', 'Górne pasmo');
grid on;
end

end