
%输入文件说明

%维数(ndim)， 总结点数(nnode)，  杆单元数目，   经典绳单元数(nelem_cable)，  Cluster绳单元数(nelem_1)
ndim=3;       nnode=24;         nelem_bar=12;      nelem_cable=52;     nelem_spring=0;       nelem_cluster=0;
mdof=ndim*nnode;

%Cluster矩阵（m*n）: m--cluster的根数; n--每根cluster含有的经典单元数目
cluster=[];  
     
mn=size(cluster);
m=mn(1,1);n=mn(1,2);


%单元编号分为三类：杆单元，经典绳单元，Cluster绳单元
ele_spring=[];
ele_bar=[1,8;2,6;3,7;4,5;...
         9,16;10,14;11,15;12,13;...
         17,24;18,22;19,23;20,21];

ele_cable=[6,8;21,23;1,3;18,20;...
           1,6;9,14;17,22;3,8;11,16;19,24;...
           2,5;10,13;18,21;4,7;12,15;20,23;...
           1,5;9,13;17,21;8,4;16,12;24,20;...
           3,6;11,14;2,7;19,22;10,15;18,23;...
           2,11;7,14;22,15;10,19;...
           6,5;5,14;14,13;13,22;22,21;...
             1,2;2,9;9,10;10,17;17,18;...
             3,4;4,11;11,12;12,19;19,20;...
             8,7;7,16;16,15;15,24;24,23];

ele_cluster=[];

%单元材料参数（截面积，弹性模量，初应变，初应力）
a_cable=0.5026;
a_bar=2.55;
a_cluster=0.5026;


stiff_spring=0.2;
e_bar=7000;
e_cable=11500;
e_cluster=11500;

%节点坐标
nod=[-13.3  39.9  0
39.9   13.3   0
-39.9  -13.3   0
13.3   -39.9  0
13.3   39.9   30
-39.9  13.3   30
39.9   -13.3  30
-13.3  -39.9  30
13.3*4 39.9   0
13.3*8 13.3   0
13.3*2 -13.3  0
13.3*6 -39.9  0
13.3*6 39.9   30
13.3*2 13.3   30
13.3*8 -13.3  30
13.3*4 -39.9  30
13.3*9  39.9  0
13.3*13 13.3  0
13.3*7  -13.3 0
13.3*11 -39.9 0
13.3*11  39.9 30
13.3*7   13.3 30
13.3*13  -13.3 30
13.3*9  -39.9 30
];


%初始伸长量
delta_spring0=zeros(nelem_bar,1);
delta_bar0=zeros(nelem_bar,1);
delta_cable0=zeros(nelem_cable,1);
delta_cluster0=zeros(nelem_cluster,1);


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





