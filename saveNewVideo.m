function saveNewVideo(frame,frameName)

myObj = VideoWriter(frameName);%初始化一个avi文件 
myObj.FrameRate = 25; 
open(myObj); 

for f = 1:size(frame,4)%图像序列个数 
    writeVideo(myObj,frame(:,:,:,f)); 
end  
close(myObj); 
end