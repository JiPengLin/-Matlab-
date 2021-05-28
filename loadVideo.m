function  [frame,gray] = loadVideo(srcVideo)

obj = VideoReader(srcVideo);
frame = read(obj);%获取该视频对象的所有帧
[rows,cols,~,frames] = size(frame);
% 视频转灰度
gray = zeros(rows,cols,frames,'uint8');
for f = 1:frames
    gray(:,:,f) = rgb2gray(frame(:,:,:,f));  
end

end