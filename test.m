clear;
uqlab;

%%

load('.\outputs\larsModels')

%%
for i = 1:size(myLARS,1)
    uq_print(myLARS{i})
end

%%
load('outputs\pceModels_6')
for i = 1:size(myPCE,1)
    uq_print(myPCE{i})
end
