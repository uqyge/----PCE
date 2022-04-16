clear;
uqlab;
rho_1000 = 8; k = 0.12;
t=1:10000;
rho_t=rho_1000 * (t / 1000).^(k);
%xinxi=readmatrix('.\DIM-master\data_input\xinxi.csv');
% Disposal_grid2(xinxi{102,6:end}); % 画图
%% 
% 数据选择
Train = xinxi(:, 1:139);
Tidx = Train((sum(Train(:,[107:108,110,112:128,130:138])==0,2)>0), 1);

Train(sum((Train(:,1)==Tidx'),2)>0, :) = [];

Train(Train(:,105)<40, :) = [];
Train(isnan(Train(:, 105)), :) = [];
%%
% Input Model
for i=1:32
    Input.Marginals(i).Name = sprintf('T%d',i);
    Input.Marginals(i).Type = 'myDistribution';
    Input.Marginals(i).Parameters = [rho_1000,k,min(rho_t),max(rho_t)];
end
myInput = uq_createInput(Input);

XX = uq_getSample(myInput, 10000, 'Sobol');
%%
Eval = Train(end-2000:end, :); % 测试集
Xval = Eval(:,3:34); % 输入T1,T32
Yval = Eval(:,105); % Z23
%%
% PCE OLS
Order=2;
X = Train(1:7000,3:34); % 训练集 输入T1,T32
Y = Train(1:7000,105); % Z23

disp('PCE计算')
myLARS = cell(size(Order, 2), 1);
for order=Order
MetaOpts.Type = 'Metamodel';
MetaOpts.MetaType = 'PCE';
MetaOpts.Method = 'OLS';
MetaOpts.ExpDesign.X = X;
MetaOpts.ExpDesign.Y = Y;
MetaOpts.Degree = order;
MetaOpts.ValidationSet.X = Xval;
MetaOpts.ValidationSet.Y = Yval;
myLARS = uq_createModel(MetaOpts);
% uq_print(myLARS{order})
fprintf('==========%c%c%c方法第%d阶误差    %d    ==========\n',MetaOpts.Method,order,myLARS.Error.Val)
end

% disp('==================结束==========================')
%%
% PCE LARS
Order=2;
X = Train(1:300,3:34);
Y = Train(1:300,105);
disp('LARS计算')
myLARS = cell(size(Order, 2), 1);
for order=Order
MetaOpts.Type = 'Metamodel';
MetaOpts.MetaType = 'PCE';
MetaOpts.Method = 'LARS';
MetaOpts.ExpDesign.X = X;
MetaOpts.ExpDesign.Y = Y;
MetaOpts.Degree = order;
MetaOpts.ValidationSet.X = Xval;
MetaOpts.ValidationSet.Y = Yval;
myLARS{order} = uq_createModel(MetaOpts);
% uq_print(myLARS{order})
fprintf('==========%c%c%c%c方法第%d阶误差    %d    ==========\n',MetaOpts.Method,order,myLARS{order}.Error.Val)
end
disp('==================结束==========================')
coef_1 = myLARS{1, 2}.PCE.Coefficients(1);  %PCE模型常数项
% save('.\Output_data\myLARS7000(1,3)','myLARS')
% uq_print(myLARS(1))
% uq_display(myPCE);
% fig = gcf;
% fig.Name = 'LARSPCE';
% print(fig,'./figs/sparsity.png','-dpng');
%%
for order = Order
    f2 = uq_figure;
    method='LARS';
    YLARS=uq_evalModel(myLARS{order}, Xval);
    uq_plot(Yval, YLARS,'+');
    xlabel('Z23val');ylabel('Z23LARS')
% figure
    corrcoef([Yval,YLARS])  % 相关系数
    axis equal
    title(sprintf('LARS-order%d', order))

%     plot(Yval, YLARS, '+', 'Markersize', 6)
%     xlabel('Z23-val');ylabel('Z23-LARS');
end
%%
% 灵敏度分析
SobolOpts.Type = 'Sensitivity';
SobolOpts.Method = 'Sobol';
SobolOpts.Sobol.Order = 2;
mySobolAnalysisPCE = uq_createAnalysis(SobolOpts);
uq_display(mySobolAnalysisPCE)
%% 
% 可靠性分析
for R_f = 53.9096*[0.001 0.005 0.01 0.05]
    myLARS{1, 2}.PCE.Coefficients(1)=-abs(coef_1 - 53.9096)...
        + R_f;
    FORMOpts.Type = 'Reliability';
    FORMOpts.Method = 'FORM';
    FORMAnalysis = uq_createAnalysis(FORMOpts);
%     uq_print(FORMAnalysis)
    disp(FORMAnalysis.Results.Pf)
    uq_display(FORMAnalysis)
end


%%
 y = uq_evalModel(myLARS, Xval)
 
 hist(y,20)
 
 %%
 for i=1:32
    Input2.Marginals(i).Name = sprintf('T%d',i);
    Input2.Marginals(i).Type = 'myDistribution';
    Input2.Marginals(i).Parameters = [rho_1000,0.12,min(rho_t),max(rho_t)];
 end
Input2.Marginals(1).Parameters = [rho_1000,0.12,min(rho_t),max(rho_t)];
myInput = uq_createInput(Input2);

XX = uq_getSample(myInput, 10000, 'Sobol');


%hist(XX)
%%
figure()
hist(XX(:,1))


%%
X_in=ones(10000,32)*max(rho_t);
y = uq_evalModel(myLARS{2}, X_in);
figure()
hist(y,30)
max(y)
%%
input_rho = XX;

%%
save('input.mat','input_rho')
%%
load('input.mat')