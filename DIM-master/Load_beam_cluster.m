function [f]=Load_beam_cluster(load_step,nnode,mdof,lrx,lry,lrz,nrx,nry,nrz)   

f=zeros(mdof,1);


% f(18*3,1)= 0*load_step;
% f(23*3,1)= 0*load_step;



for ii=1:nrx
    nb1=3*lrx(ii)-2;
    f(nb1,1)=0;
end

for jj=1:nry
    nb2=3*lry(jj)-1;
    f(nb2,1)=0;
end

for rr=1:nrz
    nb3=3*lrz(rr);
    f(nb3,1)=0;
end



end











