function bpm = estimateBPM_Pro(y, Fs)
    y = y / max(abs(y));

    hpFilt = designfilt('highpassiir', 'FilterOrder', 4, ...
                        'HalfPowerFrequency', 40, ...
                        'SampleRate', Fs);
    y_hp = filtfilt(hpFilt, y);

    frameSize = round(0.04 * Fs);
    hop = round(0.02 * Fs);
    numFrames = floor((length(y_hp)-frameSize)/hop);

    flux = zeros(numFrames,1);
    prevFrame = abs(fft(y_hp(1:frameSize)));

    for i = 2:numFrames
        idx = (i-1)*hop + (1:frameSize);
        currFrame = abs(fft(y_hp(idx)));
        flux(i) = sum(max(currFrame - prevFrame, 0));
        prevFrame = currFrame;
    end

    flux = medfilt1(flux, 5);
    flux = smooth(flux, 20);

    ac = xcorr(flux - mean(flux), 'unbiased');
    ac = ac(length(flux):end);

    minLag = round((60/180) / (hop/Fs));
    maxLag = round((60/60) / (hop/Fs));

    [~, lag] = max(ac(minLag:maxLag));
    lag = lag + minLag - 1;

    bpm_raw = 60 / (lag * hop / Fs);

    candidates = [bpm_raw/2, bpm_raw, bpm_raw*2];
    diffs = abs(candidates - 120);  
    [~, idx] = min(diffs);
    bpm = candidates(idx);
end
