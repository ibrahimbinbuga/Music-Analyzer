function result = analyzeMusic(filename)
    [y, Fs] = audioread(filename);

    result.BPM = estimateBPM(y, Fs);

    if size(y,2) == 2
        y = mean(y,2);
    end
    chroma = calcChroma(y, Fs);
    noteNames = ["C","C#","D","D#","E","F","F#","G","G#","A","A#","B"];
    [~, idx] = maxk(chroma, 3);
    result.strongNotes = noteNames(idx);

    sortedNotes = sort(result.strongNotes);
    if isequal(sortedNotes, ["C","E","G"])
        result.chord = "C Major";
    elseif isequal(sortedNotes, ["A","C","E"])
        result.chord = "A Minor";
    elseif isequal(sortedNotes, ["D","F#","A"])
        result.chord = "D Major";
    else
        result.chord = "Tanımsız / Karmaşık";
    end
end
