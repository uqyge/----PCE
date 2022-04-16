function [Kt_bar,delta_bar,epsilon_bar,L0_bar,Ln_bar,weight_bar] = Assemble_Kt_bar(mdof,nod,nelem_bar,e_bar,a_bar,ele_bar,dis0,delta_bar0)

Kt_bar=zeros(mdof,mdof);
L0_bar=zeros(nelem_bar,1);Ln_bar=zeros(nelem_bar,1);epsilon_bar=zeros(nelem_bar,1);delta_bar=zeros(nelem_bar,1);
weight_bar=zeros(mdof,1);ro_bar=2.7e-5;

cl=[-1,1]';
A=eye(6,6);A(1,4)=-1;A(2,5)=-1;A(3,6)=-1;A(4,1)=-1;A(5,2)=-1;A(6,3)=-1;
% A=A/4;
%============================= 计算clusters的长度 ==========================
for ie_bar=1:nelem_bar
    
    ni=ele_bar(ie_bar,1);
    nj=ele_bar(ie_bar,2);
    
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
    
    x_21=x21+u21;y_21=y21+v21;z_21=z21+w21;
    
    cx=[-x_21,-y_21,-z_21,x_21,y_21,z_21]';
    
    L0_bar(ie_bar)=sqrt((x21)^2 + (y21)^2 + (z21)^2);
    
    L0_bar(ie_bar) = L0_bar(ie_bar) - delta_bar0(ie_bar);
    
    tmp_weight=L0_bar(ie_bar)*a_bar*ro_bar;
    
    Ln_bar(ie_bar)=sqrt((x21+u21)^2 + (y21+v21)^2 + (z21+w21)^2);
    
    delta_bar(ie_bar) = Ln_bar(ie_bar)-L0_bar(ie_bar);
    
    epsilon_bar(ie_bar) = delta_bar(ie_bar) / L0_bar(ie_bar);
    
    c1=(x21+u21)/Ln_bar(ie_bar);c2=(y21+v21)/Ln_bar(ie_bar);c3=(z21+w21)/Ln_bar(ie_bar);
    
    T=[c1,c2,c3,0,0,0;0,0,0,c1,c2,c3];
    
    xishu1=e_bar*a_bar/L0_bar(ie_bar);
    
    ktl=xishu1*cl*cl';
    
    kt1=T'*ktl*T;
    
    xishu2=e_bar*a_bar*epsilon_bar(ie_bar)/Ln_bar(ie_bar);
   
    kt2= xishu2*(A-(1/(Ln_bar(ie_bar)^2)*cx*cx'));
    
    
    kte_bar=kt1 + kt2;
    
    for i=1:3
        for j=1:3
            I=ni*3-3+i;J=ni*3-3+j;
            Kt_bar(I,J)=Kt_bar(I,J)+kte_bar(i,j);
        end
    end
    
    for i=1:3
        for j=4:6
            I=ni*3-3+i;J=nj*3-3+(j-3);
            Kt_bar(I,J)=Kt_bar(I,J)+kte_bar(i,j);
        end
    end
    
    for i=4:6
        for j=1:3
            I=nj*3-3+(i-3);J=ni*3-3+j;
            Kt_bar(I,J)=Kt_bar(I,J)+kte_bar(i,j);
        end
    end
    
    for i=4:6
        for j=4:6
            I=nj*3-3+(i-3);J=nj*3-3+(j-3);
            Kt_bar(I,J)=Kt_bar(I,J)+kte_bar(i,j);
        end
    end
    
    
    weight_bar(3*ni)=(1/2)*tmp_weight + weight_bar(3*ni);
    weight_bar(3*nj)=(1/2)*tmp_weight + weight_bar(3*nj);
    
    
    
    
end


end














