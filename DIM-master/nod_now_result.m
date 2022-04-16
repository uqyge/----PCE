function [nod_now]=nod_now_result(nnode,nod,m,n,nelem_spring,nelem_bar,nelem_cable,cluster,ele_spring,ele_bar,ele_cable,ele_cluster,dis1)

fal=3;

nod_now=zeros(nnode,3);

%==============================================================================
%================================ Undeformed configuration ====================
%==============================================================================
%============================= plot springs ==================================
% for ie=1:nelem_spring
%     ni=ele_spring(ie,1);
%     nj=ele_spring(ie,2);
%     xi=nod(ni,1);
%     yi=nod(ni,2);
%     zi=nod(ni,3);
%     xj=nod(nj,1);
%     yj=nod(nj,2);
%     zj=nod(nj,3);
%     
%     nod_now(ni,1)= nod(ni,1)+dis1(3*ni-2);
%     nod_now(ni,2)= nod(ni,2)+dis1(3*ni-1);
%     nod_now(ni,3)= nod(ni,3)+dis1(3*ni);
%     nod_now(nj,1)= nod(nj,1)+dis1(3*nj-2);
%     nod_now(nj,2)= nod(nj,2)+dis1(3*nj-1);
%     nod_now(nj,3)= nod(nj,3)+dis1(3*nj);
%     
%     xxi=nod_now(ni,1);
%     yyi=nod_now(ni,2);
%     zzi=nod_now(ni,3);
%     xxj=nod_now(nj,1);
%     yyj=nod_now(nj,2);
%     zzj=nod_now(nj,3);
%     
%     
%     if(fal==2)
%         plot([xi,xj],[zi,zj],'-o','color',[0.5 0.5 0.5],'linewidth',1,...
%             'MarkerEdgeColor',[0.5 0.5 0.5],'MarkerFaceColor',[0.5 0.5 0.5],'MarkerSize',3)
%         hold on
%         
%     else
%         
%         plot3([xi,xj],[yi,yj],[zi,zj],'-o','color',[0.5 0.5 0.5],'linewidth',1,...
%             'MarkerEdgeColor',[0.5 0.5 0.5],'MarkerFaceColor',[0.5 0.5 0.5],'MarkerSize',3)
%         hold on
%         
%     end
% %     
%     
%     
% end
% 
% 
% %============================= plot bars ==================================
% for ie=1:nelem_bar
%     ni=ele_bar(ie,1);
%     nj=ele_bar(ie,2);
%     xi=nod(ni,1);
%     yi=nod(ni,2);
%     zi=nod(ni,3);
%     xj=nod(nj,1);
%     yj=nod(nj,2);
%     zj=nod(nj,3);
%     
%     nod_now(ni,1)= nod(ni,1)+dis1(3*ni-2);
%     nod_now(ni,2)= nod(ni,2)+dis1(3*ni-1);
%     nod_now(ni,3)= nod(ni,3)+dis1(3*ni);
%     nod_now(nj,1)= nod(nj,1)+dis1(3*nj-2);
%     nod_now(nj,2)= nod(nj,2)+dis1(3*nj-1);
%     nod_now(nj,3)= nod(nj,3)+dis1(3*nj);
%     
%     xxi=nod_now(ni,1);
%     yyi=nod_now(ni,2);
%     zzi=nod_now(ni,3);
%     xxj=nod_now(nj,1);
%     yyj=nod_now(nj,2);
%     zzj=nod_now(nj,3);
%     
%     
%     if(fal==2)
%         plot([xi,xj],[zi,zj],'-o','color',[0.5 0.5 0.5],'linewidth',3,...
%             'MarkerEdgeColor',[0.5 0.5 0.5],'MarkerFaceColor',[0.5 0.5 0.5],'MarkerSize',3)
%         hold on
%         
%     else
%         
%         plot3([xi,xj],[yi,yj],[zi,zj],'-o','color',[0.5 0.5 0.5],'linewidth',3,...
%             'MarkerEdgeColor',[0.5 0.5 0.5],'MarkerFaceColor',[0.5 0.5 0.5],'MarkerSize',3)
%         hold on
%         
%     end
%     
%     
%     
% end
% 
% 
% %============================= plot cables ================================
% for ie=1:nelem_cable
%     ni=ele_cable(ie,1);
%     nj=ele_cable(ie,2);
%     xi=nod(ni,1);
%     yi=nod(ni,2);
%     zi=nod(ni,3);
%     xj=nod(nj,1);
%     yj=nod(nj,2);
%     zj=nod(nj,3);
%     
%     nod_now(ni,1)= nod(ni,1)+dis1(3*ni-2);
%     nod_now(ni,2)= nod(ni,2)+dis1(3*ni-1);
%     nod_now(ni,3)= nod(ni,3)+dis1(3*ni);
%     nod_now(nj,1)= nod(nj,1)+dis1(3*nj-2);
%     nod_now(nj,2)= nod(nj,2)+dis1(3*nj-1);
%     nod_now(nj,3)= nod(nj,3)+dis1(3*nj);
%     
%     xxi=nod_now(ni,1);
%     yyi=nod_now(ni,2);
%     zzi=nod_now(ni,3);
%     xxj=nod_now(nj,1);
%     yyj=nod_now(nj,2);
%     zzj=nod_now(nj,3);
%     
%     
%     if(fal==2)
%         plot([xi,xj],[zi,zj],'-o','color',[0.5 0.5 0.5],'linewidth',1,...
%             'MarkerEdgeColor',[0.5 0.5 0.5],'MarkerFaceColor',[0.5 0.5 0.5],'MarkerSize',3)
%         hold on
%         
%     else
%         plot3([xi,xj],[yi,yj],[zi,zj],'-o','color',[0.5 0.5 0.5],'linewidth',1,...
%             'MarkerEdgeColor',[0.5 0.5 0.5],'MarkerFaceColor',[0.5 0.5 0.5],'MarkerSize',3)
%         hold on
%         
%     end
%     
% end
%     
%     
%     %=========================== plot clusters ================================
%     for i=1:m
%         
%         for j=1:n
%             
%             ie=cluster(i,j);
%             ni=ele_cluster(ie,1);
%             nj=ele_cluster(ie,2);
%             
%             xi=nod(ni,1);
%             yi=nod(ni,2);
%             zi=nod(ni,3);
%             xj=nod(nj,1);
%             yj=nod(nj,2);
%             zj=nod(nj,3);
%             
%             nod_now(ni,1)= nod(ni,1)+dis1(3*ni-2);
%             nod_now(ni,2)= nod(ni,2)+dis1(3*ni-1);
%             nod_now(ni,3)= nod(ni,3)+dis1(3*ni);
%             nod_now(nj,1)= nod(nj,1)+dis1(3*nj-2);
%             nod_now(nj,2)= nod(nj,2)+dis1(3*nj-1);
%             nod_now(nj,3)= nod(nj,3)+dis1(3*nj);
%             
%             xxi=nod_now(ni,1);
%             yyi=nod_now(ni,2);
%             zzi=nod_now(ni,3);
%             xxj=nod_now(nj,1);
%             yyj=nod_now(nj,2);
%             zzj=nod_now(nj,3);
%             
%             
%             if(fal==2)
%                 plot([xi,xj],[zi,zj],'--o','color',[0.5 0.5 0.5],'linewidth',1,...
%                     'MarkerEdgeColor',[0.5 0.5 0.5],'MarkerFaceColor',[0.5 0.5 0.5],'MarkerSize',3)
%                 hold on
%                 
%             else
%                 plot3([xi,xj],[yi,yj],[zi,zj],'--o','color',[0.5 0.5 0.5],'linewidth',1,...
%                     'MarkerEdgeColor',[0.5 0.5 0.5],'MarkerFaceColor',[0.5 0.5 0.5],'MarkerSize',3)
%                 hold on
%                 
%             end
%             
%         end
%     end
  
        
        
        
        
 %==============================================================================       
 %================================ Deformed configuration ======================
  %==============================================================================       
  %============================= plot springs ==================================
        for ie=1:nelem_spring
            ni=ele_spring(ie,1);
            nj=ele_spring(ie,2);
            
            nod_now(ni,1)= nod(ni,1)+dis1(3*ni-2);
            nod_now(ni,2)= nod(ni,2)+dis1(3*ni-1);
            nod_now(ni,3)= nod(ni,3)+dis1(3*ni);
            nod_now(nj,1)= nod(nj,1)+dis1(3*nj-2);
            nod_now(nj,2)= nod(nj,2)+dis1(3*nj-1);
            nod_now(nj,3)= nod(nj,3)+dis1(3*nj);
            
            xxi=nod_now(ni,1);
            yyi=nod_now(ni,2);
            zzi=nod_now(ni,3);
            xxj=nod_now(nj,1);
            yyj=nod_now(nj,2);
            zzj=nod_now(nj,3);
            
