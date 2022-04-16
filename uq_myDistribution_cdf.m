function F=uq_myDistribution_cdf(X,parameters)
% parameters=[ rho_1000 , k]
rho_1000=parameters(1);k=parameters(2);a=parameters(3);b=parameters(4);
rho_t1=X;

    F=-( 1000*(rho_t1/rho_1000).^(1/k)/1000/ ((a/rho_1000).^(1/k) - (b/rho_1000).^(1/k))-...
   1000*(a/rho_1000).^(1/k)/1000/ ((a/rho_1000).^(1/k) - (b/rho_1000).^(1/k)) );


end

