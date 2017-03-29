function [excerpt,Q,q]=find_excerpt(file,duration,output)
% This function extract the more representative excerpt of an audio signal
%
% inputs: file        path toward audio signal or vector containing the audio signal (careful in this case the function assumes fs=44.1 kHz)
%         duration    desired duration for the exerpt
%         output      figures and save to print during the process
%         
% outputs:    excerpt     best respresentative excerpt with specified duration
%             Q           score function
%             q           maximum position of Q  
%
% Jules Scholler - Feb. 2017

% Parameters
if nargin<3
    output.spectrogram='yes';
    output.music='no';
    output.similarity='yes';
    output.excerpt='no';
    output.save_excerpt='no';
    output.score='yes';
end
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
if strcmp(output.music,'yes')
    soundsc(x,param.fs);
end
fprintf(['Algorithm running on ' param.filename ' - Length: %d s.\n'],round(length(x)/param.fs))

% Paramametrization
[S,F,T]=spectrogram(x,param.window,param.noverlap,param.nfft,param.fs);
s=abs(S)+eps;
if strcmp(output.spectrogram,'yes')
    figure
    imagesc(T,F,20*log(s/max(max(s))))
    ax = gca;
    ax.YDir = 'normal';
    colormap jet
    h = colorbar;
    ylabel(h,'Normalized power/frequency [dB/Hz]')
    xlabel 'Time [s]'
    ylabel 'Frequency [Hz]'
    title 'Music spectrogram'
    set(gca,'FontSize',15)
end

% Compute similarity matrix
D=s'*s./sqrt(sum(s.^2,1)'*sum(s.^2,1));
if strcmp(output.similarity,'yes')
    figure
    imagesc(T,T,D)
    colormap gray
    h = colorbar;
    ylabel(h,'Normalized similarity')
    xlabel 'Time [s]'
    ylabel 'Time [s]'
    title 'Music similarity matrix'
    set(gca,'FontSize',15)
end

% Compute excerpt scores
L=find(T>param.excerpt_duration,1,'first');
Q=zeros(length(D)-L,1);
for i=1:length(D)-L
    Q(i)=sum(sum(D(i:i+L,:)));
end
if strcmp(output.score,'yes')
    figure
    plot(T(1:end-L),Q/max(Q))
    xlabel 'Time [s.]'
    ylabel 'Normalized score'
    title 'Similarity score'
    xlim([min(T(1:end-L)) max(T(1:end-L))])
    set(gca,'FontSize',15)
end
[~,q]=max(Q);
excerpt=x(q*(param.nfft-param.noverlap):(q+L)*(param.nfft-param.noverlap));
fprintf('Representative excerpt found: %d s. to %d s.\n',round(q*(param.nfft-param.noverlap)/param.fs),round((q+L)*(param.nfft-param.noverlap)/param.fs))
if strcmp(output.excerpt,'yes')
    soundsc(excerpt,param.fs);
end
if strcmp(output.save_excerpt,'yes')
    audiowrite(['./excerpts/' param.filename(1:end-4) num2str(round(param.excerpt_duration)) '.wav'],excerpt,param.fs);
end

