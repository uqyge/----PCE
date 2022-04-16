
%输入文件说明

%维数(ndim)， 总结点数(nnode)，  杆单元数目，   经典绳单元数(nelem_cable)， 弹簧单元数(nelem_1),   Cluster绳单元数(nelem_1)
ndim=3;       nnode=8;         nelem_bar=6;      nelem_cable=4;         nelem_spring=0;          nelem_cluster=2;
mdof=ndim*nnode;

%Cluster矩阵（m*n）: m--cluster的根数; n--每根cluster含有的经典单元数目
cluster=[1,2,3;...
         4,5,6];
mn=size(cluster);
m=mn(1,1);n=mn(1,2);


%单元编号分为三类：杆单元，经典绳单元，cluster绳单元
ele_bar=[1,4;2,3;3,6;4,5;5,8;6,7];

ele_cable=[1,2;3,4;5,6;7,8];

ele_cluster=[2,4;4,6;6,8;...
             1,3;3,5;5,7];

ele_spring=[];


%单元材料参数（截面积，弹性模量，初应变，初应力）
a_cable=1;
a_bar=1;
a_cluster=1;

e_bar=1e3;
e_cable=1e3;
e_cluster=1e3;
stiff_spring=0;

%节点坐标
nod=[0,0,0;...
    0,1,0;...
    1,0,0;...
    1,1,0;...
    2,0,0;...
    2,1,0;...
    3,0,0;...
    3,1,0];


%初始伸长量
delta_spring0=zeros(nelem_spring,1);
delta_bar0=zeros(nelem_bar,1);
delta_cable0=zeros(nelem_cable,1);
delta_cluster0=zeros(nelem_cluster,1);

delta_cluster0(1,1)=0.0;

%约束x向位移的节点，约束y向位移的节点，约束z向位移的节点
lrx=[1,2];
lry=[1,2];
lrz=[1,2,3,4,5,6,7,8];

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





