clear;
clc;
uqlab;
rho_1000 = 8;
k = 0.12;
%%
% Input Model
for i=1:32
    Input.Marginals(i).Name = sprintf('T%d',i);
    Input.Marginals(i).Type = 'myDistribution';
    Input.Marginals(i).Parameters = [rho_1000,k,0,rho_1000];
end
myInput = uq_createInput(Input);

XX = uq_getSample(myInput, 10000, 'Sobol');
%%
load('output.mat')
% 数据选择
Train = output_data;
Train = Train(Train(:,1)<100,:);

%%
Eval = Train(end-2000:end, :); % 测试集
% Eval = Train(end-300:end, :); % 测试集
% Eval = Train(700:1000, :); % 测试集
Xval = Eval(:,2:2+32-1); % 输入T1,T32
Yval = Eval(:,end); % Z23

%%
load('models')
%%
uq_print(larsModel)
%%
% 灵敏度分析
SobolOpts.Model = larsModel;
SobolOpts.Type = 'Sensitivity';
SobolOpts.Method = 'Sobol';
SobolOpts.Sobol.Order = 1;
SobolOpts.Sobol.SampleSize = 1e5;

mySobolAnalysisPCE = uq_createAnalysis(SobolOpts);
%%
uq_print(mySobolAnalysisPCE)

%%
uq_display(mySobolAnalysisPCE)
%%
res = mySobolAnalysisPCE.Results

%%
save('SensRes','res')