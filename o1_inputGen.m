clear;
uqlab;
rho_1000 = 4;
k = 0.12;
t = 10000;
rho_max = rho_1000 * (t / 1000).^(k);

%%
% Input Model
for i = 1:32
    Input.Marginals(i).Name = sprintf('T%d', i);
    Input.Marginals(i).Type = 'myDistribution';
    Input.Marginals(i).Parameters = [rho_1000, k, 0, rho_1000];
end

opt = 2

if (opt ~= 0)
    Input.Marginals(opt).Parameters = [rho_1000, 0.19, 0, 0.5 * rho_1000];
end

myInput = uq_createInput(Input);

sample = 10000;
input_rho = uq_getSample(myInput, sample, 'Sobol');

save(['.\DIM-master\input_k_', num2str(k * 100), '_rho1000_', num2str(rho_1000), '_sobol_', num2str(sample), '_opt_', num2str(opt)], 'input_rho')
