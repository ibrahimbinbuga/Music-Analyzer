[y, Fs] = audioread('../audio/handel.wav');

if size(y,2) == 2
    y = mean(y, 2);  
end

N = length(y);

Y = fft(y);

P2 = abs(Y/N);

P1 = P2(1:N/2+1);
P1(2:end-1) = 2*P1(2:end-1);

f = Fs*(0:(N/2))/N;

figure;
plot(f, P1)
xlabel('Frekans (Hz)')
ylabel('Genlik')
title('Frekans Spektrumu')
xlim([0 2000])   
