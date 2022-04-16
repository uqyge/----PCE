function [Kt] = Assemble_Kt(Kt_spring,Kt_bar,Kt_cable,Kt_cluster,lrx,lry,lrz,nrx,nry,nrz)

Kt = Kt_spring + Kt_bar + Kt_cable + Kt_cluster;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 引入边界条件 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for ii=1:nrx
    nb1=3*lrx(ii)-2;
    Kt(nb1,:)=0;
    Kt(:,nb1)=0;
    Kt(nb1,nb1)=1;
    
end

for jj=1:nry
    nb2=3*lry(jj)-1;
    Kt(:,nb2)=0;
    Kt(nb2,:)=0;
    Kt(nb2,nb2)=1;
    
end

for rr=1:nrz
    nb3=3*lrz(rr);
    Kt(:,nb3)=0;
    Kt(nb3,:)=0;
    Kt(nb3,nb3)=1;
end



end












