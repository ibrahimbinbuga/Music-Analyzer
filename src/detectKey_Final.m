function [keyName, tonic, bass, bassStab, chromaRoot] = detectKey_Final(y, Fs)

    chroma = calcChroma_LongTerm(y, Fs);
    chromaKey = detectKey_KS(chroma);

    tonic = estimateTonic_Stability(y, Fs);

    [bass, bassStab] = estimateBassRoot(y, Fs);

    chromaRoot = extractBefore(chromaKey, " ");

    if bassStab >= 0.35 && bass == tonic
        keyName = bass + " Minor";
        return;
    end

    if bassStab >= 0.35 && bass == "D"
        keyName = "D Minor";
        return;
    end

    if tonic ~= chromaRoot
        keyName = tonic + " Minor";
        return;
    end

    keyName = chromaKey;
end
