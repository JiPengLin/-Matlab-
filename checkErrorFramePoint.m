
function [idx] = checkErrorFramePoint(src)


[rows,cols,frames] = size(src);
av = double(src);


% 计算各帧相似度
r = zeros(frames-1,1);
deltar = zeros(frames-1,1);
for k = 1:frames-1
    r(k) = getImageCorrelation(av(:,:,k),av(:,:,k+1));
    if k>1
        deltar(k) = abs(r(k)-r(k-1));
    end
end
N = frames-1;
x = 1:N;

%%

E = mean(deltar);
D = var(deltar);
sigma = sqrt(D);


k1 = 3;
k2 = 5;
deltarp = [];
for i = 1:N
    if abs(deltar(i)-E)<k1*sigma
        deltarp = [deltarp,deltar(i)];
    end
end

Ep = mean(deltarp);
Dp = var(deltarp);
sigmap = sqrt(Dp);

idx = [];

errorWeight = [];
for i = 1:N
    if abs(deltar(i)-Ep)>=k2*sigmap
        idx = [idx,i];
        errorWeight = [abs(deltar(i)-Ep)/sigmap];
    end
end

figure
subplot(311),plot(r,'.-'),axis([0,frames,0,1])
subplot(312),plot(deltar,'.-'),axis([0,frames,0,1])
subplot(313),bar(idx,ones(size(idx)),0.5,'r'),axis([0,frames,0,1])
end





function  r = getImageCorrelation(im1,im2)

im1 = im1 - mean2(im1);
im2 = im2 - mean2(im2);
r = sum(sum(im1.*im2))/sqrt(sum(sum(im1.*im1))*sum(sum(im2.*im2)));

end

