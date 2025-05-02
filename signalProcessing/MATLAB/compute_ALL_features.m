filename = 'features1.csv';
fileDataPath= constructFilePath(1,11,2,6);

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
headers = {'Sample','FR', 'PSR','MDF','MNF','DASDV', 'WL','AAC', 'MFL', 'MYOP', 'SM2','SM3','V2','V3','RMS', 'LOG', 'SM1','MMAV','VAR','SSI','TTP', 'MNP','MAV','IEMG','WAMP','ZC'};


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

    %MFL Maximum Fractal Length
    decomposition_level=1;
    wavelet_type='db8';
    mfl_col = zeros(ch_num,1);
    for i = 1:ch_num
        mfl_col(i)=compute_MFL(filtered_data(:,i),decomposition_level,wavelet_type);
    end

%%% WAVELET COMPONENT %%%  D1 Db5  %%%

    %MYOP Myopulse Percentage Rate
    decomposition_level=1;
    wavelet_type='db5';
    myop_col = zeros(ch_num,1);
    for i = 1:ch_num
        myop_col(i)=compute_MYOP(filtered_data(:,i),decomposition_level,wavelet_type,0.1);
    end

%%% WAVELET COMPONENT %%%  cD1 Db10  %%%

    %SM3 3rd Spectral Moment
    %      and
    %SM2 2nd Spectral Moment

    decomposition_level=1;
    wavelet_type='db10';
    sm3_col = zeros(ch_num,1);
    sm2_col = zeros(ch_num,1);
    for i = 1:ch_num
       [sm2_col(i),sm3_col(i)]=compute_SM2_SM3(filtered_data(:,i),decomposition_level,wavelet_type);
    end

    %V2 V33 v-Order 2 and 3
   
    wavelet_type='db10';

    v2_col = zeros(ch_num,1);
    v3_col = zeros(ch_num,1);
   
    for i = 1:ch_num
       [v2_col(i),v3_col(i)]=compute_V2_V3(filtered_data(:,i),wavelet_type);
    end

    
    %RMS Root Mean Square
    rms_col = zeros(ch_num,1);
    for i =1:ch_num
    rms_col(i)=compute_RMS(filtered_data(:,i),1,'db10');
    end

%%% WAVELET COMPONENT %%%  D2 Db7  %%%
    wavelet_type='db7';
    decomposition_level=2;

   

    %LOG Log Detector
    log_col = zeros(ch_num,1);
    for i =1:ch_num
    log_col(i)=compute_LOG(filtered_data(:,i),decomposition_level,wavelet_type);
    end

    %SM1 1st Spectral Moment
    sm1_col = zeros(ch_num,1);
    for i =1:ch_num
    sm1_col(i)=compute_SM1(filtered_data(:,i),decomposition_level,wavelet_type,sampling_frequency);
    end

    %MMAV Modified Mean Absolute Value
    mmav_col = zeros(ch_num,1);
    for i =1:ch_num
    mmav_col(i)=compute_MMAV(filtered_data(:,i),decomposition_level,wavelet_type);
    end

    %VAR Variance of EMG
    var_col = zeros(ch_num,1);
    for i =1:ch_num
    var_col(i)=compute_VAR(filtered_data(:,i),decomposition_level,wavelet_type);
    end

    %SSI Simple Square Integral
    ssi_col = zeros(ch_num,1);
    for i =1:ch_num
    ssi_col(i)=compute_SSI(filtered_data(:,i),decomposition_level,wavelet_type);
    end

    %TTP Total Power
    ttp_col = zeros(ch_num,1);
    for i =1:ch_num
    [C, L] = wavedec(filtered_data(:,i), decomposition_level, wavelet_type);
    D2 = detcoef(C, L, 2);
    ttp_col(i)=sum(D2.^2);
    end

    %MNP Mean Power
    mnp_col = zeros(ch_num,1);
    for i =1:ch_num
     [C, L] = wavedec(filtered_data(:,i), decomposition_level, wavelet_type);
     D2 = detcoef(C, L, 2);
     D2_normalized = D2 / max(abs(D2));

     [pxx, f] = periodogram(D2_normalized, [], [], sampling_frequency);
      mnp_col(i) = mean(pxx);
   %  mnp_col(i)=mean(D2_normalized.^2);
    end

  %MAV Mean Absolute Value
    mav_col = zeros(ch_num,1);
    for i =1:ch_num
     [C, L] = wavedec(filtered_data(:,i), decomposition_level, wavelet_type);
     D2 = detcoef(C, L, 2);
     D2_normalized = D2 / max(abs(D2));
    mav_col(i)=mean(abs(D2_normalized));
    end
  
  
    %IEMG Integrated EMG
    iemg_col = zeros(ch_num,1);
    for i =1:ch_num
        [C, L] = wavedec(filtered_data(:,i), decomposition_level, wavelet_type);
        D2 = detcoef(C, L, 2);
        D2_normalized = D2 / max(abs(D2));
        iemg_col(i)=sum(abs(D2_normalized));
    end

    %WAMP Willison Amplitude
    wamp_col = zeros(ch_num,1);
    for i =1:ch_num
        [C, L] = wavedec(filtered_data(:,i), decomposition_level, wavelet_type);
         D2 = detcoef(C, L, 2);
         D2_normalized = D2 / max(abs(D2));
         threshold=(max(D2_normalized)-min(D2_normalized)) *0.1;
         differences = abs(diff(D2_normalized));
        wamp_col(i)=sum(differences>=threshold);
    end

    %ZC Zero Crossings
    zc_col = zeros(ch_num,1);
    for i =1:ch_num
        [C, L] = wavedec(filtered_data(:,i), decomposition_level, wavelet_type);
         D2 = detcoef(C, L, 2);
         D2_normalized = D2 / max(abs(D2));
        zc_col(i)=sum(D2_normalized(1:end-1) .* D2_normalized(2:end) < 0);
    end



%ŁĄCZENIE KOLUMN CECH
FeatureMatrix=[fr_col,psr_col,mdf_col,mnf_col,dasdv_col, wl_col,aac_col,mfl_col, myop_col, sm2_col,sm3_col,v2_col,v3_col,rms_col, log_col, sm1_col,mmav_col, var_col,ssi_col, ttp_col, mnp_col, mav_col,iemg_col,wamp_col,zc_col];
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