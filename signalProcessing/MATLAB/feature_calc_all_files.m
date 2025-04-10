filenameexcel='features_t_multi.csv';
num_sessions = 1;
num_participants = 1;
num_trials = 1;
num_gestures = 17;  % Liczba gestów, przez które chcesz iterować

session=2;
participant=8;
%gesture=1;
trial=3;

channels_to_process=[1 2 14];
ch_num = length(channels_to_process);
headers = {'Sample', 'MAV','RMS', 'IEMG','ZC', 'PP'};

% Ścieżka do folderu z danymi
data_folder = 'Data/session2_participant8';

% Iteracja przez sesje, uczestników i próby (przechodzimy tylko przez gesty)
for gesture = 1:num_gestures

    % Generowanie nazwy pliku
    filename = sprintf('session%d_participant%d_gesture%d_trial%d.hea', ...
        session, participant, gesture, trial);

    % Tworzenie pełnej ścieżki do pliku
    full_filepath = fullfile(data_folder, filename);

    % Sprawdzanie, czy plik istnieje
    if exist(full_filepath, 'file') == 2
        % Wczytywanie danych z pliku
        %data = load(full_filepath);
        [data, sampling_frequency,time] = rdsamp(full_filepath,channels_to_process);
        disp(['Przetwarzanie pliku: ' filename]);
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

        Row_Labels = cell(ch_num,1);

        for i = 1:ch_num
            Row_Labels{i} = sprintf('Gesture%dCH%d', gesture,channels_to_process(i));
        end

        % Łączenie cech z etykietami
        FeatureMatrixWithLabels = [Row_Labels,num2cell(FeatureMatrix)];
        % writecell([headers; FeatureMatrixWithLabels], filenameexcel, 'Delimiter', ';');

        if exist(filenameexcel, 'file') == 2
            % Dopisujemy do pliku, nie nadpisujemy
            writecell(FeatureMatrixWithLabels, filenameexcel, 'Delimiter', ';', 'WriteMode', 'append');  % Dopisanie
        else
            % Jeśli plik nie istnieje, zapisujemy dane z nagłówkami
            writecell([headers; FeatureMatrixWithLabels], filenameexcel, 'Delimiter', ';');  % Pierwszy zapis z nagłówkami
        end

        % Potwierdzenie zapisu
        fprintf('Dane zostały zapisane do pliku %s.\n',filenameexcel);
    else
        disp(['Plik nie istnieje: ' full_filepath]);
    end
end
fprintf('Otwieram plik %s.\n',filenameexcel);
winopen(filenameexcel);  % Automatyczne otwarcie pliku w Excelu dla Windows