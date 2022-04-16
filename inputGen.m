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

input_rho = uq_getSample(myInput, 10000, 'Sobol');

save('.\DIM-master\input_k012.mat','input_rho')
