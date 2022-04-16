function [f]=Load_one_module(load_step,f)    


F=100;


f(6*3-2,1)=F*load_step;
f(7*3-2,1)=F*load_step;
f(8*3-2,1)=F*load_step;


end