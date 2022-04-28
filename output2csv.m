clear
clc

%%
load('C:\Users\edison\Desktop\张拉整体PCE\outputs\output_input_k_12_rho1000_4_sobol_10000_opt_2.mat')

%%
out_tab = array2table(output_data(:, 34:37), 'VariableNames', {'x', 'y', 'z', 'd'});
writetable(out_tab, '.\outputs\fem_opt_2.csv')
