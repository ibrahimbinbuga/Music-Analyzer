function [bpm, candidates] = estimateBPM_Pro2(y, Fs)

    if size(y,2) == 2, y = mean(y,2); end
    y = y / max(abs(y) + eps);

    try
        [b,a] = butter(4, 40/(Fs/2), 'high');
        y = filtfilt(b,a,y);
    catch
    end

    frameSize = 2048;
    hop = 512;
    win = hann(frameSize, "periodic");
    numFrames = floor((length(y)-frameSize)/hop) + 1;

    magSpec = zeros(frameSize/2+1, numFrames);
    for i=1:numFrames
        idx = (i-1)*hop + (1:frameSize);
        frame = y(idx).*win;
        X = fft(frame);
        magSpec(:,i) = abs(X(1:frameSize/2+1));
    end

    flux = zeros(1, numFrames);
    for i=2:numFrames
        diffSpec = magSpec(:,i) - magSpec(:,i-1);
        diffSpec(diffSpec<0) = 0;
        flux(i) = sum(diffSpec);
    end

    flux = flux / max(flux + eps);
    flux = movmean(flux, 8);
    flux = movmedian(flux, 5);

    R = xcorr(flux - mean(flux), 'unbiased');
    R = R(numFrames:end);

    minBPM = 60; maxBPM = 200;
    minLag = floor((60/maxBPM) / (hop/Fs));
    maxLag = floor((60/minBPM) / (hop/Fs));
    Rwin = R(minLag:maxLag);

    [pks, locs] = findpeaks(Rwin, 'SortStr','descend','NPeaks',5);
    if isempty(locs)
        bpm = NaN;
        candidates = [];
        return;
    end

    lags = locs + minLag - 1;
    bpmCand = 60 ./ (lags * hop / Fs);
    scores = pks / max(pks);

    bestBPM = bpmCand(1);
    baseScore = scores(1);

    base = bestBPM;

    double15 = base * 1.5;   

    [d15, j15] = min(abs(bpmCand - double15));
    if d15 < 4
        if scores(j15) >= 0.55 * baseScore
            bpm = bpmCand(j15);
            candidates = table(bpmCand(:), scores(:), ...
                'VariableNames', {'BPM','Score'});
            return;
        end
    end

    double2 = base * 2;
    [d2, j2] = min(abs(bpmCand - double2));
    if d2 < 4 && scores(j2) >= 0.5 * baseScore
        bpm = bpmCand(j2);
        candidates = table(bpmCand(:), scores(:), ...
            'VariableNames', {'BPM','Score'});
        return;
    end

    bpm = base;

    candidates = table(bpmCand(:), scores(:), ...
        'VariableNames', {'BPM','Score'});

end