%             if(fal==2)
%                 
%                 plot([xxi,xxj],[zzi,zzj],'-o','color','b','linewidth',1,...
%                     'MarkerEdgeColor','b','MarkerFaceColor','b','MarkerSize',3)
%             else
%                 plot3([xxi,xxj],[yyi,yyj],[zzi,zzj],'-o','color','b','linewidth',1,...
%                     'MarkerEdgeColor','k','MarkerFaceColor','b','MarkerSize',3)
%                 
%                 hold on
%             end
            
            
        end
        
        %============================= plot bars ==================================
        for ie=1:nelem_bar
            ni=ele_bar(ie,1);
            nj=ele_bar(ie,2);
            
            nod_now(ni,1)= nod(ni,1)+dis1(3*ni-2);
            nod_now(ni,2)= nod(ni,2)+dis1(3*ni-1);
            nod_now(ni,3)= nod(ni,3)+dis1(3*ni);
            nod_now(nj,1)= nod(nj,1)+dis1(3*nj-2);
            nod_now(nj,2)= nod(nj,2)+dis1(3*nj-1);
            nod_now(nj,3)= nod(nj,3)+dis1(3*nj);
            
            xxi=nod_now(ni,1);
            yyi=nod_now(ni,2);
            zzi=nod_now(ni,3);
            xxj=nod_now(nj,1);
            yyj=nod_now(nj,2);
            zzj=nod_now(nj,3);
            
