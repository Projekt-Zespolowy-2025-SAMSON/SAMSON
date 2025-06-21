function [signal_filtered] = filters_f(data, ch_num, sampling_frequency, passband, notch_freqs, show)
signal_filtered = zeros(size(data));
fs = sampling_frequency;

outputFolder = 'C:/Users/ppaul/ProjektZespołowy/SAMSON/signalProcessing/MATLAB/Data/dane21_06/Charakterystyki_czestotliwosciowe';
% Parametry filtrów
order = 4;               % Rząd filtra
bandwidth = 7;           % Szerokość pasma zaporowego [Hz]

% Filtr pasmowo-przepustowy Butterwortha
[b_band, a_band] = butter(order, passband/(fs/2), 'bandpass');

% Projektowanie filtrów zaporowych (notch)
b_notch_all = {};
a_notch_all = {};
for nf = notch_freqs
    f_low = nf - bandwidth/2;
    f_high = nf + bandwidth/2;
    [b_notch, a_notch] = butter(order, [f_low, f_high]/(fs/2), 'stop');
    b_notch_all{end+1} = b_notch;
    a_notch_all{end+1} = a_notch;
end

% Przetwarzanie każdego kanału
for i = 1:ch_num
    % Filtrowanie pasmowo-przepustowe
    signal_bandpassed = filtfilt(b_band, a_band, data(:,i));

    % Kolejne filtrowanie zaporowe dla każdej częstotliwości
    filtered = signal_bandpassed;
    for k = 1:length(notch_freqs)
        filtered = filtfilt(b_notch_all{k}, a_notch_all{k}, filtered);
    end

    signal_filtered(:,i) = filtered;

    % WIZUALIZACJA
    if show
        figure('Position', [0, 200, 1400, 400]);

        N = length(data(:,i));
        f = (0:N-1)*(fs/N);

        % Widmo przed filtracją
        Y_raw = fft(data(:, i));
        amplitude_spectrum_raw = abs(Y_raw(1:floor(N/2)));
        subplot(1, 3, 1);
        plot(f(1:floor(N/2)), amplitude_spectrum_raw);
        xlim([0 600]);
        ylim([0 30000]);
        xlabel('Częstotliwość (Hz)');
        ylabel('Amplituda');
        title('Widmo sygnału przed filtracją');
        grid on;
        hold on;
        line([passband(1) passband(1)], ylim, 'Color', 'r', 'LineStyle', '--');
        line([passband(2) passband(2)], ylim, 'Color', 'r', 'LineStyle', '--');
        for nf = notch_freqs
            line([nf nf], ylim, 'Color', 'g', 'LineStyle', '--');
        end
        hold off;

        % Widmo po filtrze pasmowo-przepustowym
        Y_band = fft(signal_bandpassed);
        subplot(1, 3, 2);
        plot(f(1:floor(N/2)), abs(Y_band(1:floor(N/2))));
        xlim([0 600]);
        xlabel('Częstotliwość (Hz)');
        ylabel('Amplituda');
        title('Po filtrze pasmowo-przepustowym');
        grid on;
        hold on;
        line([passband(1) passband(1)], ylim, 'Color', 'r', 'LineStyle', '--');
        line([passband(2) passband(2)], ylim, 'Color', 'r', 'LineStyle', '--');
        for nf = notch_freqs
            line([nf nf], ylim, 'Color', 'g', 'LineStyle', '--');
        end
        hold off;

        % Widmo po wszystkich filtrach
        Y_filtered = fft(filtered);
        subplot(1, 3, 3);
        plot(f(1:floor(N/2)), abs(Y_filtered(1:floor(N/2))));
        xlim([0 600]);
        xlabel('Częstotliwość (Hz)');
        ylabel('Amplituda');
        title('Po filtrze bandpass i notch');
        grid on;
        hold on;
        line([passband(1) passband(1)], ylim, 'Color', 'r', 'LineStyle', '--');
        line([passband(2) passband(2)], ylim, 'Color', 'r', 'LineStyle', '--');
        for nf = notch_freqs
            line([nf nf], ylim, 'Color', 'g', 'LineStyle', '--');
        end
        hold off;
        % 
        % figName = fullfile(outputFolder, sprintf('figure_%d.png', i));
        % saveas(gcf, figName);

        % Szukanie wolnej nazwy pliku
fileIndex = 1;
while true
    figName = fullfile(outputFolder, sprintf('figure_%d.png', fileIndex));
    if ~exist(figName, 'file')
        break;
    end
    fileIndex = fileIndex + 1;
end

% Zapis figury
saveas(gcf, figName);
    end
end

end