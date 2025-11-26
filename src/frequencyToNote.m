function noteName = frequencyToNote(freq)

    if freq <= 0
        noteName = "N/A";
        return;
    end

    noteNames = ["C", "C#", "D", "D#", "E", "F", "F#", ...
                 "G", "G#", "A", "A#", "B"];

    midiNote = round(69 + 12 * log2(freq / 440));

    index = mod(midiNote, 12) + 1;
    note = noteNames(index);

    octave = floor(midiNote / 12) - 1;

    noteName = sprintf("%s%d", note, octave);
end
