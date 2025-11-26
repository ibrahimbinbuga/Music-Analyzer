function [root, stability] = estimateBassRoot(y, Fs)

    if size(y,2)==2, y = mean(y,2); end
    y = y / (max(abs(y)) + eps);

    frameLen = 4096;   
    hop      = 1024;
    win      = hann(frameLen,"periodic");

    N = length(y);
    numFrames = floor((N-frameLen)/hop) + 1;

    notes = ["C","C#","D","D#","E","F","F#","G","G#","A","A#","B"];
    vote = zeros(12,1);

    for i = 1:numFrames
        idx = (i-1)*hop + (1:frameLen);
        frame = y(idx).*win;

        X = abs(fft(frame));
        X = X(1:floor(end/2));
        freqs = (0:length(X)-1) * Fs / frameLen;

        bandIdx = freqs >= 30 & freqs <= 200;
        bandMag = X(bandIdx);
        bandFreqs = freqs(bandIdx);
        if isempty(bandMag), continue; end

        [pks, locs] = findpeaks(bandMag, "SortStr","descend", "NPeaks",3);
        if isempty(locs), continue; end
        peakFreqs = bandFreqs(locs);

        candFund = [];
        for f = peakFreqs'
            candFund = [candFund; f; f/2; f/3];
        end
        candFund = candFund(candFund >= 30 & candFund <= 120);
        if isempty(candFund), continue; end

        edges = 30:1:120;
        h = histcounts(candFund, edges);
        [~, j] = max(h);
        f0 = (edges(j)+edges(j+1))/2;

        midi = round(69 + 12*log2(f0/440));
        pc = mod(midi,12)+1;
        vote(pc) = vote(pc) + 1;
    end

    [bestVotes, bestPc] = max(vote);
    totalVotes = sum(vote) + eps;
    stability = bestVotes / totalVotes;   

    root = notes(bestPc);
end
