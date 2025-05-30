filename = 'features1.csv';
fileDataPath= constructFilePath(1,11,2,6);

%SPRAWDZENIE ŚCIEŻKI PLIKU
checkFile(fileDataPath);

%WYBÓR KANAŁÓW
channels_to_process=1:32;
ch_num = length(channels_to_process);

%CZYTANIE DANYCH 
[data, sampling_frequency,time] = rdsamp(fileDataPath,channels_to_process);

sampling_frequency;

%FILTROWANIE
if ch_num~=1
aver_ref=average_referencing(data,ch_num,0);
end
filtered_data_all=filters_f(aver_ref,ch_num,sampling_frequency,[10 450],60,0);

%PODZIAŁ NA OKNA
window_size = round(200 * sampling_frequency / 1000);   % 200 ms = 410 próbek
step_size = round(100 * sampling_frequency / 1000);   % 50 ms = 102 próbki, 100ms = 204 próbki
N = size(filtered_data_all, 1); % liczba próbek
%ch_num = size(filtered_data, 2); % liczba kanałów
% Liczymy liczbę okien
num_windows = floor((N - window_size) / step_size) + 1;
row_num=ch_num*num_windows;

%NAGŁÓWKI DO KOLUMN W PLIKU
headers = {'Sample','FR', 'PSR','MDF','MNF','DASDV', 'WL','AAC', 'MFL', 'MYOP', 'SM2','SM3','V2','V3','RMS', 'LOG', 'SM1','MMAV','VAR','SSI','TTP', 'MNP','MAV','IEMG','WAMP','ZC'};

fr_col = zeros(row_num,1);
psr_col = zeros(row_num,1);
mdf_col = zeros(row_num,1);
mnf_col = zeros(row_num,1);
dasdv_col = zeros(row_num,1);
wl_col = zeros(row_num,1);
aac_col = zeros(row_num,1);
mfl_col = zeros(row_num,1);
myop_col = zeros(row_num,1);
sm3_col = zeros(row_num,1);
sm2_col = zeros(row_num,1);
v2_col = zeros(row_num,1);
v3_col = zeros(row_num,1);
rms_col = zeros(row_num,1);
log_col = zeros(row_num,1);
sm1_col = zeros(row_num,1);
mmav_col = zeros(row_num,1);
var_col = zeros(row_num,1);
ssi_col = zeros(row_num,1);
ttp_col = zeros(row_num,1);
mnp_col = zeros(row_num,1);
mav_col = zeros(row_num,1);
iemg_col = zeros(row_num,1);
wamp_col = zeros(row_num,1);
zc_col = zeros(row_num,1);

for window_idx = 1:num_windows
    start_idx = (window_idx - 1) * step_size + 1;
    end_idx = start_idx + window_size - 1;
    
    % Wyciąganie danych dla okna
    filtered_data = filtered_data_all(start_idx:end_idx, :);
%%% RAW DATA %%%

    %FR Frequency Ratio
    for i = 1:ch_num
         %fprintf("FR ch=%d window %d i %d\n",i,window_idx,i+(window_idx-1)*ch_num);
         idx=i+((window_idx-1)*ch_num);
        fr_col(idx)=compute_FR(filtered_data(:,i),sampling_frequency,[10 60], [150 350],0);
    end

    %PSR Power spectrum ratio
    for i =1:ch_num
        idx=i+((window_idx-1)*ch_num);
        psr_col(idx)=compute_PSR(filtered_data(:,i),sampling_frequency,120,20,0); %320,240,160,120 ??czy to ma związek z przenoszeniem się 60Hz??
    end

    %MDF Median Frequency
   
    for i =1:ch_num
        idx=i+((window_idx-1)*ch_num);
        mdf_col(idx)=compute_MDF(filtered_data(:,i),sampling_frequency);
    end

    %MNF Mean Frequency
    
    for i = 1:ch_num
        idx=i+((window_idx-1)*ch_num);
        mnf_col(idx)=compute_MNF(filtered_data(:,i),sampling_frequency);
    end

    %DASDV Difference Absolute Standard Deviation Value
   
    for i = 1:ch_num
        idx=i+((window_idx-1)*ch_num);
        dasdv_col(idx)=compute_DASDV(filtered_data(:,i));
    end

    %WL Waveform Length
    
    for i = 1:ch_num
        idx=i+((window_idx-1)*ch_num);
        abs_diff = abs(diff(filtered_data(:,i)));
        wl_col(idx) = sum(abs_diff);
    end

    %AAC Average Amplitude Change
   
    for i = 1:ch_num
        idx=i+((window_idx-1)*ch_num);
        aac_col(idx)=mean(abs(diff(filtered_data(:,i))));
    end

    
