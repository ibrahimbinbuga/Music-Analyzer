[y, Fs] = audioread('../audio/lo-fi_mixli_bitti.wav');

if size(y,2) == 2
    y = mean(y,2);
end

env = abs(hilbert(y));   

env_smooth = movmean(env, Fs*0.05);

t = (0:length(env_smooth)-1) / Fs;


figure;
plot(t, env_smooth);
xlabel("Zaman (s)");
ylabel("Enerji Zarfı");
title("Envelope (Energy)");

[minProm, ~] = max(env_smooth);
minProm = minProm * 0.30;   % threshold

[peakVals, peakLocs] = findpeaks(env_smooth, ...
                                 'MinPeakProminence', minProm, ...
                                 'MinPeakDistance', 0.2*Fs); 


beatTimes = peakLocs / Fs;


hold on;
plot(beatTimes, peakVals, 'ro', 'MarkerSize', 8, 'LineWidth', 2);
hold off;

disp("Beat zamanları (s):");
disp(beatTimes);


if length(beatTimes) > 1
    intervals = diff(beatTimes);     
    avgInterval = mean(intervals);   
    BPM = 60 / avgInterval;
    disp("Tahmini BPM:");
    disp(BPM);
else
    disp("BPM bulunamadı (yeterli beat yok).");
end
