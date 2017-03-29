P=s(:,300);
figure,subplot(1,2,1)
plot(F,20*log(1+P/max(max(P))))
xlabel 'Frequency [Hz]'
ylabel 'Power spectrum [dB]'
set(gca,'FontSize',15)

mel=2595*log10(1+F/700);
subplot(1,2,2),plot(mel)
SS=spline(F,P,mel);
plot(mel,20*log(1+P/max(max(P))))
xlabel 'Frequency [mel]'
ylabel 'Power spectrum [dB]'
set(gca,'FontSize',15)

figure, hold on
plot(F,mel,'k')
plot([1895 1895],[0 1477],'--r')
plot([0 1895],[1477 1477],'--r')
xlabel 'Frequency [Hz]'
ylabel 'Frequency [mel]'
set(gca,'FontSize',15)