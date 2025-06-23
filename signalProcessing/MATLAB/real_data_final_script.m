
folderPath = 'C:/Users/ppaul/ProjektZespołowy/SAMSON/signalProcessing/MATLAB/Data/dane23_06/wf/';

% Pobranie listy plików .txt w folderze
files = dir(fullfile(folderPath, '*.txt'));


min_lines_threshold = 1328;  % minimalny próg liczby linijek, jak plik ma za mało to go ignoruj


 output_path = 'C:/Users/ppaul/ProjektZespołowy/SAMSON/signalProcessing/MATLAB/Data/dane23_06/3in1_real_features_23_06.csv';
    open_generated_file = 0;
    use_average_referencing = 0;
    separated_output = 0;
    gesture_id=2;


    length(files)
for i = 1:length(files)
    file_path = fullfile(folderPath, files(i).name);
    
    % Otwórz plik i policz linie
    fid = fopen(file_path, 'r');
    if fid == -1
        warning('Nie można otworzyć pliku: %s', files(i).name);
        continue
    end
    
    lineCount = 0;
    while ~feof(fid)
        fgets(fid);
        lineCount = lineCount + 1;
    end
    fclose(fid);
    
    % Sprawdź, czy plik ma wystarczająco dużo linii
    if lineCount < min_lines_threshold
        fprintf('Pomijam plik %s, za mało danych (%d linii)\n', files(i).name, lineCount);
        continue
    end
    
    % Jeśli jest ok, wywołaj funkcję
   
    real_data_features(output_path, file_path, open_generated_file, use_average_referencing, gesture_id, separated_output);
end





















% folderPath = 'C:/Users/ppaul/ProjektZespołowy/SAMSON/signalProcessing/MATLAB/Data/dane23_06/fp/';
% 
% % Pobranie listy plików .txt w folderze
% files = dir(fullfile(folderPath, '*.txt'));
% length(files)
% gesture_id = 1; 
% 
% % Przykład: przejście po wszystkich plikach i wywołanie funkcji
% for i = 1:5
%     file_path = fullfile(folderPath, files(i).name);
% 
%     % % Możesz ustawić resztę parametrów jak wcześniej
%     output_path = 'C:/Users/ppaul/ProjektZespołowy/SAMSON/signalProcessing/MATLAB/Data/dane23_06/TEST_real_features_23_06.csv';
%      open_generated_file = 0;
%      use_average_referencing = 0;
%      separated_output = 0;
%     % 
%     % % Wywołanie Twojej funkcji dla każdego pliku
%    real_data_features(output_path, file_path, open_generated_file, use_average_referencing, gesture_id, separated_output);
% end
% 
% 
% 











































% folderPath = 'C:/Users/ppaul/ProjektZespołowy/SAMSON/signalProcessing/MATLAB/Data/dane17_06/proba3/';
% files={'EMG_1706120835'
%        'EMG_1706121426'
%        'EMG_1706121615'
%        'EMG_1706121647'
% };


% ./proba1:
% EMG_2106184400.txt  EMG_2106184445.txt  EMG_2106184539.txt  EMG_2106184558.txt
% 
% ./proba2:
% EMG_2106185150.txt  EMG_2106185210.txt  EMG_2106185230.txt  EMG_2106185247.txt
% 
% ./proba3:
% EMG_2106194334.txt  EMG_2106194407.txt  fs.png    we.png
% EMG_2106194349.txt  EMG_2106194427.txt  rest.png  wf.png
% 
% ./proba4:
% EMG_2106200536.txt  EMG_2106200614.txt  fs.png    we.png
% EMG_2106200548.txt  EMG_2106200641.txt  rest.png  wf.png

%  folderPath1 = 'C:/Users/ppaul/ProjektZespołowy/SAMSON/signalProcessing/MATLAB/Data/dane21_06/proba1/';
% files1 = {
%     'EMG_2106184400'
%     'EMG_2106184445'
%     'EMG_2106184539'
%     'EMG_2106184558'
% };
% 
%  folderPath2 = 'C:/Users/ppaul/ProjektZespołowy/SAMSON/signalProcessing/MATLAB/Data/dane21_06/proba2/';
% files2 = {
%     'EMG_2106185150'
%     'EMG_2106185210'
%     'EMG_2106185230'
%     'EMG_2106185247'
% };
% 
%  folderPath3 = 'C:/Users/ppaul/ProjektZespołowy/SAMSON/signalProcessing/MATLAB/Data/dane21_06/proba3/';
% files3 = {
%     'EMG_2106194334'
%     'EMG_2106194349'
%     'EMG_2106194407'
%     'EMG_2106194427'
% };
% 
%  folderPath4 = 'C:/Users/ppaul/ProjektZespołowy/SAMSON/signalProcessing/MATLAB/Data/dane21_06/proba4/';
% files4 = {
%     'EMG_2106200536'
%     'EMG_2106200548'
%     'EMG_2106200614'
%     'EMG_2106200641'
% };
% 
% 
%  folderPath5 = 'C:/Users/ppaul/ProjektZespołowy/SAMSON/signalProcessing/MATLAB/Data/dane23_06/proba1/';
% files5 = {
%     'EMG_2306095949'
% };
% 
% 
% % ID gestu (liczba całkowita np. 1 dla pięści, 2 dla otwartej dłoni itd.)
% gesture_id = 1; 
% 
% file_path = fullfile(folderPath5, [files5{gesture_id} '.txt']);
% 
% % Ścieżka do pliku danych (zmień na faktyczną ścieżkę)
% %file_path = 'C:/Users/ppaul/ProjektZespołowy/SAMSON/signalProcessing/MATLAB/Data/dane17_06/proba3/EMG_1706121647.txt';
% 
% %3 kanały dla testów
% %file_path =
% %'C:/Users/ppaul/ProjektZespołowy/SAMSON/signalProcessing/MATLAB/Data/3channels/EMG_1706113012.txt';
% 
% 
% % Ścieżka do zapisu wyjściowego pliku CSV
% output_path = 'C:/Users/ppaul/ProjektZespołowy/SAMSON/signalProcessing/MATLAB/Data/dane21_06/05_real_features_21_06.csv';           
% 
% % Czy otworzyć wynikowy plik po zapisaniu (1 = tak, 0 = nie)
% open_generated_file = 0;                  
% 
% % Czy użyć średniego odniesienia (1 = tak, 0 = nie)
% use_average_referencing = 0;              
% 
% 
% % Czy zapisać w osobnym pliku (1 = tak, 0 = dopisanie do istniejącego)
% separated_output = 1;                     
% 
% % Wywołanie funkcji
% real_data_features(output_path, file_path, open_generated_file, use_average_referencing, gesture_id, separated_output);