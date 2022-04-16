function [q,q_bar,q_cable,q_cluster,NF_spring,NF_bar,NF_cable,NF_cluster] = Internal_force(mdof,cluster,m,n,nod,nelem_spring,nelem_bar,nelem_cable,e_bar,e_cable,e_cluster,...
                           a_bar,a_cable,a_cluster,ele_spring,ele_bar,ele_cable,ele_cluster,dis0,L0_bar,L0_cable,L0_cluster,L0_spring,stiff_spring1,stiff_spring2,epsilon_cable_temp)

NF_spring=zeros(nelem_spring,1);NF_bar=zeros(nelem_bar,1);NF_cable=zeros(nelem_cable,1);NF_cluster=zeros(m,1);
q_element=zeros(6,1);q0_spring=zeros(mdof,1);q0_bar=zeros(mdof,1);q0_cable=zeros(mdof,1);q0_cluster=zeros(mdof,1);
q_spring=zeros(mdof,1);q_bar=zeros(mdof,1);q_cable=zeros(mdof,1);q_cluster=zeros(mdof,1);

Ln_spring=zeros(nelem_spring,1);Ln_bar=zeros(nelem_bar,1);epsilon_bar=zeros(nelem_bar,1);epsilon_spring=zeros(nelem_spring,1);
Ln_cable=zeros(nelem_cable,1);epsilon_cable=zeros(nelem_cable,1);
Ln_cluster=zeros(m,1);epsilon_cluster=zeros(m,1);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 计算弹簧单元节点内力 %%%%%%%%%%%%%%%%%%%%%%%%%%

for ie_spring=1:nelem_spring
    
    ni=ele_spring(ie_spring,1);
    nj=ele_spring(ie_spring,2);
    ii=3*ni-2;
    ii1=ii+1;
    ii2=ii+2;
    jj=3*nj-2;
    jj1=jj+1;
    jj2=jj+2;
    
    x1=nod(ni,1);
    y1=nod(ni,2);
    z1=nod(ni,3);
    x2=nod(nj,1);
    y2=nod(nj,2);
    z2=nod(nj,3);    
    
    u1=dis0(3*ni-2);
    v1=dis0(3*ni-1);
    w1=dis0(3*ni);
    u2=dis0(3*nj-2);
    v2=dis0(3*nj-1);
    w2=dis0(3*nj);
    
    x21=x2-x1;y21=y2-y1;z21=z2-z1;
    u21=u2-u1;v21=v2-v1;w21=w2-w1;
    
        
    Ln_spring(ie_spring)=sqrt((x21+u21)^2 + (y21+v21)^2 + (z21+w21)^2);
    
    epsilon_spring(ie_spring)=(Ln_spring(ie_spring)-L0_spring(ie_spring))/L0_spring(ie_spring);
    
    c1=(x21+u21)/Ln_spring(ie_spring);c2=(y21+v21)/Ln_spring(ie_spring);c3=(z21+w21)/Ln_spring(ie_spring);    

    if(ie_spring==5||ie_spring==6||ie_spring==7||ie_spring==8) 
        NF_spring(ie_spring,1)=stiff_spring2*(Ln_spring(ie_spring)-L0_spring(ie_spring));       
    else        
        NF_spring(ie_spring,1)=stiff_spring1*(Ln_spring(ie_spring)-L0_spring(ie_spring));        
    end
        
    
    q_element(1,1)=NF_spring(ie_spring,1)*(-c1);
    q_element(2,1)=NF_spring(ie_spring,1)*(-c2);
    q_element(3,1)=NF_spring(ie_spring,1)*(-c3);
    q_element(4,1)=NF_spring(ie_spring,1)*(c1);
    q_element(5,1)=NF_spring(ie_spring,1)*(c2);
    q_element(6,1)=NF_spring(ie_spring,1)*(c3);
    
    q_spring(ii)=q_element(1,1)+q0_spring(ii);
    q_spring(ii1)=q_element(2,1)+q0_spring(ii1);
    q_spring(ii2)=q_element(3,1)+q0_spring(ii2);
    q_spring(jj)=q_element(4,1)+q0_spring(jj);
    q_spring(jj1)=q_element(5,1)+q0_spring(jj1);
    q_spring(jj2)=q_element(6,1)+q0_spring(jj2);
    
    q0_spring(ii)=q_spring(ii);
    q0_spring(ii1)=q_spring(ii1);
    q0_spring(ii2)=q_spring(ii2);
    q0_spring(jj)=q_spring(jj);
    q0_spring(jj1)=q_spring(jj1);
    q0_spring(jj2)=q_spring(jj2);
    
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 计算杆单元节点内力 %%%%%%%%%%%%%%%%%%%%%%%%%%

