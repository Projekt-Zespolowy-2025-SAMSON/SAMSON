filename = 'features_f.csv';
fileDataPath = 'Data/session1_participant1_gesture10_trial2.hea';

checkFile(fileDataPath);

channels_to_process=[1 7 19];

ch_num = length(channels_to_process);

% Wczytanie danych
[data, sampling_frequency,time] = rdsamp(fileDataPath,channels_to_process);

% Nagłówki kolumn
headers = {'Sample', 'MAV','RMS', 'IEMG','ZC', 'PP'};

figure('Name', 'Sygnały EMG');
for i =1:ch_num
    subplot(ch_num, 1, i); % Tworzy układ
    plot(data(:, i)); % Rysuje kanał i
    title(sprintf('Kanał F%d', channels_to_process(i)));
    xlabel('Numer próbki');
    ylabel('Amplituda');
end

%wt ma tyle wierszy ile różnych częstotliwości i tyle kolumn ile próbek
[wt, fCWT] = cwt(data(:, 1), 'amor', sampling_frequency); 


% Wizualizacja transformacji falowej
timeLine=(0:length(data(:, 1))-1)/sampling_frequency;
plot_CWT_spectrum(timeLine,wt,fCWT);

%Zmiany max częstotliowści
max_Frequency_WT(wt,fCWT,sampling_frequency);


% Definicja pasm częstotliwości
bands = [20 50; 50 100; 100 200];

% Oblicz energię dla każdego pasma
 band_energy(wt,fCWT,sampling_frequency,bands);
% %MAV Mean Absolute Value
% mav_col = zeros(ch_num,1);
% for i =1:ch_num
% mav_col(i)=mean(abs(data(:,i)));
%end

%FeatureMatrix=[mav_col,rms_col,iemg_col,zc_col,pp_col];

% Generowanie etykiet danych
Labels = cell(ch_num,1);

for i = 1:ch_num
    Labels{i} = sprintf('CH%d', channels_to_process(i));
end

% Łączenie cech z etykietami
%%FeatureMatrixWithLabels = [Labels,num2cell(FeatureMatrix)];
% 
% % Zapis do pliku CSV z odpowiednim separatorem
% %jeśli w excelu nie dzieli się na kolumny to należy zamienić separator np.
% %na ',' lub takie jak jest w systemie
% 
% writecell([headers; FeatureMatrixWithLabels], filename, 'Delimiter', ';');
% 
% % Potwierdzenie zapisu
% fprintf('Dane zostały zapisane do pliku %s.\n',filename);
% 
% fprintf('Otwieram plik %s.\n',filename);
% winopen(filename);  % Automatyczne otwarcie pliku w Excelu dla Windows