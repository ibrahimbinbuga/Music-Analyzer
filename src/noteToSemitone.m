function semitone = noteToSemitone(noteName)

    noteNames = ["C", "C#", "D", "D#", "E", "F", "F#", ...
                 "G", "G#", "A", "A#", "B"];

    base = extractBefore(noteName, strlength(noteName));  
    octave = str2double(extractAfter(noteName, strlength(base))); 

    idx = find(noteNames == base) - 1;  

    semitone = idx + 12 * octave;
end
