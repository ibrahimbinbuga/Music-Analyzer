[y, Fs] = audioread('../audio/handel.wav');

if size(y,2) == 2
    y = mean(y, 2); 
end

frameSize = 4096;
hop = 2048;

N = length(y);

frame = y(1:frameSize);

Y = fft(frame);
P2 = abs(Y/frameSize);
P1 = P2(1:frameSize/2+1);
P1(2:end-1) = 2 * P1(2:end-1);

f = Fs*(0:(frameSize/2))/frameSize;

[~, idx] = max(P1(1:1000));

fundFreq = f(idx);

disp("Frame fundamental frekans:")
disp(fundFreq)

note = frequencyToNote(fundFreq);
disp("Frame nota:")
disp(note)