%%% WAVELET COMPONENT %%%  D1 Db8  %%%

    %MFL Maximum Fractal Length
    decomposition_level=1;
    wavelet_type='db8';
   
    for i = 1:ch_num
        idx=i+((window_idx-1)*ch_num);
        mfl_col(idx)=compute_MFL(filtered_data(:,i),decomposition_level,wavelet_type);
    end

%%% WAVELET COMPONENT %%%  D1 Db5  %%%

    %MYOP Myopulse Percentage Rate
    decomposition_level=1;
    wavelet_type='db5';
   
    for i = 1:ch_num
        idx=i+((window_idx-1)*ch_num);
        myop_col(idx)=compute_MYOP(filtered_data(:,i),decomposition_level,wavelet_type,0.1);
    end

%%% WAVELET COMPONENT %%%  cD1 Db10  %%%

    %SM3 3rd Spectral Moment
    %      and
    %SM2 2nd Spectral Moment

    decomposition_level=1;
    wavelet_type='db10';
    
    for i = 1:ch_num
        idx=i+((window_idx-1)*ch_num);
       [sm2_col(idx),sm3_col(idx)]=compute_SM2_SM3(filtered_data(:,i),decomposition_level,wavelet_type);
    end

    %V2 V33 v-Order 2 and 3
   
    wavelet_type='db10';

   
    for i = 1:ch_num
        idx=i+((window_idx-1)*ch_num);
       [v2_col(idx),v3_col(idx)]=compute_V2_V3(filtered_data(:,i),wavelet_type);
    end

    
    %RMS Root Mean Square
   
    for i =1:ch_num
        idx=i+((window_idx-1)*ch_num);
    rms_col(idx)=compute_RMS(filtered_data(:,i),1,'db10');
    end

