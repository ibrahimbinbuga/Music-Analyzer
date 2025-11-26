function keyName = detectKey2(chroma)

    key1 = detectKey(chroma);

    tonic = estimateTonic(chroma);

    if key1 == "A Minor" && tonic == "D"
        keyName = "D Minor";
        return;
    end

    if key1 == "C Major" && tonic == "D"
        keyName = "D Dorian";
        return;
    end

    if key1 == "A Minor" && tonic == "D"
        keyName = "D Aeolian";
        return;
    end

    keyName = key1;
end
