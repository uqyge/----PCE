clear;
clc;
uqlab;

%%
% Input Model
rho_1000 = 4; k = 0.12;
t = 1:10000;

for i = 1:32
    Input.Marginals(i).Name = sprintf('T%d', i);
    Input.Marginals(i).Type = 'myDistribution';
    Input.Marginals(i).Parameters = [rho_1000, k, 0, rho_1000];
end

myInput = uq_createInput(Input);

%%
% 数据选择
load('.\outputs\output_input_k_12_rho1000_4_sobol_10000_opt_0')

Train = output_data;
Train = Train(Train(:, 1) < 100, 2:1 + 32 + 3 + 1);

Eval = Train(end - 2000:end, :); % 测试集

Xval = Eval(:, 1:32); % 输入T1,T32

y_id = 36
Yval = Eval(:, y_id); % Z23

%%
% PCE LARS
qnorm = 0.75
st = 1;
n_samples = [100, 200, 300, 500, 1000, 2000, 4000, 8000] - 1;
% n_samples = [100, 200, 400, 1000, 2000] - 1;
myLARS = cell(numel(n_samples), 1);
disp('LARS计算')

for i = 1:numel(n_samples)
    intl = n_samples(i)
    X_lars = Train(st:st + intl, 1:32);
    Y_lars = Train(st:st + intl, y_id);

    MetaOpts.Type = 'Metamodel';
    MetaOpts.MetaType = 'PCE';
    MetaOpts.Method = 'LARS';
    MetaOpts.ExpDesign.X = X_lars;
    MetaOpts.ExpDesign.Y = Y_lars;
    MetaOpts.Degree = 1:10;
    MetaOpts.TruncOptions.qNorm = qnorm;
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

suffix = ['_qnorm_', num2str(qnorm * 100), '_yid_', num2str(y_id)];

iter = n_samples.' + 1;
% writetable(table(iter, err_val, err_loo), ['outputs/errLars_qnorm_', num2str(qnorm * 100), '_yid_', num2str(y_id), '.csv'])
writetable(table(iter, err_val, err_loo), ['outputs/errLars', suffix, '.csv'])

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
% writetable(table(YLARS, Yval), ['outputs/r2Lars_qnorm_', num2str(qnorm * 100), '_yid_', num2str(y_id), '.csv'])
writetable(table(YLARS, Yval), ['outputs/r2Lars', suffix, '.csv'])
%%
save(['outputs/larsModels', suffix], 'myLARS')

%%
