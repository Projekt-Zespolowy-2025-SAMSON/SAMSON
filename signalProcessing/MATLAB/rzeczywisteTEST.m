% files = {
%     'EMG2_2205150518'
%     'EMG2_2205153233'
%     'EMG2_2205153359'
%     'EMG2_2205153712'
%     'EMG2_2205154110'
%     'EMG2_2205154544'
%     'EMG2_2205154736'
% };

%files={'EMG_2205132543'};

files={'EMG2_2205154110'};

folderPath = 'C:/Users/ppaul/ProjektZespołowy/SAMSON/signalProcessing/MATLAB/Data/sygnaly/';

% Parametry filtracji
ch_num = 1;
fs = 2000;
passband = [10 450];
notch_freq = 50;
show = 1;

channels_num=1;

save_figures=1;
if save_figures
    % Ścieżka do folderu, gdzie będą zapisywane wykresy
    outputFiguresFolder = 'C:/Users/ppaul/ProjektZespołowy/SAMSON/signalProcessing/MATLAB/Figures/';


    % Utworzenie folderu, jeśli nie istnieje
    if ~exist(outputFiguresFolder, 'dir')
        mkdir(outputFiguresFolder);
    end
end

for i = 1:length(files)
    fileName = [files{i} '.txt'];
    filePath = fullfile(folderPath, fileName);

    if isfile(filePath)
        fprintf('Przetwarzanie pliku: %s\n', fileName);
        data = readmatrix(filePath, 'Delimiter', ';');
        t = (0:length(data)-1)/fs;  % oś czasu w sekundach
        
        if(channels_num ~= 1)
        raw_signal = data(:, ch);  % tylko jedna kolumna
        else
            raw_signal=data;
        end
        filtered_data = filters_f(data, channels_num, fs, passband, notch_freq, show);

        for ch = 1:channels_num  % dla każdego z 3 kanałów
            

            hFig = figure('Name', sprintf('Porównanie: %s (kanał %d)', files{i}, ch), ...
                          'Position', [100, 100, 1000, 400]);

            plot(t, raw_signal, 'r', 'DisplayName', 'Sygnał surowy');
            hold on;
            plot(t, filtered_data(:, ch), 'b', 'DisplayName', 'Sygnał przefiltrowany');
            hold off;

            legend('show');
            xlabel('Czas (s)');
            ylabel('Amplituda');
            title(sprintf('Sygnał przed i po filtracji: %s (kanał %d)', files{i}, ch));
            grid on;



            if(save_figures)
                % Nazwa pliku wyjściowego dla wykresu
                outputFileName = [files{i} '_ch' num2str(ch) '_porownanie.png']; % Np. EMG2_2205150518_porownanie.png
                outputPath = fullfile(outputFiguresFolder, outputFileName);

                % Zapisz wykres
                saveas(hFig, outputPath);

                % Opcjonalnie: Zamknij wykres po zapisaniu, jeśli nie chcesz, by wszystkie były otwarte
                close(hFig);
            end
        end
    end

end
