function  [frame,gray] = loadVideo(srcVideo)

obj = VideoReader(srcVideo);
frame = read(obj);%��ȡ����Ƶ���������֡
[rows,cols,~,frames] = size(frame);
% ��Ƶת�Ҷ�
gray = zeros(rows,cols,frames,'uint8');
for f = 1:frames
    gray(:,:,f) = rgb2gray(frame(:,:,:,f));  
end

end