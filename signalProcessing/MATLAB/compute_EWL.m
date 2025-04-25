function compute_EWL(waveletTransform,sampling_frequency)
t = 0:1/sampling_frequency:1;
% Obliczanie różnicy między współczynnikami falkowymi
delta_wt = diff(waveletTransform, 1, 1);  % Różnica między kolejnymi współczynnikami (po wierszach)

% Liczba współczynników falkowych
L = size(waveletTransform, 1);  % Liczba skal

% Wektor wag p
p = zeros(L-1, 1);

% Przypisanie wag p
for i = 1:L-1
    if i > 0.2*L && i < 0.8*L
        p(i) = 0.75;
    else
        p(i) = 0.50;
    end
end

% Obliczanie EWL
EWL = sum(abs(delta_wt).^p);  % Suma energii

% Wykres energii w różnych pasmach
figure;
subplot(2, 1, 1);
plot(t, EWL); 
xlabel('Czas [s]');
ylabel('Energia EWL');
title('Energia Współczynników Falkowych');

% Możesz również narysować wykres transformacji falkowej
subplot(2, 1, 2);
imagesc(t, f, abs(wt));  % Wizualizacja amplitudy CWT
axis xy;
xlabel('Czas [s]');
ylabel('Częstotliwość [Hz]');
title('Transformacja Falkowa (CWT)');
colorbar;

end