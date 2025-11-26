Fs = 44100;
t = 0:1/Fs:1;

C = sin(2*pi*261.63*t);
E = sin(2*pi*329.63*t);
G = sin(2*pi*392.00*t);

y = (C + E + G) / 3;

audiowrite('../audio/test_C_major.wav', y, Fs);
disp("C Major test dosyası oluşturuldu.");
