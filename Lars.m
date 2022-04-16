clear;
uqlab;
rho_1000 = 8; k = 0.12;
t=1:10000;
rho_t=rho_1000 * (t / 1000).^(k);


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
input_rho = XX;
save('input_k012.mat','input_rho')

%%
%xinxi=readmatrix('.\DIM-master\data_input\xinxi.csv');
% Disposal_grid2(xinxi{102,6:end}); % 画图

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
% PCE OLS
Order=3;
X_pce = Train(1:1000,2:2+32-1); % 训练集 输入T1,T32
Y_pce = Train(1:1000,end); % Z23

disp('PCE计算')
myPCE = cell(size(Order, 2), 1);
for order=1:Order
    MetaOpts.Type = 'Metamodel';
    MetaOpts.MetaType = 'PCE';
    MetaOpts.Method = 'OLS';
    MetaOpts.ExpDesign.X = X_pce;
    MetaOpts.ExpDesign.Y = Y_pce;
    MetaOpts.Degree = order;
    MetaOpts.ValidationSet.X = Xval;
    MetaOpts.ValidationSet.Y = Yval;
    myPCE{order} = uq_createModel(MetaOpts);
    % uq_print(myLARS{order})
    fprintf('==========%c%c%c方法第%d阶误差    %d    ==========\n',MetaOpts.Method,order,myPCE{order}.Error.Val)
end
%%
uq_print(myPCE{2})

% disp('==================结束==========================')
%%
% PCE LARS
Order=2;
st = 1;
intl = 500-1;
X_lars = Train(st:st+intl,2:2+32-1);
Y_lars = Train(st:st+intl,end);
disp('LARS计算')
myLARS = cell(size(Order, 2), 1);
for order=Order
    MetaOpts.Type = 'Metamodel';
    MetaOpts.MetaType = 'PCE';
    MetaOpts.Method = 'LARS';
    MetaOpts.ExpDesign.X = X_lars;
    MetaOpts.ExpDesign.Y = Y_lars;
%     MetaOpts.Degree = order;
    MetaOpts.Degree = 1:10;
    MetaOpts.TruncOptions.qNorm = 0.75;
    MetaOpts.ValidationSet.X = Xval;
    MetaOpts.ValidationSet.Y = Yval;
    myLARS{order} = uq_createModel(MetaOpts);
    % uq_print(myLARS{order})
    fprintf('==========%c%c%c%c方法第%d阶误差    %d    ==========\n',MetaOpts.Method,order,myLARS{order}.Error.Val)
end
uq_print(myLARS{2})
disp('==================结束==========================')
coef_1 = myLARS{1, 2}.PCE.Coefficients(1);  %PCE模型常数项

%%
sum(myLARS{2}.PCE.Coefficients>0)
%%
sum(myPCE{2}.PCE.Coefficients>0)
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
    YLARS=uq_evalModel(myLARS{2}, Xval);
    YPCE=uq_evalModel(myPCE{2}, Xval);
    uq_plot(Yval, YLARS,'+');
%     uq_plot(Yval, YPCE,'+');
    xlabel('Z23val');ylabel('Z23LARS')
    % figure
    corrcoef([Yval,YLARS])  % 相关系数
    axis equal
    title(sprintf('LARS-order%d', order))
    
    %     plot(Yval, YLARS, '+', 'Markersize', 6)
    %     xlabel('Z23-val');ylabel('Z23-LARS');
end
%%
myPCE{order}
%%
% 灵敏度分析
SobolOpts.Type = 'Sensitivity';
SobolOpts.Method = 'Sobol';
SobolOpts.Sobol.Order = 1;
SobolOpts.Sobol.SampleSize = 1e6;
mySobolAnalysisPCE = uq_createAnalysis(SobolOpts);
uq_display(mySobolAnalysisPCE)
%%
uq_print(mySobolAnalysisPCE)
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
y = uq_evalModel(myLARS, Xval);

hist(y,20)

%%
for i=1:32
    Input2.Marginals(i).Name = sprintf('T%d',i);
    Input2.Marginals(i).Type = 'myDistribution';
    Input2.Marginals(i).Parameters = [rho_1000,0.12,0,rho_1000];
end
Input2.Marginals(1).Parameters = [rho_1000,0.12,0,1*rho_1000];
myInput = uq_createInput(Input2);

X_test = uq_getSample(myInput, 1000, 'Sobol');


figure()
histogram(X_test(:,1))


%%
% X_in=ones(10000,32)*rho_1000;
y = uq_evalModel(myLARS{2}, X_test);
% y = uq_evalModel(myLARS{2}, Xval);
figure()
histogram(y,30)
mean(y)

%%
X_test(1:2,:)
%%
Xval(1:2,:)
%%
a = Eval(Eval(:,1)<100,:)