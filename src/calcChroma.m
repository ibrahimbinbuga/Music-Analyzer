function chroma = calcChroma(y, Fs)

    N = length(y);
    Y = abs(fft(y));

    f = (0:N-1) * (Fs / N);

    maxFreq = 2000;
    idx = f <= maxFreq;
    
    Y = Y(idx);
    f = f(idx);

    chroma = zeros(1,12);
    
    for i = 1:length(f)
        freq = f(i);
        if freq < 50
            continue;
        end

        midiNote = round(69 + 12 * log2(freq / 440));

        pc = mod(midiNote, 12) + 1;

        chroma(pc) = chroma(pc) + Y(i);
    end
end