%             if(fal==2)
%                 
%                 plot([xxi,xxj],[zzi,zzj],'-o','color','b','linewidth',2,...
%                     'MarkerEdgeColor','b','MarkerFaceColor','b','MarkerSize',2)
%             else
%                 plot3([xxi,xxj],[yyi,yyj],[zzi,zzj],'-o','color','b','linewidth',2,...
%                     'MarkerEdgeColor','k','MarkerFaceColor','b','MarkerSize',2)
%                 
%                 hold on
%             end
            
            
        end
        
        
        %============================= plot cables ================================
        for ie=1:nelem_cable
            ni=ele_cable(ie,1);
            nj=ele_cable(ie,2);
            
            nod_now(ni,1)= nod(ni,1)+dis1(3*ni-2);
            nod_now(ni,2)= nod(ni,2)+dis1(3*ni-1);
            nod_now(ni,3)= nod(ni,3)+dis1(3*ni);
            nod_now(nj,1)= nod(nj,1)+dis1(3*nj-2);
            nod_now(nj,2)= nod(nj,2)+dis1(3*nj-1);
            nod_now(nj,3)= nod(nj,3)+dis1(3*nj);
            
            xxi=nod_now(ni,1);
            yyi=nod_now(ni,2);
            zzi=nod_now(ni,3);
            xxj=nod_now(nj,1);
            yyj=nod_now(nj,2);
            zzj=nod_now(nj,3);
            
            
%             if(fal==2)
%                 plot([xxi,xxj],[zzi,zzj],'-o','color','r','linewidth',1,...
%                     'MarkerEdgeColor','b','MarkerFaceColor','b','MarkerSize',2)
%                 
%                 hold on
%                 
%             else
%                 plot3([xxi,xxj],[yyi,yyj],[zzi,zzj],'-o','color','r','linewidth',1,...
%                     'MarkerEdgeColor','k','MarkerFaceColor','b','MarkerSize',2)
%                 
%                 hold on
%                 
%             end
            
        end
        
        
        %=========================== plot clusters ================================
        for i=1:m
            
            for j=1:n
                
                ie=cluster(i,j);
                ni=ele_cluster(ie,1);
                nj=ele_cluster(ie,2);

                
                nod_now(ni,1)= nod(ni,1)+dis1(3*ni-2);
                nod_now(ni,2)= nod(ni,2)+dis1(3*ni-1);
                nod_now(ni,3)= nod(ni,3)+dis1(3*ni);
                nod_now(nj,1)= nod(nj,1)+dis1(3*nj-2);
                nod_now(nj,2)= nod(nj,2)+dis1(3*nj-1);
                nod_now(nj,3)= nod(nj,3)+dis1(3*nj);
                
                xxi=nod_now(ni,1);
                yyi=nod_now(ni,2);
                zzi=nod_now(ni,3);
                xxj=nod_now(nj,1);
                yyj=nod_now(nj,2);
                zzj=nod_now(nj,3);
                
%                 if(fal==2)
%                     plot([xxi,xxj],[zzi,zzj],'--o','color','b','linewidth',1,...
%                         'MarkerEdgeColor','b','MarkerFaceColor','b','MarkerSize',3)
%                     hold on
%                     
%                 else
%                     plot3([xxi,xxj],[yyi,yyj],[zzi,zzj],'--o','color','b','linewidth',1,...
%                         'MarkerEdgeColor','k','MarkerFaceColor','b','MarkerSize',3)
%                     hold on
%                 end
            end
            
        end
        
        
        %==================================================================
           
        
        
        axis equal
%         axis(100*[-0.3 1.3 -0.3 1.3 0 2.0])
%         axis([-0 230 -50 100 0 120])
        box off
%         axis off
%         grid on
        
%         view([-34 10])
        

        view([0  0])
        
    end
    
    
    
    
    
    
    
    
    
