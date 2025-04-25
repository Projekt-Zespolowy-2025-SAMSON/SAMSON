filename = 'features1.csv';
fileDataPath= constructFilePath(1,21,17,6);

%SPRAWDZENIE ŚCIEŻKI PLIKU
checkFile(fileDataPath);

%WYBÓR KANAŁÓW
channels_to_process=1:32;
ch_num = length(channels_to_process);

%CZYTANIE DANYCH 
[data, sampling_frequency,time] = rdsamp(fileDataPath,channels_to_process);

%FILTROWANIE
if ch_num~=1
aver_ref=average_referencing(data,ch_num,0);
end
filtered_data=filters_f(aver_ref,ch_num,sampling_frequency,[10 450],60,0);

%NAGŁÓWKI DO KOLUMN W PLIKU
headers = {'Sample','FR', 'PSR','MDF','MNF','DASDV', 'WL','AAC','MAV','RMS', 'IEMG','ZC', 'PP'};


%%% RAW DATA %%%

    %FR Frequency Ratio
    fr_col = zeros(ch_num,1);
    for i = 1:ch_num
        fr_col(i)=compute_FR(filtered_data(:,i),sampling_frequency,[10 60], [150 350],0);
    end

    %PSR Power spectrum ratio
    psr_col = zeros(ch_num,1);
    for i =1:ch_num
        psr_col(i)=compute_PSR(filtered_data(:,i),sampling_frequency,120,20,0); %320,240,160,120 ??czy to ma związek z przenoszeniem się 60Hz??
    end

    %MDF Median Frequency
    mdf_col = zeros(ch_num,1);
    for i =1:ch_num
        mdf_col(i)=compute_MDF(filtered_data(:,i),sampling_frequency);
    end

    %MNF Mean Frequency
    mnf_col = zeros(ch_num,1);
    for i = 1:ch_num
        mnf_col(i)=compute_MNF(filtered_data(:,i),sampling_frequency);
    end

    %DASDV Difference Absolute Standard Deviation Value
    dasdv_col = zeros(ch_num,1);
    for i = 1:ch_num
        dasdv_col(i)=compute_DASDV(filtered_data(:,i));
    end

    %WL Waveform Length
    wl_col = zeros(ch_num,1);
    for i = 1:ch_num
        abs_diff = abs(diff(filtered_data(:,i)));
        wl_col(i) = sum(abs_diff);
    end

    %AAC Average Amplitude Change
    aac_col = zeros(ch_num,1);
    for i = 1:ch_num
        aac_col(i)=mean(abs(diff(filtered_data(:,i))));
    end

    
%%% WAVELET COMPONENT %%%  D1 Db8  %%%

    %MFL 


%%% WAVELET COMPONENT %%%  D1 Db5  %%%

    %MYOP
    

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
FeatureMatrix=[fr_col,psr_col,mdf_col,mnf_col,dasdv_col, wl_col,aac_col,mav_col,rms_col,iemg_col,zc_col,pp_col];
size(FeatureMatrix)
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