function f=uq_myDistribution_pdf(X,parameters)
% parameters=[ rho_1000 , k]
rho_1000=parameters(1);k=parameters(2);a=parameters(3);b=parameters(4);
rho_t1=X;
% if X>=a&X<=b
    f=(1000/(rho_1000*k)) * (rho_t1/rho_1000).^((1-k) / k) /1000/ ((a/rho_1000).^(1/k) - (b/rho_1000).^(1/k)) ;
% else
%     f=0;
% end
end

