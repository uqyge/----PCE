
%输入文件说明

%维数(ndim)， 总结点数(nnode)，  杆单元数目，   经典绳单元数(nelem_cable)， 弹簧单元数(nelem_1),   Cluster绳单元数(nelem_1)
ndim=3;       nnode=12;         nelem_bar=8;      nelem_cable=8;         nelem_spring=4;          nelem_cluster=4;
mdof=ndim*nnode;

%Cluster矩阵（m*n）: m--cluster的根数; n--每根cluster含有的经典单元数目
cluster=[1,2;...
         3,4;...
         5,6;...
         7,8];
     
     
mn=size(cluster);
m=mn(1,1);n=mn(1,2);


%单元编号分为三类：杆单元，经典绳单元，cluster绳单元
ele_bar=[1,6;2,7;3,8;4,5;...
         5,11;6,12;7,9;8,10];

ele_cable=[1,2;2,3;3,4;4,1;...
           9,10;10,11;11,12;12,9;...
           ];

ele_cluster=[9,8;8,4;...
             1,5;5,10;...
             3,7;7,12;...
             2,6;6,11];

ele_spring=[5,8;5,6;6,7;7,8];


%单元材料参数（截面积，弹性模量，初应变，初应力）
a_cable=0.5026;
a_bar=2.55;
a_cluster=0.5026;

e_bar=7000;
e_cable=11500;
e_cluster=11500;
stiff_spring=1;

%节点坐标
nod=[0,0,0;...
     80,0,0;...
     80,80,0;...
     0,80,0;...
     40,0,40;...
     80,40,40;...
     40,80,40;...
     0,40,40;...
     0,0,80;...
     80,0,80;...
     80,80,80;...
     0,80,80];


%初始伸长量
delta_spring0=zeros(nelem_spring,1);
delta_bar0=zeros(nelem_bar,1);
delta_cable0=zeros(nelem_cable,1);
delta_cluster0=zeros(nelem_cluster,1);


%约束x向位移的节点，约束y向位移的节点，约束z向位移的节点
lrx=[1];
lry=[1,2];
lrz=[1,2,3,4];

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





