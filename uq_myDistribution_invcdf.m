function X=uq_myDistribution_invcdf(F,parameters)
% parameters=[ rho_1000 , k]
rho_1000=parameters(1);k=parameters(2);a=parameters(3);b=parameters(4);
X = rho_1000*( (F-1000*(a/rho_1000).^(1/k)/1000/ ((a/rho_1000).^(1/k) - (b/rho_1000).^(1/k)))/1000*1000* ((b/rho_1000)^(1/k) - (a/rho_1000)^(1/k)) ).^k;
end

