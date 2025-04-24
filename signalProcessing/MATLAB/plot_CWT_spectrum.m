function plot_CWT_spectrum(time,waveletTransform,fWT)
figure('Name', 'CWT spactrum');
imagesc(time, fWT, abs(waveletTransform));
axis xy;
xlabel('Czas (próbki)');
ylabel('Częstotliwość (Hz)');
title('Spektrum czasowo-częstotliwościowe sygnału EMG');
colorbar;

end