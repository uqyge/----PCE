function [fe]=Load_grid2(nnode,load_step,mdof,lrx,lry,lrz,nrx,nry,nrz)   

f=zeros(mdof,1);

for i=1:nnode
    f(3*i,1)= 1*load_step;
end


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


fe=f;

end