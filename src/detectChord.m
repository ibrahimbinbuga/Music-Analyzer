function chordName = detectChord(noteList)

    if length(noteList) < 3
        chordName = "Yetersiz nota";
        return;
    end

    semitones = zeros(1, length(noteList));
    for i = 1:length(noteList)
        semitones(i) = noteToSemitone(noteList(i));
    end

    root = min(semitones);
    intervals = semitones - root;

    intervals = mod(intervals, 12);

    intervals = sort(intervals);

    if isequal(intervals(1:3), [0 4 7])
        chordName = noteList(1) + " Major";
        return;
    end

    if isequal(intervals(1:3), [0 3 7])
        chordName = noteList(1) + " Minor";
        return;
    end

    chordName = "Tanımsız veya karmaşık akor";
end
