function tonic = estimateTonic_Stability(y, Fs)

    frameLen = round(0.1 * Fs);
    hop = round(0.05 * Fs);
    N = length(y);

    numFrames = floor((N - frameLen)/hop);
    tonicVotes = zeros(12,1);

    for i = 1:numFrames
        idx = (i-1)*hop + (1:frameLen);

        frame = y(idx);
        X = abs(fft(frame));
        X = X(1:floor(end/2));

        frameChroma = zeros(12,1);
        for k = 1:length(X)
            freq = (k-1)*Fs/frameLen;
            if freq < 60 || freq > 5000, continue; end

            midi = round(69 + 12*log2(freq/440));
            frameChroma(mod(midi,12)+1) = frameChroma(mod(midi,12)+1) + X(k);
        end

        [~, idx2] = max(frameChroma);
        tonicVotes(idx2) = tonicVotes(idx2) + 1;
    end

    notes = ["C","C#","D","D#","E","F","F#","G","G#","A","A#","B"];
    [~, idxFinal] = max(tonicVotes);
    tonic = notes(idxFinal);
end
