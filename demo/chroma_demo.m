[y, Fs] = audioread('../audio/test_C_major.wav');

if size(y,2) == 2
    y = mean(y,2);
end

chroma = calcChroma(y, Fs);

disp("Chroma vektörü (12 nota enerjisi):");
disp(chroma);

noteNames = ["C","C#","D","D#","E","F","F#","G","G#","A","A#","B"];

[~, idx] = maxk(chroma, 3);
strongNotes = noteNames(idx);

disp("Güçlü notalar:");
disp(strongNotes);

sortedNotes = sort(strongNotes);

if isequal(sortedNotes, ["C","E","G"])
    disp("Tahmini Akor: C Major");
elseif isequal(sortedNotes, ["A","C","E"])
    disp("Tahmini Akor: A Minor");
elseif isequal(sortedNotes, ["D","F#","A"])
    disp("Tahmini Akor: D Major");
else
    disp("Akor: Tanımsız veya daha karmaşık bir akor");
end
