[y, Fs] = audioread('../audio/test_C_major.wav');

if size(y,2) == 2
    y = mean(y,2);
end

afe = audioFeatureExtractor( ...
    "SampleRate", Fs, ...
    "chroma", true);

features = extract(afe, y);

chromaVector = mean(features, 1);

disp("Chroma Vektörü (12 nota gücü):");
disp(chromaVector);

[~, idx] = maxk(chromaVector, 3);

noteNames = ["C","C#","D","D#","E","F","F#","G","G#","A","A#","B"];

strongNotes = noteNames(idx);

disp("Güçlü notalar:");
disp(strongNotes);

if isequal(sort(strongNotes), ["C","E","G"])         
    disp("Tahmini Akor: C Major");
elseif isequal(sort(strongNotes), ["A","C","E"])
    disp("Tahmini Akor: A Minor");
elseif isequal(sort(strongNotes), ["D","F#","A"])
    disp("Tahmini Akor: D Major");
else
    disp("Akor: Tanımsız veya gelişmiş akor");
end
