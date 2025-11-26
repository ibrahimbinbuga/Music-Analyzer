[y, Fs] = audioread('../audio/test_C_major.wav');

if size(y,2) == 2
    y = mean(y, 2);
end

frameSize = 4096;
hop = 4096;   

N = length(y);
numFrames = 4;  

fundNotes = strings(1, numFrames);

for k = 1:numFrames
    startIdx = (k-1)*hop + 1;
    endIdx = startIdx + frameSize - 1;

    if endIdx > N
        break;
    end

    frame = y(startIdx:endIdx);

    Y = fft(frame);
    P2 = abs(Y/frameSize);
    P1 = P2(1:frameSize/2+1);
    P1(2:end-1) = 2 * P1(2:end-1);
    f = Fs*(0:(frameSize/2))/frameSize;

    [~, idx] = max(P1(1:1000));
    fundamentalFreq = f(idx);

    fundNotes(k) = frequencyToNote(fundamentalFreq);
end

disp("Frame notaları:");
disp(fundNotes);

chordName = detectChord(fundNotes);
disp("Tahmini Akor:");
disp(chordName);
