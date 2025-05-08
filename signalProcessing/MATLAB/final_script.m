output_filename = 'features_new.csv';
%fileDataPath= constructFilePath(1,11,2,6);

% sesion=[1 2];          %1-3
% participant=[5 3 34];     %1-43
% gesture=[2 11];        %1-17
% trial=[2 5];           %1-7

sesion=1;          %1-3
participant=1:43;     %1-43
gesture=1:17;        %1-17
trial=1:7;           %1-7


for s = 1:length(sesion)
    for p = 1:length(participant)
        for g= 1:length(gesture)
            for t= 1:length(trial)
                fileDataPath=constructFilePath(sesion(s),participant(p),gesture(g),trial(t));
               % output_filename=sprintf('features_s%d_p%d_g%d_t%d.csv',sesion(s),participant(p),gesture(g),trial(t));
                 output_filename_path= fullfile('Output',output_filename);
                from_one_file( output_filename_path,fileDataPath,false,false,gesture(g),0);
            end
        end
    end
end