fileDataPath = 'Data/session1_participant1_gesture10_trial2.hea';

checkFile(fileDataPath);

channels_to_process=[1 5 7 19];

ch_num = length(channels_to_process);

% Wczytanie danych
[data, sampling_frequency,time] = rdsamp(fileDataPath,channels_to_process);

%Average referencing
aver=average_referencing(data,ch_num,1);

filt=filters_f(aver,ch_num,sampling_frequency,[10 450],60,1);
