function chroma = calcChroma_LongTerm(y, Fs)

    if size(y,2)==2
        y = mean(y,2);
    end

    frameLen = round(0.1 * Fs);   
    hop = round(0.05 * Fs);      
    N = length(y);

    numFrames = floor((N - frameLen) / hop) + 1;

    chromaSum = zeros(12,1);

    for i = 1:numFrames
        idx = (i-1)*hop + (1:frameLen);
        frame = y(idx) .* hann(frameLen);

        X = abs(fft(frame));
        X = X(1:floor(end/2));

        chromaFrame = zeros(12,1);
        for k = 1:length(X)
            freq = (k-1) * Fs / frameLen;
            if freq < 50 || freq > 5000
                continue;
            end
            midi = round(69 + 12*log2(freq/440));
            chromaFrame(mod(midi,12)+1) = chromaFrame(mod(midi,12)+1) + X(k);
        end

        chromaSum = chromaSum + chromaFrame;
    end

    chroma = chromaSum / max(chromaSum);
end
