files = {
    'EMG2_2205150518'
    'EMG2_2205153233'
    'EMG2_2205153359'
    'EMG2_2205153712'
    'EMG2_2205154110'
    'EMG2_2205154544'
    'EMG2_2205154736'
};

folderPath = 'C:/Users/ppaul/ProjektZespołowy/SAMSON/signalProcessing/MATLAB/Data/sygnaly/';

% Parametry filtracji
ch_num = 1;
fs = 2000;
passband = [10 450];
notch_freq = 50;
show = 1; 

% Ścieżka do folderu, gdzie będą zapisywane wykresy
outputFiguresFolder = 'C:/Users/ppaul/ProjektZespołowy/SAMSON/signalProcessing/MATLAB/Data/sygnaly/Figures/';

% Utworzenie folderu, jeśli nie istnieje
if ~exist(outputFiguresFolder, 'dir')
    mkdir(outputFiguresFolder);
end


for i = 1:length(files)
    fileName = [files{i} '.txt'];
    filePath = fullfile(folderPath, fileName);
    
    if isfile(filePath)
        fprintf('Przetwarzanie pliku: %s\n', fileName);
        
        data = load(filePath);
        filtered_data = filters_f(data, ch_num, fs, passband, notch_freq, show);

        t = (0:length(data)-1)/fs;  % oś czasu w sekundach

        hFig=figure('Name', ['Porównanie: ' files{i}], 'Position', [100, 100, 1000, 400]);
        plot(t, data, 'r', 'DisplayName', 'Sygnał surowy');
        hold on;
        plot(t, filtered_data, 'b', 'DisplayName', 'Sygnał przefiltrowany');
        hold off;
        legend('show');
        xlabel('Czas (s)');
        ylabel('Amplituda');
        title(['Sygnał przed i po filtracji: ' files{i}]);
        grid on;



         % Nazwa pliku wyjściowego dla wykresu
        outputFileName = [files{i} '_porownanie.png']; % Np. EMG2_2205150518_porownanie.png
        outputPath = fullfile(outputFiguresFolder, outputFileName);
        
        % Zapisz wykres
        saveas(hFig, outputPath);
        
        % Opcjonalnie: Zamknij wykres po zapisaniu, jeśli nie chcesz, by wszystkie były otwarte
        close(hFig);
    end
end
