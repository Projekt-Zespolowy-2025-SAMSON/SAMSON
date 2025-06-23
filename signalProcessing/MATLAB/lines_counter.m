
folderPath = 'C:/Users/ppaul/ProjektZespołowy/SAMSON/signalProcessing/MATLAB/Data/dane23_06/we/';
files = dir(fullfile(folderPath, '*.txt'));

lineCounts = zeros(length(files),1);

for i = 1:length(files)
    file_path = fullfile(folderPath, files(i).name);
    fid = fopen(file_path, 'r');
    if fid == -1
        warning('Nie można otworzyć pliku: %s', files(i).name);
        lineCounts(i) = NaN;
        continue
    end
    count = 0;
    while ~feof(fid)
        fgets(fid);
        count = count + 1;
    end
    fclose(fid);
    lineCounts(i) = count;
end

% Usuń ewentualne NaN
lineCounts = lineCounts(~isnan(lineCounts));

% Podstawowe statystyki
minLen = min(lineCounts);
maxLen = max(lineCounts);
meanLen = mean(lineCounts);
medianLen = median(lineCounts);

fprintf('Min linii: %d\n', minLen);
fprintf('Max linii: %d\n', maxLen);
fprintf('Średnia linii: %.1f\n', meanLen);
fprintf('Mediana linii: %.1f\n', medianLen);

% Histogram długości
histogram(lineCounts, 30)
xlabel('Liczba linii');
ylabel('Liczba plików');
title('Rozkład długości plików');


% folderPath = 'C:/Users/ppaul/ProjektZespołowy/SAMSON/signalProcessing/MATLAB/Data/dane23_06/fp/';
% 
% fprintf('Gest we:\n');
% 
% 
% files = dir(fullfile(folderPath, '*.txt'));
% 
% numLinesArray = zeros(length(files),1);
% 
% for i = 1:length(files)
%     file_path = fullfile(folderPath, files(i).name);
%     fid = fopen(file_path, 'r');
%     if fid == -1
%         warning('Nie można otworzyć pliku: %s', file_path);
%         numLinesArray(i) = NaN;
%         continue
%     end
% 
%     lineCount = 0;
%     while ~feof(fid)
%         fgets(fid);
%         lineCount = lineCount + 1;
%     end
%     fclose(fid);
%     numLinesArray(i) = lineCount;
% end
% 
% % Usuwamy NaN (jeśli były)
% validLines = numLinesArray(~isnan(numLinesArray));
% 
% maxLines = max(validLines);
% minLines = min(validLines);
% avgLines = mean(validLines);
% 
% maxIdx = find(numLinesArray == maxLines);
% minIdx = find(numLinesArray == minLines);
% 
% fprintf('Najwięcej linii ma plik(y):\n');
% for i = 1:length(maxIdx)
%     fprintf(' %s (%d linii)\n', files(maxIdx(i)).name, maxLines);
% end
% 
% fprintf('\nNajmniej linii ma plik(y):\n');
% for i = 1:length(minIdx)
%     fprintf(' %s (%d linii)\n', files(minIdx(i)).name, minLines);
% end
% 
% fprintf('\nŚrednia liczba linii: %.2f\n', avgLines);
% 
% % Liczymy ile jest powyżej i poniżej średniej
% aboveAvgCount = sum(validLines > avgLines);
% belowAvgCount = sum(validLines < avgLines);
% 
% fprintf('\nLiczba plików z liczbą linii powyżej średniej: %d\n', aboveAvgCount);
% fprintf('Liczba plików z liczbą linii poniżej średniej: %d\n', belowAvgCount);
% 
% % Liczymy ile jest powyżej i poniżej średniej
% 
% below900Count = sum(validLines < 900);
% fprintf('Liczba plików z liczbą linii poniżej 900: %d\n', below900Count);
% 
% 
% 
% 
% below1328Count = sum(validLines < 1328);
% fprintf('Liczba plików z liczbą linii poniżej 1328: %d\n', below1328Count);
% 
% above_x_Count = sum(validLines > 1700);
% fprintf('Liczba plików z liczbą linii powyżej 2500: %d\n', above_x_Count);