function saveNewVideo(frame,frameName)

myObj = VideoWriter(frameName);%��ʼ��һ��avi�ļ� 
myObj.FrameRate = 25; 
open(myObj); 

for f = 1:size(frame,4)%ͼ�����и��� 
    writeVideo(myObj,frame(:,:,:,f)); 
end  
close(myObj); 
end