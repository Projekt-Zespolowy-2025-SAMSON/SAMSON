filename = 'features_t2.csv';
fileDataPath = 'Data/session1_participant1_gesture10_trial2.hea';

checkFile(fileDataPath);

channels_to_process=[1 2 3 17];
ch_num = length(channels_to_process);

% Załaduj dane z pliku .dat i .hea
%Dokumentacja rdsamp
% https://archive.physionet.org/physiotools/matlab/wfdb-app-matlab/html/rdsamp.html
% Wczytanie danych  %time to wektor czasu 
[data, sampling_frequency,time] = rdsamp(fileDataPath,channels_to_process);
  
    if ch_num~=1
aver_ref=average_referencing(data,ch_num,0);
    end
filtered_data=filters_f(aver_ref,ch_num,sampling_frequency,[10 450],60,0);

%filtered_data=data;

% Nagłówki kolumn
headers = {'Sample', 'MAV','RMS', 'IEMG','ZC', 'PP'};

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

for i =1:ch_num
%normalizacja
norm=normalizeToMinusOneToOne(filtered_data(:,i));
end

norm=normalizeToMinusOneToOne(filtered_data(:,1));
figure;
 plot(norm); % Rysuje kanał i
    title(sprintf('Kanał F%d', i));
    xlabel('Numer próbki');
    ylabel('Amplituda');
    grid on;

    figure;
 plot(data(:,1)); % Rysuje kanał i
    title(sprintf('Kanał F%d', i));
    xlabel('Numer próbki');
    ylabel('Amplituda');
    grid on;


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
%winopen(filename);  % Automatyczne otwarcie pliku w Excelu dla Windows
