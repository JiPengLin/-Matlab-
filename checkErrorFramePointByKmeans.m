
function [idx1,idx2] = checkErrorFramePointByKmeans(src,labelNum)


[~,~,frames] = size(src);
av = double(src);

% �����֡���ƶ�
r = zeros(frames-1,1);
deltar = zeros(frames-1,1);
for k = 1:frames-1
    r(k) = getImageCorrelation(av(:,:,k),av(:,:,k+1));
    if k>1
        deltar(k) = [abs(r(k)-r(k-1))];
    end
end
N = frames-1;
x = 1:N;

%% ����
[class,c] = kmeans(deltar,labelNum);
[~,maxidx] = sort(c);

% �����
idx1 = find(class==maxidx(end))';
% �δ���(�˶��󣬵����Ǵ۸ģ�
idx2 = find(class==maxidx(end-1));

figure
subplot(311),plot(r,'.-'),axis([0,frames,0,1])
subplot(312),plot(deltar,'.-'),axis([0,frames,0,1])
% ��ɫ�Ǵ۸�
subplot(313),bar(idx1,ones(size(idx1)),0.5,'r'),hold on
bar(idx2,ones(size(idx2)),0.5,'y')
axis([0,frames,0,1])

end






function  r = getImageCorrelation(im1,im2)

im1 = im1 - mean2(im1);
im2 = im2 - mean2(im2);
r = sum(sum(im1.*im2))/sqrt(sum(sum(im1.*im1))*sum(sum(im2.*im2)));

end

