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
x_org = uq_getSample(myInput, 10000, 'Sobol');
%%
y = uq_evalModel(larsModel, x_org);

%%
histogram(y)
%%