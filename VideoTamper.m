
function VideoTamper()

clc

 % ԭʼ��Ƶ
srcVideo = '.\original\src6.mp4';
% �۸�ʱҪ�������Ƶ
otherVideo = '.\original\src6.mp4';
% ������Ƶ
[src,~] = loadVideo(srcVideo);
[other,~] = loadVideo(otherVideo);

% ��Ƶʱ��
[grayRows,grayCols,~,grayFrames] = size(src);
[otherRows,otherCols,~,otherFrames] = size(other);
if grayFrames<210||otherFrames<210
   disp('��Ƶ̫�̣��޷����д۸�') 
end
if (grayRows~=otherRows)||(grayCols~=otherCols)
   disp('ԭʼ��Ƶ�ʹ۸���Ƶ�ߴ粻ͬ���޷��۸�') 
end

% �������λ��
sliceLength = [10,20,30,40,50,60];  % �۸ļ��
gap = (grayFrames-sum(sliceLength))/(length(sliceLength)+1)/2; % ���δ۸ĵļ��
sliceInterval = round(rand(1,6)*gap+gap);
[~,idx] = sort(sliceInterval);

sliceLength = sliceLength(idx);
changeTimePoint = [sliceInterval;sliceLength];
changeTimePoint = cumsum(changeTimePoint(:));
CTP = reshape(changeTimePoint,[2,6])+[1;0];

% �ü���Ƶ��Ҫ�������Ƶ��
aa = [0,cumsum(sliceLength)];
tamperOther = cell(6,1);
for k = 1:6
    tamperOther{k} = other(:,:,:,aa(k)+1:aa(k+1));   
end

% ɾ��֡
tamperDelete = src;
for k = length(sliceLength):-1:1
    tamperDelete(:,:,:,CTP(1,k):CTP(2,k)) = [];
end
% ����֡
tamperInsert = src;
for k = length(sliceLength):-1:1
    tamperInsert = cat(4,tamperInsert(:,:,:,1:CTP(1,k)),...
                            tamperOther{k},tamperInsert(:,:,:,CTP(1,k):end));
end
% �滻֡
tamperReplace = src;
for k = length(sliceLength):-1:1
    tamperReplace(:,:,:,CTP(1,k):CTP(2,k)) = tamperOther{k};
end

E = cumsum([0,sliceLength]);
idxDelete = CTP(1,:)-E(1:6);
idxInsert = CTP+E(1:6);
idxInsert = idxInsert(:)';
idxReplace = CTP(:)';

%% ����۸ĵ���Ƶ
[~,filename] = fileparts(srcVideo);
seriesID = 100000+floor(rand()*900000);
save(['.\new(tongyuan)\',filename,num2str(seriesID),'.mat'],'idxDelete','idxInsert','idxReplace')
saveNewVideo(tamperDelete,['.\new(tongyuan)\',filename,'Delete',num2str(seriesID),'.avi'])
saveNewVideo(tamperInsert,['.\new(tongyuan)\',filename,'Insert',num2str(seriesID),'.avi'])
saveNewVideo(tamperReplace,['.\new(tongyuan)\',filename,'Replace',num2str(seriesID),'.avi'])

end
