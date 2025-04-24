function band_energy(waveletTransform, fCWT,sampling_frequency,bands)

% Inicjalizacja macierzy energii
energia_pasm = zeros(size(bands,1), size(waveletTransform,2)); 
% size(A,1) liczba wierszy w A 
% size(A,2) liczba kolumn w A

    for i = 1:size(bands,1)
        fstart = bands(i,1);
        fstop = bands(i,2);
        idx = (fCWT >=  fstart) & (fCWT <= fstop);
        oneBand_energy=abs(waveletTransform(idx,:)).^2;
        energia_pasm(i,:) = mean(oneBand_energy, 1);
        mean_energyALL_band=mean( energia_pasm(i,:))
    end
 % 
   time = (1:size(waveletTransform,2)) / sampling_frequency;


   figure('Name', 'Band energy');

band_num=size(bands,1);
for i =1:band_num
    subplot(band_num, 1, i); % Tworzy układ
    plot(time, energia_pasm(i,:)); % Rysuje kanał i
    xlabel('Czas [s]');
    ylabel('Średnia energia CWT');
    %legend(arrayfun(@(x) sprintf('%d-%d Hz', bands(x,1), bands(x,2)), 1:size(bands,1), 'UniformOutput', false));

end

end