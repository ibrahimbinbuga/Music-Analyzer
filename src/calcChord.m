function chord = calcChord(chroma)

    noteNames = ["C","C#","D","D#","E","F","F#","G","G#","A","A#","B"];

    safeNames = replace(noteNames, "#", "s");

    majorPattern = [1 0 0 1 0 0 0 1 0 0 0 0];
    minorPattern = [1 0 0 0 1 0 0 1 0 0 0 0];

    templates = struct;

    for i = 1:12
        fieldName = safeNames(i) + "_maj"; 
        templates.(fieldName) = circshift(majorPattern, i-1);
    end

    for i = 1:12
        fieldName = safeNames(i) + "_min";
        templates.(fieldName) = circshift(minorPattern, i-1);
    end

    templateNames = fieldnames(templates);
    scores = zeros(length(templateNames), 1);

    for i = 1:length(templateNames)
        tpl = templates.(templateNames{i});
        scores(i) = sum(chroma .* tpl);
    end

    [bestScore, idx] = max(scores);

    if bestScore < max(chroma) * 0.2
        chord = "Unknown";
        return;
    end

    bestName = templateNames{idx};

    name = bestName;

    name = regexprep(name, "^Cs", "C#");
    name = regexprep(name, "^Ds", "D#");
    name = regexprep(name, "^Fs", "F#");
    name = regexprep(name, "^Gs", "G#");
    name = regexprep(name, "^As", "A#");

    name = strrep(name, "_maj", " Major");
    name = strrep(name, "_min", " Minor");

    chord = name;
end
