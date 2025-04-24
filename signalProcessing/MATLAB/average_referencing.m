function [signal_avg_ref] = average_referencing(data,ch_num,show)
% Oblicz średnią w czasie (czyli po wszystkich kanałach)
avg_signal = mean(data, 2);  

% Odejmij średnią od każdego kanału
signal_avg_ref = data - avg_signal;
if show
for i = 1:ch_num
figure('Position', [0, 200, 1400, 400]);  % [x y szerokość wysokość]

subplot(1, 3,1); 
plot(avg_signal,'b');
xlabel('Czas [s]');
ylabel('Średni sygnał EMG');
title('Średnia z wszystkich kanałów EMG w czasie');
grid on;

subplot(1, 3,2);
plot(data(:,i)','g');
xlabel('Czas [s]');
ylabel('Sygnał EMG');
title('Sygnał EMG w czasie');
grid on;

subplot(1, 3,3); 
plot(signal_avg_ref(:,i),'r');
xlabel('Czas [s]');
ylabel('Sygnał EMG odjęta średnia');
title('Sygnał EMG -- Average referencing');
grid on;

end
end
end