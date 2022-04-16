function [Kt_spring,delta_spring,epsilon_spring,L0_spring,weight_spring] = Assemble_Kt_spring(mdof,nod,nelem_spring,stiff_spring1,stiff_spring2,ele_spring,dis0,delta_spring0)

Kt_spring=zeros(mdof,mdof);
L0_spring=zeros(nelem_spring,1);Ln_spring=zeros(nelem_spring,1);epsilon_spring=zeros(nelem_spring,1);delta_spring=zeros(nelem_spring,1);
weight_spring=zeros(mdof,1);ro_spring=0;

cl=[-1,1]';
A=eye(6,6);A(1,4)=-1;A(2,5)=-1;A(3,6)=-1;A(4,1)=-1;A(5,2)=-1;A(6,3)=-1;
% A=A/4;
%============================= 计算clusters的长度 ==========================
for ie_spring=1:nelem_spring
          
    
    ni=ele_spring(ie_spring,1);
    nj=ele_spring(ie_spring,2);
    
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
    
    L0_spring(ie_spring)=sqrt((x21)^2 + (y21)^2 + (z21)^2);
    
    L0_spring(ie_spring) = L0_spring(ie_spring) - delta_spring0(ie_spring);
    
%     L0_spring(ie_spring) = 0.8 * L0_spring(ie_spring);
    
    Ln_spring(ie_spring)=sqrt((x21+u21)^2 + (y21+v21)^2 + (z21+w21)^2);
    
    delta_spring(ie_spring) = Ln_spring(ie_spring)-L0_spring(ie_spring);
    
    epsilon_spring(ie_spring) = delta_spring(ie_spring) / L0_spring(ie_spring);
    
    c1=(x21+u21)/Ln_spring(ie_spring);c2=(y21+v21)/Ln_spring(ie_spring);c3=(z21+w21)/Ln_spring(ie_spring);
    
    T=[c1,c2,c3,0,0,0;0,0,0,c1,c2,c3];
    
    if(ie_spring==5||ie_spring==6||ie_spring==7||ie_spring==8)
        xishu1=stiff_spring2;
        xishu2=stiff_spring2;
    else
        xishu1=stiff_spring1;
        xishu2=stiff_spring1;
    end
    
    ktl=xishu1*cl*cl';
    
    kt1=T'*ktl*T;
    
    xishu2=xishu2 * delta_spring(ie_spring)/Ln_spring(ie_spring);
   
    kt2= xishu2*(A-(1/(Ln_spring(ie_spring)^2)*cx*cx'));
    
    
    kte_spring=kt1 + kt2;
    
    for i=1:3
        for j=1:3
            I=ni*3-3+i;J=ni*3-3+j;
            Kt_spring(I,J)=Kt_spring(I,J)+kte_spring(i,j);
        end
    end
    
    for i=1:3
        for j=4:6
            I=ni*3-3+i;J=nj*3-3+(j-3);
            Kt_spring(I,J)=Kt_spring(I,J)+kte_spring(i,j);
        end
    end
    
    for i=4:6
        for j=1:3
            I=nj*3-3+(i-3);J=ni*3-3+j;
            Kt_spring(I,J)=Kt_spring(I,J)+kte_spring(i,j);
        end
    end
    
    for i=4:6
        for j=4:6
            I=nj*3-3+(i-3);J=nj*3-3+(j-3);
            Kt_spring(I,J)=Kt_spring(I,J)+kte_spring(i,j);
        end
    end
    
    
    
    
    
end


end














