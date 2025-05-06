function [log_value] = compute_LOG(data,decomposition_level,wavelet_type)
epsilon=1e-6;
[C,L]=wavedec(data,decomposition_level,wavelet_type);
D2=detcoef(C,L,2);
D2_normalized = D2 / max(abs(D2));
 log_value = exp(mean(log(abs(D2_normalized) + epsilon)));
end