function [Kt_cluster,delta_cluster,epsilon_cluster,L0_cluster,Ln_cluster,weight_cluster]...
         = Assemble_Kt_cluster(mdof,cluster,m,n,nod,e_cluster,a_cluster,ele_cluster,dis0,delta_cluster0,da0,da)

Kt_cluster=zeros(mdof,mdof);
L0=zeros(m,n);Ln=zeros(m,n);
L0_cluster=zeros(m,1);Ln_cluster=zeros(m,1);epsilon_cluster=zeros(m,1);delta_cluster=zeros(m,1);
TT=zeros(2,6,n,m);TT_tran=zeros(6,2,n,m);

weight_cluster=zeros(mdof,1);ro_cluster=7.85e-5;

cl=[-1,1]';
A=eye(6,6);A(1,4)=-1;A(2,5)=-1;A(3,6)=-1;A(4,1)=-1;A(5,2)=-1;A(6,3)=-1;
% A = A/4;
%============================= 计算clusters的长度 ==========================
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
        
        L0(i,j)=sqrt((x21)^2 + (y21)^2 + (z21)^2);
        
        % No. 1 and 4 locating on the top surface
        % No. 2 and 3 locating on the bottom surface
        
        if(i==1)
            L0(i,j) = L0(i,j)*(1-da0(i))*(1-da(i));
        else if(i==4)
                L0(i,j) = L0(i,j)*(1-da0(i))*(1-da(i));
            else if(i==2)
                    L0(i,j) = L0(i,j)*(1-da0(i))*(1+da(i));
                else if (i==3)
                        L0(i,j) = L0(i,j)*(1-da0(i))*(1+da(i));
                    end
                end
            end
        end
                
         
        Ln(i,j)=sqrt((x21+u21)^2 + (y21+v21)^2 + (z21+w21)^2);
        
        c1=(x21+u21)/Ln(i,j);c2=(y21+v21)/Ln(i,j);c3=(z21+w21)/Ln(i,j);
        
        TT(:,:,j,i)=[c1,c2,c3,0,0,0;0,0,0,c1,c2,c3];
        
        TT_tran(:,:,j,i)=[c1,c2,c3,0,0,0;0,0,0,c1,c2,c3]';
        
        
    end

    
    L0_cluster(i) = sum(L0(i,:)) - delta_cluster0(i);
   
    
    Ln_cluster(i)=sum(Ln(i,:));
    
    delta_cluster(i) = Ln_cluster(i) - L0_cluster(i);
    
    epsilon_cluster(i) = delta_cluster(i) / L0_cluster(i);
    
    
end


%============================== 组集常规刚度阵 =============================
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
        
        x_21=x21+u21;y_21=y21+v21;z_21=z21+w21;
        
        cx=[-x_21,-y_21,-z_21,x_21,y_21,z_21]';         
        
        tmp_weight=L0(i,j)*a_cluster*ro_cluster;
      
        Ln(i,j)=sqrt((x21+u21)^2 + (y21+v21)^2 + (z21+w21)^2);
        
        c1=(x21+u21)/Ln(i,j);c2=(y21+v21)/Ln(i,j);c3=(z21+w21)/Ln(i,j);
        
        T=[c1,c2,c3,0,0,0;0,0,0,c1,c2,c3];
        
        
        if(epsilon_cluster(i)<0)
            xishu1 = 0 * a_cluster  / L0_cluster(i);
            xishu2 = 0 * a_cluster * delta_cluster(i) / ((Ln(i,j)*L0_cluster(i)));
        else
            xishu1 = a_cluster * e_cluster / L0_cluster(i);
            xishu2 = a_cluster * e_cluster * delta_cluster(i) / ((Ln(i,j)*L0_cluster(i)));
        end
        
        ktl = xishu1*cl*cl';
        
        kt1 = T'*ktl*T;
        
        kt2= xishu2*(A-(1/(Ln(i,j)^2)*cx*cx'));
        
        tmp = kt1 + kt2;
        
        for ii=1:3
            for jj=1:3
                I=niii*3-3+ii;J=niii*3-3+jj;
                Kt_cluster(I,J) = Kt_cluster(I,J) + tmp(ii,jj);
            end
        end
        
        for ii=1:3
            for jj=4:6
                I=niii*3-3+ii;J=njjj*3-3+(jj-3);
                Kt_cluster(I,J) = Kt_cluster(I,J) + tmp(ii,jj);
            end
        end
        
        for ii=4:6
            for jj=1:3
                I=njjj*3-3+(ii-3);J=niii*3-3+jj;
                Kt_cluster(I,J) = Kt_cluster(I,J) + tmp(ii,jj);
            end
        end
        
        for ii=4:6
            for jj=4:6
                I=njjj*3-3+(ii-3);J=njjj*3-3+(jj-3);
                Kt_cluster(I,J) = Kt_cluster(I,J) + tmp(ii,jj);
            end
        end
        
        
        weight_cluster(3*niii)= (1/2)*tmp_weight + weight_cluster(3*niii);
        weight_cluster(3*njjj)= (1/2)*tmp_weight + weight_cluster(3*njjj);
        
        
    end
end



%========================== 组集附加刚度矩阵 ===============================
for k=1:m
    
    for i=1:n
        
        ie0=cluster(k,i);
        ni0=ele_cluster(ie0,1);
        nj0=ele_cluster(ie0,2);
      
        for j=1:n
            
            ie=cluster(k,j);
            niii=ele_cluster(ie,1);
            njjj=ele_cluster(ie,2);

        if(epsilon_cluster(k)<=0)
            xishu1 = 0 ;
        else    
            if(i==j)
                xishu1=0;             
            else                
                xishu1 = a_cluster*e_cluster / L0_cluster(k);                
            end
        end
            
            ktl=xishu1*cl*cl';
            
            tmp3=TT_tran(:,:,i,k)*ktl*TT(:,:,j,k);
            
            for iii=1:3
                for jjj=1:3
                    I=ni0*3-3+iii;J=niii*3-3+jjj;
                    Kt_cluster(I,J)=Kt_cluster(I,J) + tmp3(iii,jjj);
                end
            end
            
            for iii=1:3
                for jjj=4:6
                    I=ni0*3-3+iii;J=njjj*3-3+(jjj-3);
                    Kt_cluster(I,J)=Kt_cluster(I,J) + tmp3(iii,jjj);
                end
            end
            
            for iii=4:6
                for jjj=1:3
                    I=nj0*3-3+(iii-3);J=niii*3-3+jjj;
                    Kt_cluster(I,J)=Kt_cluster(I,J) + tmp3(iii,jjj);
                end
            end
            
            for iii=4:6
                for jjj=4:6
                    I=nj0*3-3+(iii-3);J=njjj*3-3+(jjj-3);
                    Kt_cluster(I,J)=Kt_cluster(I,J) + tmp3(iii,jjj);
                end
            end      
            
        end
    end
    
end


end








