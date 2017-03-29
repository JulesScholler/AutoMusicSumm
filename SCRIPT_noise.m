addpath('musics')

% Parameters
output.spectrogram='no';
output.music='no';
output.similarity='no';
output.excerpt='yes';
output.save_excerpt='no';
output.score='no';
sigmaG=0.05;
sigmaI=0.01;
filename='rockyou.mp3';
duration=10;

% Load and normalize music
[x,fs]=audioread(filename);
x=x(:,1)/max(x(:,1));

% Gaussian noise
noise=sigmaG*randn(length(x),1);
s=x+noise;
s=s/max(s);
[excerpt,~,~]=find_excerpt(s,duration,output);
audiowrite(['./excerpts/' filename(1:end-4) num2str(round(duration)) '_noisy_G.wav'],excerpt,fs);

% Salt-and-paper noise
noise=rand(length(x),1);
noise(noise>1-sigmaI/2)=1;
noise(noise>1-sigmaI/2)=-1;
s=x;
s(noise==1)=1;
s(noise==-1)=-1;
[excerpt,~,~]=find_excerpt(s,duration,output);
audiowrite(['./excerpts/' filename(1:end-4) num2str(round(duration)) '_noisy_I.wav'],excerpt,fs);
