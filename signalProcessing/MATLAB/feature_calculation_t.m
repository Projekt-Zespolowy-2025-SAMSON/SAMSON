filename = 'features_t.csv';
fileDataPath = 'Data/session1_participant1_gesture10_trial2.hea';

%Test czy ścieżka do pliku z danymi jest poprawna
if exist(fileDataPath, 'file')
    disp('Plik z danymi istnieje.');
else
    disp('Plik z danymi NIE istnieje! Sprawdź ścieżkę.');
end


channels_to_process=[1 2 3 4 7 19];
ch_num = length(channels_to_process);

% Załaduj dane z pliku .dat i .hea
%Dokumentacja rdsamp
% https://archive.physionet.org/physiotools/matlab/wfdb-app-matlab/html/rdsamp.html
% Wczytanie danych
[data, sampling_frequency,time] = rdsamp(fileDataPath,channels_to_process);

% Nagłówki kolumn
headers = {'Sample', 'MAV','RMS', 'IEMG','ZC', 'PP'};

%MAV Mean Absolute Value
mav_col = zeros(ch_num,1);
for i =1:ch_num
mav_col(i)=mean(abs(data(:,i)));
end

%RMS Root Mean Square
rms_col = zeros(ch_num,1);
for i =1:ch_num
rms_col(i)=rms(data(:,i));
end

%IEMG Integrated EMG
iemg_col = zeros(ch_num,1);
for i =1:ch_num
iemg_col(i)=sum(abs(data(:,i)));
end

%ZC Zero Crossings
zc_col = zeros(ch_num,1);
for i =1:ch_num
    current_channel_data=data(:,i);
zc_col(i)=sum(current_channel_data(1:end-1) .* current_channel_data(2:end) < 0);
end

%PP Peak to Peak
pp_col = zeros(ch_num,1);
for i =1:ch_num
pp_col(i)=sum(max(data(:,i))-min(data(:,i)));
end

FeatureMatrix=[mav_col,rms_col,iemg_col,zc_col,pp_col];

% Generowanie etykiet danych
Labels = cell(ch_num,1);

for i = 1:ch_num
    Labels{i} = sprintf('CH%d', channels_to_process(i));
end

% Łączenie cech z etykietami
FeatureMatrixWithLabels = [Labels,num2cell(FeatureMatrix)];

% Zapis do pliku CSV z odpowiednim separatorem
%jeśli w excelu nie dzieli się na kolumny to należy zamienić separator np.
%na ',' lub takie jak jest w systemie

writecell([headers; FeatureMatrixWithLabels], filename, 'Delimiter', ';');

% Potwierdzenie zapisu
fprintf('Dane zostały zapisane do pliku %s.\n',filename);

fprintf('Otwieram plik %s.\n',filename);
winopen(filename);  % Automatyczne otwarcie pliku w Excelu dla Windows
