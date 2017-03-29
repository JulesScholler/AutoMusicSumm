N=1000;
w=[zeros(N/10,1) ;hamming(N); zeros(N/10,1)];
TFw=fft(w);

figure,subplot(1,2,1)
plot(w)
xlim([N/10+1 N+N/10])
xlabel 'samples'
ylabel 'w(n)'
title 'Hamming window'
set(gca,'FontSize',15)
subplot(1,2,2)
plot(20*log10(abs(TFw)/max(abs(TFw))))
xlim([0 50])
xlabel 'frequency'
ylabel('$$20\times log10(|\tilde{w}|)$$','Interpreter','latex')
title 'Hamming spectrum'
set(gca,'FontSize',15)