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
Train = output_data;
Train = Train(Train(:, 1) < 100, 2:2 + 32);

Eval = Train(end - 2000:end, :); % 测试集

Xval = Eval(:, 1:end - 1); % 输入T1,T32
Yval = Eval(:, end); % Z23

%%
% PCE LARS
st = 1;
n_samples = [100, 200, 300, 500, 1000, 2000, 4000, 8000] - 1;
Order = 6;

err_val_table = zeros(numel(n_samples), Order);
err_loo_table = zeros(numel(n_samples), Order);
names_val = {};
names_loo = {};
names_y = cell(1, 1 + Order);
names_y{1} = 'eval';
Y_tab = [];
Y_tab = [Y_tab, Yval];

for order = 1:Order
    % n_samples = [100,200,400]-1;
    myLARS = cell(numel(n_samples), 1);
    disp('OLS计算')

    for i = 1:numel(n_samples)
        intl = n_samples(i);
        X_lars = Train(st:st + intl, 1:end - 1);
        Y_lars = Train(st:st + intl, end);

        MetaOpts.Type = 'Metamodel';
        MetaOpts.MetaType = 'PCE';
        MetaOpts.Method = 'OLS';
        MetaOpts.ExpDesign.X = X_lars;
        MetaOpts.ExpDesign.Y = Y_lars;
        MetaOpts.Degree = order;
        MetaOpts.TruncOptions.qNorm = 0.5;
        MetaOpts.ValidationSet.X = Xval;
        MetaOpts.ValidationSet.Y = Yval;
        myLARS{i} = uq_createModel(MetaOpts);
        err_val_table(i, order) = myLARS{i}.Error.Val;
        err_loo_table(i, order) = myLARS{i}.Error.LOO;

        fprintf('==========%c%c%c%c方法 第%d阶 误差    %d    ==========\n', MetaOpts.Method, myLARS{i}.PCE.Basis.Degree, myLARS{i}.Error.Val)
    end

    names_val = [names_val, ['err_var_', num2str(order)]];
    names_loo = [names_loo, ['err_loo_', num2str(order)]];
    names_y{order + 1} = ['order_', num2str(order)];
    uq_print(myLARS{end})
    Y_tab = [Y_tab, uq_evalModel(myLARS{end}, Xval)];
end

disp('==================结束==========================')

%%
iter = n_samples.' + 1;
err = array2table(cat(2, iter, err_val_table, err_loo_table), 'VariableNames', ['iter', names_val, names_loo]);
writetable(err, 'outputs/errPCE.csv')

%%

r2_tab = array2table(Y_tab, 'VariableNames', names_y);
writetable(r2_tab, 'outputs/r2PCE.csv')
%%
uq_plot(r2_tab.eval, r2_tab.order_1, '+')
