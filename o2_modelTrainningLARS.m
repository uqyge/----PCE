clear;
clc;
uqlab;

%%
% Input Model
rho_1000 = 8; k = 0.12;
t = 1:10000;

for i = 1:32
    Input.Marginals(i).Name = sprintf('T%d', i);
    Input.Marginals(i).Type = 'myDistribution';
    Input.Marginals(i).Parameters = [rho_1000, k, 0, rho_1000];
end

myInput = uq_createInput(Input);

%%
% 数据选择
% load('output.mat')
load('.\outputs\fem_out')
% # range_y=[0, 0.1],
Train = output_data;
Train = Train(Train(:, 1) < 100, 2:2 + 32);

Eval = Train(end - 2000:end, :); % 测试集

Xval = Eval(:, 1:end - 1); % 输入T1,T32
Yval = Eval(:, end); % Z23

%%
% PCE LARS
st = 1;
n_samples = [100, 200, 300, 500, 1000, 2000, 4000, 8000] - 1;
% n_samples = [100, 200, 400, 1000, 2000] - 1;
myLARS = cell(numel(n_samples), 1);
disp('LARS计算')

for i = 1:numel(n_samples)
    intl = n_samples(i)
    X_lars = Train(st:st + intl, 1:end - 1);
    Y_lars = Train(st:st + intl, end);

    MetaOpts.Type = 'Metamodel';
    MetaOpts.MetaType = 'PCE';
    MetaOpts.Method = 'LARS';
    MetaOpts.ExpDesign.X = X_lars;
    MetaOpts.ExpDesign.Y = Y_lars;
    MetaOpts.Degree = 1:10;
    MetaOpts.TruncOptions.qNorm = 0.5;
    MetaOpts.ValidationSet.X = Xval;
    MetaOpts.ValidationSet.Y = Yval;
    myLARS{i} = uq_createModel(MetaOpts);

    fprintf('==========%c%c%c%c方法 第%d阶 误差    %d    ==========\n', MetaOpts.Method, myLARS{i}.PCE.Basis.Degree, myLARS{i}.Error.Val)
end

uq_print(myLARS{end})
disp('==================结束==========================')

%%
err_val = [];
err_loo = [];

for i = 1:numel(n_samples)
    err_val = [err_val; myLARS{i}.Error.Val];
    err_loo = [err_loo; myLARS{i}.Error.LOO];
end

iter = n_samples.' + 1
writetable(table(iter, err_val, err_loo), 'outputs/errLars.csv')

%%
f2 = uq_figure;
method = 'LARS';
YLARS = uq_evalModel(myLARS{end}, Xval);
uq_plot(Yval, YLARS, '+');
xlabel('Z23val'); ylabel('Z23LARS')
% figure
corrcoef([Yval, YLARS]) % 相关系数
axis equal
title(sprintf('LARS-order%d', myLARS{end}.PCE.Basis.Degree))
writetable(table(YLARS, Yval), 'outputs/r2Lars.csv')
%%
save('outputs/larsModels.mat', 'myLARS')

%%
