function [Kt_cable,delta_cable,epsilon_cable,L0_cable,Ln_cable,weight_cable] = Assemble_Kt_cable(mdof,nod,nelem_cable,e_cable,a_cable,ele_cable,dis0,delta_cable0,epsilon_cable_temp)

Kt_cable=zeros(mdof,mdof);
L0_cable=zeros(nelem_cable,1);Ln_cable=zeros(nelem_cable,1);epsilon_cable=zeros(nelem_cable,1);delta_cable=zeros(nelem_cable,1);
weight_cable=zeros(mdof,1);ro_cable=7.85e-5;

cl=[-1,1]';
A=eye(6,6);A(1,4)=-1;A(2,5)=-1;A(3,6)=-1;A(4,1)=-1;A(5,2)=-1;A(6,3)=-1;
% A=A/4;
%============================= 计算cable的长度 ==========================
for ie_cable=1:nelem_cable
    
    nii=ele_cable(ie_cable,1);
    njj=ele_cable(ie_cable,2);
    
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
    
    x_21=x21+u21;y_21=y21+v21;z_21=z21+w21;
    
    cx=[-x_21,-y_21,-z_21,x_21,y_21,z_21]';
    
    
    L0_cable(ie_cable)=sqrt((x21)^2 + (y21)^2 + (z21)^2);
    
    L0_cable(ie_cable) = L0_cable(ie_cable) - delta_cable0(ie_cable);
     
    tmp_weight=L0_cable(ie_cable)*a_cable*ro_cable;
     
    
    %%%%%%%%考虑热膨胀引起的绳索L0变长
%     L0_cable(ie_cable)=L0_cable(ie_cable)+L0_cable(ie_cable)*epsilon_cable_temp(ie_cable);
    
    %%%%%%%%
    
    Ln_cable(ie_cable)=sqrt((x21+u21)^2 + (y21+v21)^2 + (z21+w21)^2);

    
    %%%%%%%%考虑热膨胀引起的绳索Ln变短
    Ln_cable(ie_cable)=Ln_cable(ie_cable)-L0_cable(ie_cable)*epsilon_cable_temp(ie_cable);
    %%%%%%%%
    
    delta_cable(ie_cable) = Ln_cable(ie_cable) - L0_cable(ie_cable);
    
    epsilon_cable(ie_cable)= delta_cable(ie_cable) / L0_cable(ie_cable);
    
    
    c1=(x21+u21)/Ln_cable(ie_cable);c2=(y21+v21)/Ln_cable(ie_cable);c3=(z21+w21)/Ln_cable(ie_cable);
    
    T=[c1,c2,c3,0,0,0;0,0,0,c1,c2,c3];
    
    if(epsilon_cable(ie_cable)<=0)
        xishu1 = 0 * a_cable / L0_cable(ie_cable);
        xishu2 = 0 * a_cable * epsilon_cable(ie_cable) / Ln_cable(ie_cable);
    else
        xishu1 = e_cable * a_cable / L0_cable(ie_cable);
        xishu2 = e_cable * a_cable * epsilon_cable(ie_cable) / Ln_cable(ie_cable);
    end
    
    ktl=xishu1*cl*cl';
    
    kt1=T'*ktl*T;
    
    kt2= xishu2*(A-(1/(Ln_cable(ie_cable)^2)*cx*cx'));
    
    kte_cable=kt1 + kt2;
    
    for i=1:3
        for j=1:3
            I=nii*3-3+i;J=nii*3-3+j;
            Kt_cable(I,J)=Kt_cable(I,J)+kte_cable(i,j);
        end
    end
    
    for i=1:3
        for j=4:6
            I=nii*3-3+i;J=njj*3-3+(j-3);
            Kt_cable(I,J)=Kt_cable(I,J)+kte_cable(i,j);
        end
    end
    
    for i=4:6
        for j=1:3
            I=njj*3-3+(i-3);J=nii*3-3+j;
            Kt_cable(I,J)=Kt_cable(I,J)+kte_cable(i,j);
        end
    end
    
    for i=4:6
        for j=4:6
            I=njj*3-3+(i-3);J=njj*3-3+(j-3);
            Kt_cable(I,J)=Kt_cable(I,J)+kte_cable(i,j);
        end
    end
    
    
    weight_cable(3*nii)=(1/2)*tmp_weight + weight_cable(3*nii);
    weight_cable(3*njj)=(1/2)*tmp_weight + weight_cable(3*njj);
    
    
    
end





end














