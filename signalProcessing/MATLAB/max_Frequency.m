function max_Frequency(waveletTransform,sampling_frequency)
% Oblicz amplitudę (moduł) współczynników CWT
amplituda = abs(waveletTransform);

% Dla każdej chwili w czasie znajdź indeks największej amplitudy
[~, idx_max] = max(amplituda, [], 1);  % indeksy maksymalnych wartości wzdłuż częstotliwości


% Wydobądź odpowiadające częstotliwości
f_max = f(idx_max);  % maksymalna częstotliwość w każdej chwili

% Oś czasu 
time = (1:length(f_max)) / sampling_frequency;  % czas w sekundach

% Wykres
plot(time, f_max, '.', 'MarkerSize', 10); 
xlabel('Czas [s]');
ylabel('Maksymalna częstotliwość [Hz]');
title('Maksymalna częstotliwość w czasie (CWT)');
grid on;

end