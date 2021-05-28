
function VideoTamper()

clc

 % 原始视频
srcVideo = '.\original\src6.mp4';
% 篡改时要插入的视频
otherVideo = '.\original\src6.mp4';
% 加载视频
[src,~] = loadVideo(srcVideo);
[other,~] = loadVideo(otherVideo);

% 视频时长
[grayRows,grayCols,~,grayFrames] = size(src);
[otherRows,otherCols,~,otherFrames] = size(other);
if grayFrames<210||otherFrames<210
   disp('视频太短，无法进行篡改') 
end
if (grayRows~=otherRows)||(grayCols~=otherCols)
   disp('原始视频和篡改视频尺寸不同，无法篡改') 
end

% 生成随机位置
sliceLength = [10,20,30,40,50,60];  % 篡改间隔
gap = (grayFrames-sum(sliceLength))/(length(sliceLength)+1)/2; % 两次篡改的间隔
sliceInterval = round(rand(1,6)*gap+gap);
[~,idx] = sort(sliceInterval);

sliceLength = sliceLength(idx);
changeTimePoint = [sliceInterval;sliceLength];
changeTimePoint = cumsum(changeTimePoint(:));
CTP = reshape(changeTimePoint,[2,6])+[1;0];

% 裁剪视频（要插入的视频）
aa = [0,cumsum(sliceLength)];
tamperOther = cell(6,1);
for k = 1:6
    tamperOther{k} = other(:,:,:,aa(k)+1:aa(k+1));   
end

% 删除帧
tamperDelete = src;
for k = length(sliceLength):-1:1
    tamperDelete(:,:,:,CTP(1,k):CTP(2,k)) = [];
end
% 插入帧
tamperInsert = src;
for k = length(sliceLength):-1:1
    tamperInsert = cat(4,tamperInsert(:,:,:,1:CTP(1,k)),...
                            tamperOther{k},tamperInsert(:,:,:,CTP(1,k):end));
end
% 替换帧
tamperReplace = src;
for k = length(sliceLength):-1:1
    tamperReplace(:,:,:,CTP(1,k):CTP(2,k)) = tamperOther{k};
end

E = cumsum([0,sliceLength]);
idxDelete = CTP(1,:)-E(1:6);
idxInsert = CTP+E(1:6);
idxInsert = idxInsert(:)';
idxReplace = CTP(:)';

%% 保存篡改的视频
[~,filename] = fileparts(srcVideo);
seriesID = 100000+floor(rand()*900000);
save(['.\new(tongyuan)\',filename,num2str(seriesID),'.mat'],'idxDelete','idxInsert','idxReplace')
saveNewVideo(tamperDelete,['.\new(tongyuan)\',filename,'Delete',num2str(seriesID),'.avi'])
saveNewVideo(tamperInsert,['.\new(tongyuan)\',filename,'Insert',num2str(seriesID),'.avi'])
saveNewVideo(tamperReplace,['.\new(tongyuan)\',filename,'Replace',num2str(seriesID),'.avi'])

end
