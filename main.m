% 主函数

clear; close all; clc

%% 视频准备
% 直接上需要检测的视频视频
videoName = '.\new\src2Delete246350.avi';
[src,srcGray] = loadVideo(videoName);
% 读取真实答案
load('.\new\src2246350.mat')

%% 篡改检测（三种方法）
labelNum = 3;
type = 3;
if type==1
    check = idxDelete;
    check1 = checkErrorFramePoint(srcGray);
    check2 = checkErrorFramePointByKmeans(srcGray,labelNum);
    check3 = checkErrorFramePointBySVM(srcGray);
elseif type==2
    check = idxInsert;
    check1 = checkErrorFramePoint(srcGray);    
    check2 = checkErrorFramePointByKmeans(srcGray,labelNum);
    check3 = checkErrorFramePointBySVM(srcGray);
else
    check = idxReplace;
    check1 = checkErrorFramePoint(srcGray);
    check2 = checkErrorFramePointByKmeans(srcGray,labelNum);
    check3 = checkErrorFramePointBySVM(srcGray);    
end

A = check
B = check1
C = check2
D = check3


