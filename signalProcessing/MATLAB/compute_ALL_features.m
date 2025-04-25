filename = 'features.csv';
fileDataPath = 'Data/session1_participant34/session1_participant34_gesture17_trial2.hea';
%fileDataPath ='C:/users/ppaul/Desktop/MatlabEMG/gesture-recognition-and-biometrics-electromyogram-grabmyo-1.1.0/Session1/session1_participant9/session1_participant9_gesture3_trial2.hea';

%fileDataPath ='C:\users\ppaul\Desktop\MatlabEMG\gesture-recognition-and-biometrics-electromyogram-grabmyo-1.1.0\Session1\session1_participant9\session1_participant9_gesture3_trial2.hea';
fileTEST = constructFilePath(1,21,3,4)
checkFile(fileTEST);

%SPRAWDZENIE ŚCIEŻKI PLIKU
checkFile(fileDataPath);

%WYBÓR KANAŁÓW
channels_to_process=1:4;
ch_num = length(channels_to_process);

%CZYTANIE DANYCH 
[data, sampling_frequency,time] = rdsamp(fileDataPath,channels_to_process);

%FILTROWANIE
if ch_num~=1
aver_ref=average_referencing(data,ch_num,0);
end
filtered_data=filters_f(aver_ref,ch_num,sampling_frequency,[5 450],60,0);

%NAGŁÓWKI DO KOLUMN W PLIKU
headers = {'Sample','FR', 'MAV','RMS', 'IEMG','ZC', 'PP'};


%%% RAW DATA %%%

    %FR Frequency Ratio
    
    fr_col = zeros(ch_num,1);
    for i = 1:ch_num
    fr_col(i)=compute_FR(filtered_data(:,i),sampling_frequency,[20 50], [100 300],0);
    end



    %MAV Mean Absolute Value
mav_col = zeros(ch_num,1);
for i =1:ch_num
mav_col(i)=mean(abs(filtered_data(:,i)));
end

    %RMS Root Mean Square
rms_col = zeros(ch_num,1);
for i =1:ch_num
rms_col(i)=rms(filtered_data(:,i));
end

    %IEMG Integrated EMG
iemg_col = zeros(ch_num,1);
for i =1:ch_num
iemg_col(i)=sum(abs(filtered_data(:,i)));
end

    %ZC Zero Crossings
zc_col = zeros(ch_num,1);
for i =1:ch_num
    current_channel_data=filtered_data(:,i);
zc_col(i)=sum(current_channel_data(1:end-1) .* current_channel_data(2:end) < 0);
end

    %PP Peak to Peak
pp_col = zeros(ch_num,1);
for i =1:ch_num
pp_col(i)=sum(max(filtered_data(:,i))-min(filtered_data(:,i)));
end

%ŁĄCZENIE KOLUMN CECH
FeatureMatrix=[mav_col,fr_col,rms_col,iemg_col,zc_col,pp_col];

%GENEROWANIE ETYKIET DANYCH - KANAŁY
Labels = cell(ch_num,1);
for i = 1:ch_num
    Labels{i} = sprintf('CH%d', channels_to_process(i));
end

%ŁĄCZENIE ETYKIET I DANYCH
FeatureMatrixWithLabels = [Labels,num2cell(FeatureMatrix)];

%ZAPIS DO PLIKU CSV (z odpowiednim separatorem)
%jeśli w excelu nie dzieli się na kolumny to należy zamienić separator np.
%na ',' lub takie jak jest w systemie

writecell([headers; FeatureMatrixWithLabels], filename, 'Delimiter', ';');
fprintf('Dane zostały zapisane do pliku %s.\n',filename);

%AUTOMATYCZNE OTWORZENIE PLIKU
fprintf('Otwieram plik %s.\n',filename);
winopen(filename);  % Automatyczne otwarcie pliku w Excelu dla Windows