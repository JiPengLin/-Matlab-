
function [idx] = checkErrorFramePointBySVM(src)


[~,~,frames] = size(src);
av = double(src);

% �����֡���ƶ�

r = zeros(frames-1,1);
fuv = zeros(frames-1,512);
deltar = zeros(frames-1,513);
for k = 1:frames-1
    r(k) = getImageCorrelation(av(:,:,k),av(:,:,k+1));
    fuv(k,:) = getHSFeature(av(:,:,k),av(:,:,k+1), 0.01, 200);
    if k>1
        deltar(k,:) = [abs(r(k)-r(k-1)),abs(fuv(k,:)-fuv(k-1,:))];
    end
end


%% ����
load('.\tmp\svmModel2.mat')
%�������
classification = predict(svmModel,deltar);

% ����svm������
idx = find(classification==2)';

end



function  r = getImageCorrelation(im1,im2)

im1 = im1 - mean2(im1);
im2 = im2 - mean2(im2);
r = sum(sum(im1.*im2))/sqrt(sum(sum(im1.*im1))*sum(sum(im2.*im2)));

end

