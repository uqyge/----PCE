function [epsilon_cable_temp0]...
         = T_cable(nelem_cable,T_mid,T_up,T_down)


ele_num_temp_up=[1;2;30;31];   %上绳编号

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

epsilon_cable_temp0=alpha*delta_T_temp1;

end