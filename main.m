% ������

clear; close all; clc

%% ��Ƶ׼��
% ֱ������Ҫ������Ƶ��Ƶ
videoName = '.\new\src2Delete246350.avi';
[src,srcGray] = loadVideo(videoName);
% ��ȡ��ʵ��
load('.\new\src2246350.mat')

%% �۸ļ�⣨���ַ�����
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


