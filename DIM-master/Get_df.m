function [df,f] = Get_df(f,q,weight,lrx,lry,lrz,nrx,nry,nrz)


df = f + weight - q;

for ii=1:nrx
    df(3*lrx(ii)-2)=0;
end

for jj=1:nry
    df(3*lry(jj)-1)=0;
end

for kk=1:nrz
    df(3*lrz(kk))=0;
end



end