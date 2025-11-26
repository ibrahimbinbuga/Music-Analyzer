function BPM = estimateBPM(y, Fs)

    if size(y,2) == 2
        y = mean(y,2);
    end

    frameSize = 2048;
    hop = 512;

    numFrames = floor((length(y)-frameSize) / hop);
    energy = zeros(1, numFrames);

    for i = 1:numFrames
        frame = y((i-1)*hop+1 : (i-1)*hop + frameSize);
        energy(i) = sum(abs(frame).^2);
    end

    energy = energy / max(energy);

    onsetStrength = [0 diff(energy)];
    onsetStrength(onsetStrength < 0) = 0;

    R = xcorr(onsetStrength);
    mid = floor(length(R)/2);
    R = R(mid:end);

    minBPM = 60;
    maxBPM = 200;

    minLag = floor((60/maxBPM) * (Fs/hop));
    maxLag = floor((60/minBPM) * (Fs/hop));

    [~, lag] = max(R(minLag:maxLag));
    lag = lag + minLag;

    BPM = 60 / (lag * hop / Fs);
end
