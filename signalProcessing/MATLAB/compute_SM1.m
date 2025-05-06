function sm1_value = compute_SM1(data, decomposition_level,  wavelet_type,fs)

[C, L] = wavedec(data, decomposition_level,  wavelet_type);
D2 = detcoef(C, L, 2);

N=length(D2);
f = (0:N-1)*(fs/N);
f=f(:);
power_spectrum=abs(fft(D2)).^2/N;
size(f);
size(power_spectrum);
sm1_value=sum(f .*power_spectrum)/(sum(power_spectrum));
end