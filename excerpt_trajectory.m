function [q,Lc]=excerpt_trajectory(file)
% This function extract the more representative excerpt of an audio signal
%
% inputs: file path toward audio signal or vector containing the audio signal (careful in this case the function assumes fs=44.1 kHz)
%         
% outputs:    excerpt     best respresentative excerpt with specified duration
%             q           position of the maximum in the score function
%             Lc           excerpt duration
%
% Jules Scholler - Feb. 2017

% Parameters
param.noverlap=2*2048;
param.nfft=2*4096;
param.window=hamming(param.nfft);
param.excerpt_duration=duration;  % seconds

% Load music and keep a single channel
if ischar(file)
    param.filename=file;
    [x,param.fs]=audioread(param.filename);
    x=x(:,1);
elseif isnumeric(file)
    param.filename='user_sound';
    param.fs=44100;
    x=file;
end
fprintf(['Algorithm running on ' param.filename ' - Length: %d s.\n'],round(length(x)/param.fs))

% Paramametrization
[S,F,T]=spectrogram(x,param.window,param.noverlap,param.nfft,param.fs);
s=abs(S)+eps;

% Compute similarity matrix
D=s'*s./sqrt(sum(s.^2,1)'*sum(s.^2,1));

% Compute excerpt scores
Lc=10:20;
for j=1:length(Lc)
    L(j)=find(T>Lc(j),1,'first');
    Q=zeros(length(D)-L(j),1);
    for i=1:length(D)-L(j)
        Q(i)=sum(sum(D(i:i+L(j),:)));
    end
    [~,q(j)]=max(Q);
end
