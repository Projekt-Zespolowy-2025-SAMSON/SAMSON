function [signal_filtered] = filters_f(data,ch_num,sampling_frequency,passband,notch_freq,show)
 signal_filtered = zeros(size(data));
if show==0
for i = 1:ch_num

   
%Filtr pasmowo-przepustowy

fs=sampling_frequency;
[b_band, a_band] = butter(4, passband/(fs/2), 'bandpass'); %rząd filtru
signal_bandpassed = filtfilt(b_band, a_band, data(:,i));


%Filtr wycinający 50Hz lub 60Hz

fs = sampling_frequency;          % Częstotliwość próbkowania [Hz]
f0 = notch_freq;            % Częstotliwość do usunięcia [Hz]
bandwidth = 5;      % Szerokość pasma zaporowego [Hz]

% Zakres częstotliwości do stłumienia
f_low = f0 - bandwidth/2;
f_high = f0 + bandwidth/2;

% Projektowanie filtra Butterwortha pasmowozaporowego
order = 4;          % Rząd filtra
[b, a] = butter(order, [f_low, f_high]/(fs/2), 'stop');

filtered=filtfilt(b,a,signal_bandpassed);

signal_filtered(:,i)=filtered;

% Charakterystyka częstotliwościowa
%freqz(b, a, 4096, fs);
%title('Filtr Butterwortha pasmowozaporowy 50 Hz');
end
end


if show

for i = 1:ch_num
if show
    figure('Position', [0, 200, 1400, 400]);  % [x y szerokość wysokość]
end
N = length(data(:,i));       % długość sygnału
f = (0:N-1)*(sampling_frequency/N);       % częstotliwości
Y = fft(data(:,i));          % oblicz FFT

% Oblicz amplitudy i ogranicz do połowy (ze względu na symetrię)
amplitude = abs(Y(1:floor(N/2)));
frequency = f(1:floor(N/2));

 subplot(1, 3,1); 
plot(frequency, amplitude)
xlabel('Częstotliwość (Hz)')
%xlim([0 500]);
ylabel('Amplituda')
title('Widmo sygnału przed filtracją')
grid on



%Filtr pasmowo-przepustowy (10–450 Hz)

fs=sampling_frequency;
[b_band, a_band] = butter(4, passband/(fs/2), 'bandpass'); %rząd filtru
signal_bandpassed = filtfilt(b_band, a_band, data(:,i));

Y = fft(signal_bandpassed);
% Oblicz amplitudy i ogranicz do połowy (ze względu na symetrię)
amplitude = abs(Y(1:floor(N/2)));
frequency = f(1:floor(N/2));
 subplot(1, 3,2); 
plot(frequency, amplitude)
xlabel('Częstotliwość (Hz)')
xlim([0 600]);
ylabel('Amplituda')
title('Widmo sygnału po bandpass filtracją')
grid on



%Filtr wycinający 50Hz lub 60Hz
% 
% % Parametry filtru wycinającego 50 Hz
% notch_center = 60;  % Częstotliwość 50 Hz
% bw = 2;  % Szerokość pasma (można dostosować, np. +/- 1 Hz)
% % Normalizowanie częstotliwości środkowej
% notch_center_normalized = notch_center / (sampling_frequency / 2)  % Dzielimy przez częstotliwość Nyquista
% bw_normalized =bw /(sampling_frequency/2);
% % Tworzymy filtr wycinający 50 Hz
% [b, a]  = designNotchPeakIIR('CenterFrequency', notch_center_normalized, 'Bandwidth', bw_normalized);
% 
% https://www.mathworks.com/help/dsp/ref/designnotchpeakiir.html

% % Zastosowanie filtru do sygnału
% signal_filtered = filtfilt(b,a, data(:,1));
% 
% % Wizualizacja charakterystyki częstotliwościowej filtru
% %fvtool(notchFilter);


fs = sampling_frequency;          % Częstotliwość próbkowania [Hz]
f0 = notch_freq;            % Częstotliwość do usunięcia [Hz]
bandwidth = 5;      % Szerokość pasma zaporowego [Hz]

% Zakres częstotliwości do stłumienia
f_low = f0 - bandwidth/2;
f_high = f0 + bandwidth/2;

% Projektowanie filtra Butterwortha pasmowozaporowego
order = 4;          % Rząd filtra
[b, a] = butter(order, [f_low, f_high]/(fs/2), 'stop');


filtered=filtfilt(b,a,signal_bandpassed);

signal_filtered(:,i)=filtered;


% Charakterystyka częstotliwościowa
%freqz(b, a, 4096, fs);
title('Filtr Butterwortha pasmowozaporowy 50 Hz');




Y = fft(filtered);
% Oblicz amplitudy i ogranicz do połowy (ze względu na symetrię)
amplitude = abs(Y(1:floor(N/2)));
frequency = f(1:floor(N/2));
 subplot(1, 3,3); 
plot(frequency, amplitude)
xlabel('Częstotliwość (Hz)')
xlim([0 600]);
ylabel('Amplituda')
title('Widmo sygnału po bandpass i notch')
grid on



end

end

end