function [f,da]=Load_cha(load_step,f)    

da=0;
F=0;alpha_a=(45/180)*pi;

f(3*3-2,1)=F*cos(alpha_a);
f(3*3-1,1)=F*sin(alpha_a);


end