for ie_bar=1:nelem_bar
    
    ni=ele_bar(ie_bar,1);
    nj=ele_bar(ie_bar,2);
    ii=3*ni-2;
    ii1=ii+1;
    ii2=ii+2;
    jj=3*nj-2;
    jj1=jj+1;
    jj2=jj+2;
    
    x1=nod(ni,1);
    y1=nod(ni,2);
    z1=nod(ni,3);
    x2=nod(nj,1);
    y2=nod(nj,2);
    z2=nod(nj,3);    
    
    u1=dis0(3*ni-2);
    v1=dis0(3*ni-1);
    w1=dis0(3*ni);
    u2=dis0(3*nj-2);
    v2=dis0(3*nj-1);
    w2=dis0(3*nj);
    
    x21=x2-x1;y21=y2-y1;z21=z2-z1;
    u21=u2-u1;v21=v2-v1;w21=w2-w1;
    
        
    Ln_bar(ie_bar)=sqrt((x21+u21)^2 + (y21+v21)^2 + (z21+w21)^2);
    
    epsilon_bar(ie_bar)=(Ln_bar(ie_bar)-L0_bar(ie_bar))/L0_bar(ie_bar);
    
    c1=(x21+u21)/Ln_bar(ie_bar);c2=(y21+v21)/Ln_bar(ie_bar);c3=(z21+w21)/Ln_bar(ie_bar);    

    NF_bar(ie_bar,1)=a_bar*e_bar*epsilon_bar(ie_bar);
    
    q_element(1,1)=NF_bar(ie_bar,1)*(-c1);
    q_element(2,1)=NF_bar(ie_bar,1)*(-c2);
    q_element(3,1)=NF_bar(ie_bar,1)*(-c3);
    q_element(4,1)=NF_bar(ie_bar,1)*(c1);
    q_element(5,1)=NF_bar(ie_bar,1)*(c2);
    q_element(6,1)=NF_bar(ie_bar,1)*(c3);
    
    q_bar(ii)=q_element(1,1)+q0_bar(ii);
    q_bar(ii1)=q_element(2,1)+q0_bar(ii1);
    q_bar(ii2)=q_element(3,1)+q0_bar(ii2);
    q_bar(jj)=q_element(4,1)+q0_bar(jj);
    q_bar(jj1)=q_element(5,1)+q0_bar(jj1);
    q_bar(jj2)=q_element(6,1)+q0_bar(jj2);
    
    q0_bar(ii)=q_bar(ii);
    q0_bar(ii1)=q_bar(ii1);
    q0_bar(ii2)=q_bar(ii2);
    q0_bar(jj)=q_bar(jj);
    q0_bar(jj1)=q_bar(jj1);
    q0_bar(jj2)=q_bar(jj2);
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 计算cable单元节点内力 %%%%%%%%%%%%%%%%%%%%%%%%

