% ��ȡѵ����
clear; close all; clc

rootPath = '.\src'; %·��

dirout = dir(rootPath);
videoList = {dirout(3:end).name}';
videoNum = length(videoList);

MAXN = 300;
groups = 20;

%% ��ȡδ�۸����ݼ�
NormalFeatureVector = [];
for fn = 1:videoNum
    disp(['��Ƶ������(�������ݼ�)��',num2str(fn),'/',num2str(videoNum)])
    % ����
    videoName = fullfile(rootPath,videoList{fn});
    videoObj = VideoReader(videoName);
    num = floor(min([MAXN,videoObj.numberOfFrames])/groups);    
    % �������
    for k = 1:num        
        blocks = read(videoObj,[(k-1)*groups+1,k*groups]);
        [rows,cols,~,frames] = size(blocks);
        % ��Ƶת�Ҷ�
        gray = zeros(rows,cols,frames,'uint8');
        for f = 1:groups
            gray(:,:,f) = rgb2gray(blocks(:,:,:,f));
        end
        % ��ȡ��������
        featureVector = getFeatureVector(gray);
        NormalFeatureVector = cat(1,NormalFeatureVector,featureVector);
    end    
end

%% ��ȡ�۸����ݼ�
TamperFeatureVector = [];
for fn = 1:videoNum-1
    disp(['��Ƶ������(�۸����ݼ�)��',num2str(fn),'/',num2str(videoNum-1)])
    % ����
    videoName1 = fullfile(rootPath,videoList{fn});
    videoName2 = fullfile(rootPath,videoList{fn+1});
    
    videoObj1 = VideoReader(videoName1);
    videoObj2 = VideoReader(videoName2);

    num = floor(min([MAXN,videoObj1.numberOfFrames,videoObj2.numberOfFrames])/groups);    
    % �������
    for k = 1:num        
        blocks1 = read(videoObj1,[(k-1)*groups+1,k*groups]);
        blocks2 = read(videoObj2,[(k-1)*groups+1,k*groups]);
        [rows,cols,~,frames] = size(blocks1);
        % �����۸���Ƶ
        blocks = fastTamper(blocks1,blocks2,groups);
        % ��Ƶת�Ҷ�
        gray = zeros(rows,cols,2*frames,'uint8');
        for f = 1:groups*2
            gray(:,:,f) = rgb2gray(blocks(:,:,:,f));
        end
        % ��ȡ��������
        featureVector = getFeatureVector(gray);
        TamperFeatureVector = cat(1,TamperFeatureVector,featureVector);
    end    
end

save('.\tmp\fv.mat','NormalFeatureVector','TamperFeatureVector');



function out = fastTamper(in1,in2,len)

in = cat(4,in1,in2);
idx = reshape(1:len,[2,len/2]);
idx = cat(1,idx,idx+len);
idx = idx(:);
out = in(:,:,:,idx);

end


function featureVector = getFeatureVector(src)

frames = size(src,3);
av = double(src);

r = zeros(frames-1,1);
hs = zeros(frames-1,512);
featureVector = zeros(frames-1,513);
for k = 1:frames-1
    r(k) = corr2(av(:,:,k),av(:,:,k+1));
    hs(k,:) = getHSFeature(av(:,:,k),av(:,:,k+1), 0.01, 200);
    if k>1
        featureVector(k,:) = [abs(r(k)-r(k-1)),abs(hs(k,:)-hs(k-1,:))];
    end
end
featureVector(1,:) = [];
end









