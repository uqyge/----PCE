clear;
uqlab;
rho_1000 = 8;
k = 0.12;
t = 1:10000;
rho_t = rho_1000 * (t / 1000).^(k);

%%
% Input Model
for i = 1:32
    Input.Marginals(i).Name = sprintf('T%d', i);
    Input.Marginals(i).Type = 'myDistribution';
    Input.Marginals(i).Parameters = [rho_1000, k, 0, rho_1000];
end

Input.Marginals(1).Parameters = [rho_1000, 0.19, 0, 0.5 * rho_1000];
myInput = uq_createInput(Input);

sample = 10000;
input_rho = uq_getSample(myInput, sample, 'Sobol');

k_split = split(num2str(k), '.');
k_split = k_split{2};
save(['.\DIM-master\input_k_', num2str(k_split), '_rho1000_', num2str(rho_1000), '_sobol_', num2str(sample)], 'input_rho')