for ie_cable=1:nelem_cable
    
    nii=ele_cable(ie_cable,1);
    njj=ele_cable(ie_cable,2);
    ii=3*nii-2;
    ii1=ii+1;
    ii2=ii+2;
    jj=3*njj-2;
    jj1=jj+1;
    jj2=jj+2;
    
    x1=nod(nii,1);
    y1=nod(nii,2);
    z1=nod(nii,3);
    x2=nod(njj,1);
    y2=nod(njj,2);
    z2=nod(njj,3);    
    
    u1=dis0(3*nii-2);
    v1=dis0(3*nii-1);
    w1=dis0(3*nii);
    u2=dis0(3*njj-2);
    v2=dis0(3*njj-1);
    w2=dis0(3*njj);
    
    x21=x2-x1;y21=y2-y1;z21=z2-z1;
    u21=u2-u1;v21=v2-v1;w21=w2-w1;
      
    
    Ln_cable(ie_cable)=sqrt((x21+u21)^2 + (y21+v21)^2 + (z21+w21)^2);


    %%%%%%%%考虑热膨胀引起的绳索Ln变短
    Ln_cable(ie_cable)=Ln_cable(ie_cable)-L0_cable(ie_cable)*epsilon_cable_temp(ie_cable);
    %%%%%%%%

    
    epsilon_cable(ie_cable)=(Ln_cable(ie_cable)-L0_cable(ie_cable))/L0_cable(ie_cable);

    c1=(x21+u21)/Ln_cable(ie_cable);c2=(y21+v21)/Ln_cable(ie_cable);c3=(z21+w21)/Ln_cable(ie_cable);    

    if(epsilon_cable(ie_cable)<=0)
        e_cable_com=0;
        NF_cable(ie_cable,1)=e_cable_com*a_cable*epsilon_cable(ie_cable);
    else
        NF_cable(ie_cable,1)=e_cable*a_cable*epsilon_cable(ie_cable);
    end
    
    q_element(1,1)=NF_cable(ie_cable,1)*(-c1);
    q_element(2,1)=NF_cable(ie_cable,1)*(-c2);
    q_element(3,1)=NF_cable(ie_cable,1)*(-c3);
    q_element(4,1)=NF_cable(ie_cable,1)*(c1);
    q_element(5,1)=NF_cable(ie_cable,1)*(c2);
    q_element(6,1)=NF_cable(ie_cable,1)*(c3);
    
    q_cable(ii)=q_element(1,1)+q0_cable(ii);
    q_cable(ii1)=q_element(2,1)+q0_cable(ii1);
    q_cable(ii2)=q_element(3,1)+q0_cable(ii2);
    q_cable(jj)=q_element(4,1)+q0_cable(jj);
    q_cable(jj1)=q_element(5,1)+q0_cable(jj1);
    q_cable(jj2)=q_element(6,1)+q0_cable(jj2);
    
    q0_cable(ii)=q_cable(ii);
    q0_cable(ii1)=q_cable(ii1);
    q0_cable(ii2)=q_cable(ii2);
    q0_cable(jj)=q_cable(jj);
    q0_cable(jj1)=q_cable(jj1);
    q0_cable(jj2)=q_cable(jj2);
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%% 计算cluster单元节点内力 %%%%%%%%%%%%%%%%%%%%%%%
for i=1:m
    
    for j=1:n
        
        ie=cluster(i,j);
        niii=ele_cluster(ie,1);
        njjj=ele_cluster(ie,2);
        
        x1=nod(niii,1);
        y1=nod(niii,2);
        z1=nod(niii,3);
        x2=nod(njjj,1);
        y2=nod(njjj,2);
        z2=nod(njjj,3);
        
        u1=dis0(3*niii-2);
        v1=dis0(3*niii-1);
        w1=dis0(3*niii);
        u2=dis0(3*njjj-2);
        v2=dis0(3*njjj-1);
        w2=dis0(3*njjj);
        
        x21=x2-x1;y21=y2-y1;z21=z2-z1;
        u21=u2-u1;v21=v2-v1;w21=w2-w1;
           
        
        Ln(j)=sqrt((x21+u21)^2 + (y21+v21)^2 + (z21+w21)^2);
           
    end
    
    
    Ln_cluster(i)=sum(Ln);
    
    epsilon_cluster(i) = (Ln_cluster(i)-L0_cluster(i))/L0_cluster(i);
    
    if(epsilon_cluster(i)<=0)
        NF_cluster(i)=0;
    else
        NF_cluster(i) = a_cluster*e_cluster*epsilon_cluster(i);
    end
    
    for j=1:n
        
        ie=cluster(i,j);
        niii=ele_cluster(ie,1);
        njjj=ele_cluster(ie,2);
        
        ii=3*niii-2;
        ii1=ii+1;
        ii2=ii+2;
        jj=3*njjj-2;
        jj1=jj+1;
        jj2=jj+2;
    
        x1=nod(niii,1);
        y1=nod(niii,2);
        z1=nod(niii,3);
        x2=nod(njjj,1);
        y2=nod(njjj,2);
        z2=nod(njjj,3);
        
        u1=dis0(3*niii-2);
        v1=dis0(3*niii-1);
        w1=dis0(3*niii);
        u2=dis0(3*njjj-2);
        v2=dis0(3*njjj-1);
        w2=dis0(3*njjj);
        
        x21=x2-x1;y21=y2-y1;z21=z2-z1;
        u21=u2-u1;v21=v2-v1;w21=w2-w1;
        
        
        Ln(j)=sqrt((x21+u21)^2 + (y21+v21)^2 + (z21+w21)^2);
        
        c1=(x21+u21)/Ln(j);c2=(y21+v21)/Ln(j);c3=(z21+w21)/Ln(j);
        
        q_element(1,1)=NF_cluster(i,1)*(-c1);
        q_element(2,1)=NF_cluster(i,1)*(-c2);
        q_element(3,1)=NF_cluster(i,1)*(-c3);
        q_element(4,1)=NF_cluster(i,1)*(c1);
        q_element(5,1)=NF_cluster(i,1)*(c2);
        q_element(6,1)=NF_cluster(i,1)*(c3);
        
        q_cluster(ii)=q_element(1,1)+q0_cluster(ii);
        q_cluster(ii1)=q_element(2,1)+q0_cluster(ii1);
        q_cluster(ii2)=q_element(3,1)+q0_cluster(ii2);
        q_cluster(jj)=q_element(4,1)+q0_cluster(jj);
        q_cluster(jj1)=q_element(5,1)+q0_cluster(jj1);
        q_cluster(jj2)=q_element(6,1)+q0_cluster(jj2);
        
        q0_cluster(ii)=q_cluster(ii);
        q0_cluster(ii1)=q_cluster(ii1);
        q0_cluster(ii2)=q_cluster(ii2);
        q0_cluster(jj)=q_cluster(jj);
        q0_cluster(jj1)=q_cluster(jj1);
        q0_cluster(jj2)=q_cluster(jj2);
        
    end
    
end
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

q = q_spring + q_bar + q_cable + q_cluster;



end
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

    
    
    
    
    
    
    
    
    