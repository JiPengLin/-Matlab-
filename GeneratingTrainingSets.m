% 获取训练集
clear; close all; clc

rootPath = '.\src'; %路径

dirout = dir(rootPath);
videoList = {dirout(3:end).name}';
videoNum = length(videoList);

MAXN = 300;
groups = 20;

%% 获取未篡改数据集
NormalFeatureVector = [];
for fn = 1:videoNum
    disp(['视频分析中(正常数据集)：',num2str(fn),'/',num2str(videoNum)])
    % 设置
    videoName = fullfile(rootPath,videoList{fn});
    videoObj = VideoReader(videoName);
    num = floor(min([MAXN,videoObj.numberOfFrames])/groups);    
    % 分批获得
    for k = 1:num        
        blocks = read(videoObj,[(k-1)*groups+1,k*groups]);
        [rows,cols,~,frames] = size(blocks);
        % 视频转灰度
        gray = zeros(rows,cols,frames,'uint8');
        for f = 1:groups
            gray(:,:,f) = rgb2gray(blocks(:,:,:,f));
        end
        % 获取特征向量
        featureVector = getFeatureVector(gray);
        NormalFeatureVector = cat(1,NormalFeatureVector,featureVector);
    end    
end

%% 获取篡改数据集
TamperFeatureVector = [];
for fn = 1:videoNum-1
    disp(['视频分析中(篡改数据集)：',num2str(fn),'/',num2str(videoNum-1)])
    % 设置
    videoName1 = fullfile(rootPath,videoList{fn});
    videoName2 = fullfile(rootPath,videoList{fn+1});
    
    videoObj1 = VideoReader(videoName1);
    videoObj2 = VideoReader(videoName2);

    num = floor(min([MAXN,videoObj1.numberOfFrames,videoObj2.numberOfFrames])/groups);    
    % 分批获得
    for k = 1:num        
        blocks1 = read(videoObj1,[(k-1)*groups+1,k*groups]);
        blocks2 = read(videoObj2,[(k-1)*groups+1,k*groups]);
        [rows,cols,~,frames] = size(blocks1);
        % 制作篡改视频
        blocks = fastTamper(blocks1,blocks2,groups);
        % 视频转灰度
        gray = zeros(rows,cols,2*frames,'uint8');
        for f = 1:groups*2
            gray(:,:,f) = rgb2gray(blocks(:,:,:,f));
        end
        % 获取特征向量
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









