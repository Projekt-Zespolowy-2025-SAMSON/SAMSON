function checkFile(path)
if exist(path, 'file')
    disp('Plik istnieje.');
else
    disp('Plik NIE istnieje! Sprawdź ścieżkę.');
end
end