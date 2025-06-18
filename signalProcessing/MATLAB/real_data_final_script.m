folderPath = 'C:/Users/ppaul/ProjektZespołowy/SAMSON/signalProcessing/MATLAB/Data/dane17_06/proba3/';
files={'EMG_1706120835'
       'EMG_1706121426'
       'EMG_1706121615'
       'EMG_1706121647'
};


% Ścieżka do pliku danych (zmień na faktyczną ścieżkę)
file_path = 'C:/Users/ppaul/ProjektZespołowy/SAMSON/signalProcessing/MATLAB/Data/dane17_06/proba3/EMG_1706121647.txt';

%3 kanały dla testów
%file_path =
%'C:/Users/ppaul/ProjektZespołowy/SAMSON/signalProcessing/MATLAB/Data/3channels/EMG_1706113012.txt';


% Ścieżka do zapisu wyjściowego pliku CSV
output_path = 'C:/Users/ppaul/ProjektZespołowy/SAMSON/signalProcessing/MATLAB/Data/dane17_06/proba3/wyniki_real_features.csv';           

% Czy otworzyć wynikowy plik po zapisaniu (1 = tak, 0 = nie)
open_generated_file = 1;                  

% Czy użyć średniego odniesienia (1 = tak, 0 = nie)
use_average_referencing = 0;              

% ID gestu (liczba całkowita np. 1 dla pięści, 2 dla otwartej dłoni itd.)
gesture_id = 1;                            

% Czy zapisać w osobnym pliku (1 = tak, 0 = dopisanie do istniejącego)
separated_output = 1;                     

% Wywołanie funkcji
real_data_features(output_path, file_path, open_generated_file, use_average_referencing, gesture_id, separated_output);