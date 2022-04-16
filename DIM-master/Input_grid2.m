
%输入文件说明
fid1= fopen('bar_ele.txt', 'w');
fid2= fopen('cable_ele.txt','w');

%维数(ndim)， 总结点数(nnode)，  杆单元数目，   经典绳单元数(nelem_cable)，  Cluster绳单元数(nelem_1)
ndim=3;       nnode=1122;         nelem_bar=2048;      nelem_cable=6144;       nelem_spring=0;     nelem_cluster=0;
mdof=ndim*nnode;

%Cluster矩阵（m*n）: m--cluster的根数; n--每根cluster含有的经典单元数目
cluster=[];
     
     
mn=size(cluster);
m=mn(1,1);n=mn(1,2);

nod=load('grid2_nod.txt');
ele=load('grid2_ele.txt');

aaa=size(ele);
nelem=aaa(1,1);

Length=zeros(nelem,1);Fflag=zeros(nelem,1);

for i=1:nelem
    Length(i)=norm(nod(ele(i,1),:)-nod(ele(i,2),:));
    if(Length(i)>1)
        Fflag(i)=1;
        fprintf(fid1,'%10i %10i\n', ele(i,1),ele(i,2));
    else
        Fflag(i)=2;
        fprintf(fid2,'%10i %10i\n', ele(i,1),ele(i,2));
    end
end


%单元编号分为三类：杆单元，经典绳单元，cluster绳单元
ele_spring=[];

ele_bar=load('bar_ele.txt');

ele_cable=load('cable_ele.txt');

ele_cluster=[];

%单元材料参数（截面积，弹性模量，初应变，初应力）
a_cable=0.5026;
a_bar=2.55;
a_cluster=0.5026;

stiff_spring1=0;
stiff_spring2=0;

e_bar=7000;
e_cable=11500;
e_cluster=11500;




%初始伸长量
delta_spring0=zeros(nelem_spring,1);
delta_bar0=zeros(nelem_bar,1);
delta_cable0=zeros(nelem_cable,1);
delta_cluster0=zeros(nelem_cluster,1);




%约束x向位移的节点，约束y向位移的节点，约束z向位移的节点
lrx=[    1,    4,    8,   79,   80,   82,   85,   88,  131,  132,  135,  138,  181,  182,  185,  188,...
  231,  232,  235,  238,  281,  282,  285,  288,  331,  332,  335,  338,  381,  382,  385,  388,...
  431,  432,  435,  438,  481,  482,  485,  488,  531,  532,  535,  538,  581,  582,  585,  588,...
  631,  632,  635,  638,  681,  682,  685,  688,  731,  732,  735,  738,  781,  782,  785,  788,...
  831,  832,  834,  837,  866,  867,  869,  884,  886,  901,  903,  918,  920,  935,  937,  952,...
  954,  969,  971,  986,  988, 1003, 1005, 1020, 1022, 1037, 1039, 1054, 1056, 1071, 1073, 1088,...
 1090, 1105, 1107, 1122];
lry=lrx;
lrz=lrx;

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