%%% WAVELET COMPONENT %%%  D2 Db7  %%%
    wavelet_type='db7';
    decomposition_level=2;

   

    %LOG Log Detector
   
    for i =1:ch_num
        idx=i+((window_idx-1)*ch_num);
    log_col(idx)=compute_LOG(filtered_data(:,i),decomposition_level,wavelet_type);
    end

    %SM1 1st Spectral Moment
   
    for i =1:ch_num
        idx=i+((window_idx-1)*ch_num);
    sm1_col(idx)=compute_SM1(filtered_data(:,i),decomposition_level,wavelet_type,sampling_frequency);
    end

    %MMAV Modified Mean Absolute Value
   
    for i =1:ch_num
        idx=i+((window_idx-1)*ch_num);
    mmav_col(idx)=compute_MMAV(filtered_data(:,i),decomposition_level,wavelet_type);
    end

    %VAR Variance of EMG
   
    for i =1:ch_num
        idx=i+((window_idx-1)*ch_num);
    var_col(idx)=compute_VAR(filtered_data(:,i),decomposition_level,wavelet_type);
    end

    %SSI Simple Square Integral
   
    for i =1:ch_num
        idx=i+((window_idx-1)*ch_num);
    ssi_col(idx)=compute_SSI(filtered_data(:,i),decomposition_level,wavelet_type);
    end

    %TTP Total Power
  
    for i =1:ch_num
        idx=i+((window_idx-1)*ch_num);
    [C, L] = wavedec(filtered_data(:,i), decomposition_level, wavelet_type);
    D2 = detcoef(C, L, 2);
    ttp_col(idx)=sum(D2.^2);
    end

    %MNP Mean Power
   
    for i =1:ch_num
        idx=i+((window_idx-1)*ch_num);
     [C, L] = wavedec(filtered_data(:,i), decomposition_level, wavelet_type);
     D2 = detcoef(C, L, 2);
     D2_normalized = D2 / max(abs(D2));

     [pxx, f] = periodogram(D2_normalized, [], [], sampling_frequency);
      mnp_col(idx) = mean(pxx);
   %  mnp_col(i)=mean(D2_normalized.^2);
    end

  %MAV Mean Absolute Value
  
    for i =1:ch_num
        idx=i+((window_idx-1)*ch_num);
     [C, L] = wavedec(filtered_data(:,i), decomposition_level, wavelet_type);
     D2 = detcoef(C, L, 2);
     D2_normalized = D2 / max(abs(D2));
    mav_col(idx)=mean(abs(D2_normalized));
    end
  
  
    %IEMG Integrated EMG
   
    for i =1:ch_num
        idx=i+((window_idx-1)*ch_num);
        [C, L] = wavedec(filtered_data(:,i), decomposition_level, wavelet_type);
        D2 = detcoef(C, L, 2);
        D2_normalized = D2 / max(abs(D2));
        iemg_col(idx)=sum(abs(D2_normalized));
    end

    %WAMP Willison Amplitude
  
    for i =1:ch_num
        idx=i+((window_idx-1)*ch_num);
        [C, L] = wavedec(filtered_data(:,i), decomposition_level, wavelet_type);
         D2 = detcoef(C, L, 2);
         D2_normalized = D2 / max(abs(D2));
         threshold=(max(D2_normalized)-min(D2_normalized)) *0.1;
         differences = abs(diff(D2_normalized));
        wamp_col(idx)=sum(differences>=threshold);
    end

    %ZC Zero Crossings
   
    for i =1:ch_num
        idx=i+((window_idx-1)*ch_num);
        [C, L] = wavedec(filtered_data(:,i), decomposition_level, wavelet_type);
         D2 = detcoef(C, L, 2);
         D2_normalized = D2 / max(abs(D2));
        zc_col(idx)=sum(D2_normalized(1:end-1) .* D2_normalized(2:end) < 0);
    end


end
%ŁĄCZENIE KOLUMN CECH
size(psr_col)

% FeatureMatrix=[fr_col,psr_col,mdf_col,mnf_col,dasdv_col, wl_col,aac_col,mfl_col, myop_col, sm2_col,sm3_col,v2_col,v3_col,rms_col, log_col, sm1_col,mmav_col, var_col,ssi_col, ttp_col, mnp_col, mav_col,iemg_col,wamp_col,zc_col];
% size(FeatureMatrix)
%GENEROWANIE ETYKIET DANYCH - KANAŁY
Labels = cell(row_num,1);

for window_idx = 1:num_windows
    for i = 1:ch_num
        % Naprzemienne przypisanie kanałów (1, 2, 1, 2) dla każdego okna
        label = sprintf('CH%d W%d', channels_to_process(i), window_idx);
        Labels{(window_idx-1)*ch_num + i} = label;
    end
end

% for i = 1:row_num
%    channel_label=mod(i-1,ch_num)+1;
%    window_label=mod(row_num)
%   Labels{i} = sprintf('CH%d W%d', channels_to_process(channel_label));
%  % Labels{i} = sprintf('CH%d', i);
% end


size(Labels)
FeatureMatrix=[fr_col,psr_col,mdf_col,mnf_col,dasdv_col, wl_col,aac_col,mfl_col, myop_col, sm2_col,sm3_col,v2_col,v3_col,rms_col, log_col, sm1_col,mmav_col, var_col,ssi_col, ttp_col, mnp_col, mav_col,iemg_col,wamp_col,zc_col];
% size(FeatureMatrix)
size(FeatureMatrix)
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