[y, Fs] = audioread('../audio/handel.wav');

if size(y,2) == 2
    y = mean(y, 2);
end

N = length(y);
Y = fft(y);
P2 = abs(Y/N);
P1 = P2(1:N/2+1);
P1(2:end-1) = 2 * P1(2:end-1);

f = Fs*(0:(N/2))/N;

[pks, locs] = findpeaks(P1, f, 'MinPeakHeight', 0.005, 'MinPeakDistance', 50);

[pks_sorted, idx] = sort(pks, 'descend');
top_freqs = locs(idx(1:5));

disp('En baskın 5 frekans (Hz):');
disp(top_freqs);

figure;
findpeaks(P1, f, 'MinPeakHeight', 0.005, 'MinPeakDistance', 50);
xlabel('Frekans (Hz)')
ylabel('Genlik')
title('Spektrum Üzerinde Peak Noktaları')
xlim([0 2000])


disp('En baskın frekansların notaları:');
noteList = strings(1, length(top_freqs));
for i = 1:length(top_freqs)
    noteList(i) = frequencyToNote(top_freqs(i));
end
disp(noteList);

chordName = detectChord(noteList);
disp('Tahmini Akor:');
disp(chordName);
