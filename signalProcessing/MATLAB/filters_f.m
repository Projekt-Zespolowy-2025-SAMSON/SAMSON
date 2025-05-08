function [signal_filtered] = filters_f(data,ch_num,sampling_frequency,passband,notch_freq,show)
signal_filtered = zeros(size(data));
fs=sampling_frequency;
f0=notch_freq;

% Projektowanie filtra Butterwortha pasmowoprzepustowego
order = 4;          % Rząd filtra
[b_band, a_band] = butter(4, passband/(fs/2), 'bandpass');

% Projektowanie filtra Butterwortha pasmowozaporowego - wycinający 50Hz lub 60Hz
bandwidth = 5;      % Szerokość pasma zaporowego [Hz]

f_low = f0 - bandwidth/2;   % Zakres częstotliwości do stłumienia
f_high = f0 + bandwidth/2;

[b_notch, a_notch] = butter(order, [f_low, f_high]/(fs/2), 'stop');


for i = 1:ch_num
    % FILTROWANIE
    signal_bandpassed = filtfilt(b_band, a_band, data(:,i));
    filtered=filtfilt(b_notch,a_notch,signal_bandpassed);
    signal_filtered(:,i)=filtered;


    % WIZUALIZACJA
    if show
        figure('Position', [0, 200, 1400, 400]);   % [x y szerokość wysokość]

        N = length(data(:,i));       % długość sygnału
        f = (0:N-1)*(sampling_frequency/N);       % częstotliwość


        % Widmo przed filtracją
        Y_raw = fft(data(:, i));
        subplot(1, 3, 1);
        plot(f(1:floor(N/2)), abs(Y_raw(1:floor(N/2))));
        xlim([0 600]);
        xlabel('Częstotliwość (Hz)');
        ylabel('Amplituda');
        title('Widmo sygnału przed filtracją');
        grid on;

% Zaznaczenie granic pasma przepustowego
hold on;
line([passband(1) passband(1)], ylim, 'Color', 'r', 'LineStyle', '--'); % dolna granica pasma
line([passband(2) passband(2)], ylim, 'Color', 'r', 'LineStyle', '--'); % górna granica pasma


% Zaznaczenie częstotliwości wycinanej (np. 50 Hz dla notch)
line([notch_freq notch_freq], ylim, 'Color', 'g', 'LineStyle', '--'); % Częstotliwość wycinana
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
% Zaznaczenie granic pasma przepustowego
hold on;
line([passband(1) passband(1)], ylim, 'Color', 'r', 'LineStyle', '--'); % dolna granica pasma
line([passband(2) passband(2)], ylim, 'Color', 'r', 'LineStyle', '--'); % górna granica pasma


% Zaznaczenie częstotliwości wycinanej (np. 50 Hz dla notch)
line([notch_freq notch_freq], ylim, 'Color', 'g', 'LineStyle', '--'); % Częstotliwość wycinana
hold off;

        % Widmo po filtrze zaporowym

        Y_filtered = fft(filtered);
        subplot(1, 3, 3);
        plot(f(1:floor(N/2)), abs(Y_filtered(1:floor(N/2))));
        xlim([0 600]);
        xlabel('Częstotliwość (Hz)');
        ylabel('Amplituda');
        title('Po filtrze bandpass i notch');
        grid on;

        % Zaznaczenie granic pasma przepustowego
hold on;
line([passband(1) passband(1)], ylim, 'Color', 'r', 'LineStyle', '--'); % dolna granica pasma
line([passband(2) passband(2)], ylim, 'Color', 'r', 'LineStyle', '--'); % górna granica pasma


% Zaznaczenie częstotliwości wycinanej (np. 50 Hz dla notch)
line([notch_freq notch_freq], ylim, 'Color', 'g', 'LineStyle', '--'); % Częstotliwość wycinana
hold off;

        % Charakterystyki filtrów
        fvtool(b_band, a_band, 'Fs', fs); % pasmowo-przepustowy
        fvtool(b_notch, a_notch, 'Fs', fs); % zaporowy

    end

end

end