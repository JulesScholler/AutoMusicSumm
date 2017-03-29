addpath('musics')

% Load music
[x,param.fs]=audioread('tnt.mp3');
x=x(:,1)/max(x(:,1));
sigma=0:0.01:0.2;

for i=1:length(sigma)
    noise=sigma(i)*randn(length(x),1);
    s=x+noise;
    s=s/max(s);
    [~,score(i,:)]=find_excerpt(s,10);
end
for i=1:length(sigma)
    score(i,:)=score(i,:)/max(score(i,:));
    d(i)=sum(sqrt((score(1,:)-score(i,:)).^2))/length(score(1,:));
end