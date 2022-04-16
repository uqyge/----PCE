clear;
clc;
uqlab;
%%
% Input Model
rho_1000 = 8;
k = 0.12;

for i=1:32
    Input.Marginals(i).Name = sprintf('T%d',i);
    Input.Marginals(i).Type = 'myDistribution';
    Input.Marginals(i).Parameters = [rho_1000,k,0,rho_1000];
end
myInput = uq_createInput(Input);

%%
load('models')
uq_print(larsModel)

%%
% ¡È√Ù∂»∑÷Œˆ
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
save('outputs/SensRes','res')

%%
FirstOrder = res.FirstOrder;
TotalOrder = res.Total;
t = table(FirstOrder,TotalOrder);
writetable(t,'outputs/sobolIndex.csv')

