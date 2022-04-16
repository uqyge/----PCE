
%输入文件说明

%维数(ndim)， 总结点数(nnode)，  杆单元数目，   经典绳单元数(nelem_cable)，  Cluster绳单元数(nelem_1)
ndim=3;       nnode=24;         nelem_bar=12;      nelem_cable=32;       nelem_spring=0;     nelem_cluster=4;
mdof=ndim*nnode;

%Cluster矩阵（m*n）: m--cluster的根数; n--每根cluster含有的经典单元数目
cluster=[1,2,3,4,5;...
         6,7,8,9,10;...
         11,12,13,14,15;...
         16,17,18,19,20];
     
     
mn=size(cluster);
m=mn(1,1);n=mn(1,2);

%%%%%%%%%%热应力
T_mid=100;          %中绳温度

T_up=150;           %上绳温度
ele_num_temp_up=[1;2;30;31];   %上绳编号

T_down=200;           %下绳温度
ele_num_temp_down=[3;4;29;32];   %下绳编号

alpha=30e-6;              %目前任意给的热膨胀系数
delta_T_temp0=T_mid*ones(nelem_cable,1);
delta_T_temp1=delta_T_temp0;

for i=1:numel(ele_num_temp_up)

delta_T_temp1(ele_num_temp_up(i))=T_up;

end
for i=1:numel(ele_num_temp_down)

delta_T_temp1(ele_num_temp_down(i))=T_down;

end

epsilon_cable_temp1=alpha*delta_T_temp1;
%%%%%%%%%%%%%%%%%%%%%%%%%%

%单元编号分为三类：杆单元，经典绳单元，cluster绳单元
ele_spring=[];

ele_bar=[1,8;2,6;3,7;4,5;...
         9,16;10,14;11,15;12,13;...
         17,24;18,22;19,23;20,21];

ele_cable=[6,8;21,23;1,3;18,20;...
           1,6;9,14;17,22;3,8;11,16;19,24;...
           2,5;10,13;18,21;4,7;12,15;20,23;...
           1,5;9,13;17,21;8,4;16,12;24,20;...
           3,6;11,14;2,7;19,22;10,15;18,23;...
           2,11;7,14;22,15;10,19];

ele_cluster=[6,5;5,14;14,13;13,22;22,21;...
             1,2;2,9;9,10;10,17;17,18;...
             3,4;4,11;11,12;12,19;19,20;...
             8,7;7,16;16,15;15,24;24,23];

%单元材料参数（截面积，弹性模量，初应变，初应力）
a_cable=0.5026;
a_bar=2.55;
a_cluster=0.5026;

stiff_spring1=0.2;
stiff_spring2=5;

e_bar=7000;
e_cable=11500;
e_cluster=11500;


nod=[26.5000   39.7500         0
   79.5000   13.2500         0
         0  -13.2500         0
   53.0000  -39.7500         0
   53.0000   39.7500   30.0000
         0   13.2500   30.0000
   79.5000  -13.2500   30.0000
   26.5000  -39.7500   30.0000
   92.7500   39.7500         0
  145.7500   13.2500         0
   66.2500  -13.2500         0
  119.2500  -39.7500         0
  119.2500   39.7500   30.0000
   66.2500   13.2500   30.0000
  145.7500  -13.2500   30.0000
   92.7500  -39.7500   30.0000
  159.0000   39.7500         0
  212.0000   13.2500         0
  132.5000  -13.2500         0
  185.5000  -39.7500         0
  185.5000   39.7500   30.0000
  132.5000   13.2500   30.0000
  212.0000  -13.2500   30.0000
  159.0000  -39.7500   30.0000];


%初始伸长量
delta_spring0=zeros(nelem_bar,1);
delta_bar0=zeros(nelem_bar,1);
delta_cable0=zeros(nelem_cable,1);
delta_cluster0=zeros(nelem_cluster,1);


% delta0=load('delta0.txt');
% 
% 
% delta_bar0=0.68*delta0(1:12);
% delta_cable0=0.68*delta0(13:44);
% delta_cluster0(1:4)=delta0(45:48);


%约束x向位移的节点，约束y向位移的节点，约束z向位移的节点

lrx=[1,3,6];
lry=[1,3,6];
lrz=[1,3,6];


xxx=size(lrx);yyy=size(lry);zzz=size(lrz);
nrx=xxx(1,2);nry=yyy(1,2);nrz=zzz(1,2);

%载荷信息，总加载步数，加载步长
f=zeros(mdof,1);


%===============================Initial====================================
nod_now=zeros(nnode,3);nod_delta=zeros(nnode,3);
dis0=zeros(mdof,1);dis1=zeros(mdof,1);delta_dis=zeros(mdof,1);
q=zeros(mdof,1);df=zeros(mdof,1);
kte_bar=zeros(6,6);kte_cable=zeros(6,6);kte_cluster=zeros(3*(n+1),3*(n+1));
Kt=zeros(mdof,mdof);





