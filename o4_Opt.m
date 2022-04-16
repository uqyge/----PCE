clear;
clc;
uqlab;
%%
% Input Model
rho_1000 = 8;
k = 0.12;

for i = 1:32
    Input.Marginals(i).Name = sprintf('T%d', i);
    Input.Marginals(i).Type = 'myDistribution';
    Input.Marginals(i).Parameters = [rho_1000, k, 0, rho_1000];
end

myInput = uq_createInput(Input);

%%
load('.\outputs\larsModels')
larsModel = myLARS{end}
uq_print(larsModel)

%%
x_org = uq_getSample(myInput, 10000, 'Sobol');
%%
y = uq_evalModel(larsModel, x_org);

%%
histogram(y)
%%
for i = 1:32
    Input.Marginals(i).Name = sprintf('T%d', i);
    Input.Marginals(i).Type = 'myDistribution';
    Input.Marginals(i).Parameters = [rho_1000, k, 0, rho_1000];
end

Input.Marginals(1).Parameters = [rho_1000, 0.19, 0, 0.5 * rho_1000];
myInput_opt_1 = uq_createInput(Input);
x_opt_1 = uq_getSample(myInput_opt_1, 10000, 'Sobol');

%%
for i = 1:32
    Input.Marginals(i).Name = sprintf('T%d', i);
    Input.Marginals(i).Type = 'myDistribution';
    Input.Marginals(i).Parameters = [rho_1000, k, 0, rho_1000];
end

k_opt = 0.19;
rho_opt = 0.5 * rho_1000;
Input.Marginals(2).Parameters = [rho_1000, k_opt, 0, rho_opt];
myInput_opt_2 = uq_createInput(Input);
x_opt_2 = uq_getSample(myInput_opt_2, 10000, 'Sobol');
%%
y_opt_1 = uq_evalModel(larsModel, x_opt_1);
y_opt_2 = uq_evalModel(larsModel, x_opt_2);

%%
figure()
histogram(y_opt_1)

%%
figure()
histogram(y_opt_2)
%%
writetable(table(y, y_opt_1, y_opt_2), '.\outputs\y_opt.csv')
