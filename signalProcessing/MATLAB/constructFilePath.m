function [full_filepath] = constructFilePath(session,participant,gesture,trial)
% Ścieżka do folderu z danymi
session_folder = sprintf('Session%d',session);
participant_folder=sprintf('session%d_participant%d',session,participant);
filename =sprintf('session%d_participant%d_gesture%d_trial%d.hea', ...
        session, participant, gesture, trial);

    % Tworzenie pełnej ścieżki do pliku
    full_filepath = fullfile('Data',session_folder, participant_folder, filename)