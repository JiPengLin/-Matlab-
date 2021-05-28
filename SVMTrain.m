% SVM
clear; clc

%% 训练集准备
load('.\tmp\fv4.mat')
normalNum = size(NormalFeatureVector,1);
tamperNum = size(TamperFeatureVector,1);
Label = cat(1,ones(normalNum,1),2*ones(tamperNum,1));
FeatureVector = cat(1,NormalFeatureVector,TamperFeatureVector);

x = 1:(normalNum+tamperNum);
plot(x(Label==1),FeatureVector(Label==1,1),'b-'),hold on
plot(x(Label==2),FeatureVector(Label==2,1),'r-'),grid on


%% 训练
% 训练分类模型
svmModel = fitcsvm(FeatureVector,Label);
% 自检
classification = predict(svmModel,FeatureVector);

Accuracy = length(find(Label==classification))/length(Label);
disp(['自检准确率 ',num2str(Accuracy)]);

% 保存
save('.\tmp\svmModel4.mat','svmModel')
























