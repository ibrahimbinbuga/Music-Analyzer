function tonic = estimateTonic(chroma)

    chroma = chroma(:) / (max(chroma) + eps);

    [~, idx] = max(chroma);

    notes = ["C","C#","D","D#","E","F","F#","G","G#","A","A#","B"];

    tonic = notes(idx);
end
