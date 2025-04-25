function norm_signal = normalizeToMinusOneToOne(signal)
    max_val = max(abs(signal));
    if max_val == 0
        norm_signal = signal;
    else
        norm_signal = signal / max_val;
    end
end