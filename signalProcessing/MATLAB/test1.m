filePath = 'Data/session1_participant1_gesture10_trial2.hea';

if exist(filePath, 'file')
    disp('Plik istnieje.');
else
    disp('Plik NIE istnieje! Sprawdź ścieżkę.');
end


% Załaduj dane z pliku .dat i .hea
[data, fields] = rdsamp('/Data/session1_participant1_gesture10_trial2.hea', [], 0); 

% 'data' to macierz zawierająca wartości sygnałów
% 'fields' zawiera metadane

% Wyświetlanie metadanych
%[header, units] = rdheader('/Data/session1_participant1_gesture10_trial2.hea');

% % Wyświetlenie pierwszych 10 próbek dla pierwszego kanału
% disp(data(1:10, 1));


% Wczytanie danych
[data, fields] = rdsamp(filePath);

% Odczytanie kanału 7 (kolumna 7 w macierzy data)
channel_7_data = data(:, 7);

% % Rysowanie wykresu całego sygnału (10240 próbek)
% figure;
% plot(channel_7_data);
% xlabel('Numer próbki');
% ylabel('Amplituda EMG');
% title('Sygnał EMG z kanału 7 - Wszystkie próbki');
% grid on;
% %xlim([0 2000]); % Ogranicza wykres do próbek 0-2000


figure('Name', 'Sygnały EMG F1-F16');
for i = 1:16
    subplot(4, 4, i); % Tworzy układ 6x3
    plot(data(:, i)); % Rysuje kanał i
    title(sprintf('Kanał F%d', i));
    xlabel('Numer próbki');
    ylabel('Amplituda');
    grid on;
end
sgtitle('Sygnały EMG F1-F16'); % Tytuł całej figury



figure('Name', 'Sygnały EMG F17-F32');

for i = 17:32
    subplot(4, 4, i-16); % Tworzy układ 6x3
    plot(data(:, i)); % Rysuje kanał i
    title(sprintf('Kanał F%d', i));
    xlabel('Numer próbki');
    ylabel('Amplituda');
    grid on;
end
sgtitle('Sygnały EMG F17-F32'); % Tytuł całej figury

