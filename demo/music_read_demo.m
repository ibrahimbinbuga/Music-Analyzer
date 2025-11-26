[y, Fs] = audioread('../audio/lo-fi_mixli_bitti.wav');

disp('Sinyal boyutu:')
size(y)

disp('Ornekleme frekansi:')
Fs

sound(y, Fs)

t = (0:length(y)-1) / Fs;

figure;
plot(t, y)
xlabel('Zaman (s)')
ylabel('Genlik')
title('Dalga Formu (Waveform)')
