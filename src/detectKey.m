function keyName = detectKey(chroma)

    chroma = chroma / max(chroma + eps);

    majorProfile = [6.35 2.23 3.48 2.33 4.38 4.09 ...
                    2.52 5.19 2.39 3.66 2.29 2.88];

    minorProfile = [6.33 2.68 3.52 5.38 2.60 3.53 ...
                    2.54 4.75 3.98 2.69 3.34 3.17];

    majors = zeros(12,1);
    minors = zeros(12,1);

    for i=1:12
        majors(i) = corr(chroma(:), circshift(majorProfile(:), i-1));
        minors(i) = corr(chroma(:), circshift(minorProfile(:), i-1));
    end

    [maxMaj, majIdx] = max(majors);
    [maxMin, minIdx] = max(minors);

    noteNames = ["C","C#","D","D#","E","F","F#","G","G#","A","A#","B"];

    if maxMaj > maxMin
        keyName = noteNames(majIdx) + " Major";
    else
        keyName = noteNames(minIdx) + " Minor";
    end
end
