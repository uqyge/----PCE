clear;
clc

%%
%XX = ones(1000,32)*20
% load('input_k012.mat')
filename = 'input_k_12_rho1000_8_sobol_10000';
% filename = 'input_k_19_rho1000_4sobol_10000';
load(filename);
XX = input_rho;

%%
max(XX)
%%

format long e
%==========================================================================
%================================= Input ==================================
%==========================================================================
% InpuT4;
% Input_one_module;
% Input_tower_cluster;
Input_beam_cluster;
% Input_beam_classical;
% Input_twocell_cluster;
% Input_grid2;

%==========================================================================
%============================ Initial displacment =========================
%==========================================================================

dis_0 = (1:mdof)' * 0.01;
% dis0=rand(mdof,1);
% dis0(1:mdof,1) = 0;

for ii = 1:nrx
    nb1 = 3 * lrx(ii) - 2;
    dis_0(nb1, 1) = 0;
end

for jj = 1:nry
    nb2 = 3 * lry(jj) - 1;
    dis_0(nb2, 1) = 0;
end

for rr = 1:nrz
    nb3 = 3 * lrz(rr);
    dis_0(nb3, 1) = 0;
end

dis2 = dis_0;

%==========================================================================
%================================ weight ==================================
%==========================================================================
Num_load = 10;

% [weight] = zhongli_tower(lrz,nrz);
% [weight] = zhongli(lrz,nrz);

weight = zeros(mdof, 1);

%==========================================================================
%=============================== Iteration ================================
%==========================================================================

%修改001 num_sobol = 0;

% sobol_ACT_T=csvread('python1\inputACT_T.csv');
% num_ACT_T=size(sobol_ACT_T,1);
% ACT_sobol=sobol_ACT_T(:,1:2);
% T_sobol=sobol_ACT_T(:,3:5)*0;

tic
% for iii=1:num_ACT_T
%
%     iii
dis_0 = dis2;

%     act_pct_14=ACT_sobol(iii,1)*0;
%     act_pct_23=ACT_sobol(iii,1)*0;

%     if act_pct_23>act_pct_14
%         continue
%     end
%==========================================================================
%=============================== input ====================================
%==========================================================================
% load('.\data_input\T4.mat')
T4 = XX;
% T4 = T4(1:20, :);
xinxi = cell(size(T4, 1), 18); %{'序号', 'n_step', '输入', '所有结点位移', '短绳应力', '画图信息'}
output_data = zeros(size(T4, 1), 1 + 32 + 1);
%%
%alpha = 2e-3*20/100;
% alpha = -0.01;
alpha = 0;
figure

%parfor nn = 1:size(T4, 1)
% parfor nn = 1:1000
for nn = 1:1
    nn;
    NF_cable = zeros(nelem_cable, 1);
    dis1 = dis_0; dis0 = dis_0; % 预分配
    data_c = T4(nn, :);
    act_pct = 0.1 * ones(1, 4);

    [epsilon_cable_temp0] ...
        = alpha * T4(nn, :); % = 0*T4(nn,:); = 0*ones(1,32);

    for load_step = 1:Num_load

        load_step;

        %     epsilon_cable_temp1=zeros(nelem_cable,1);

        %     da0= 0.0255;  da = load_step*0.0;
        incre = act_pct / Num_load;
        epsilon_cable_temp1 = epsilon_cable_temp0 / Num_load;

        da0 = [0.0255; 0; 0; 0.0255]; % No.1 and 4 clustered cables on the top surface;

        %     if load_step==1          %%%%%%% 不可分步骤
        %         da = 0 * incre;
        %         epsilon_cable_temp=0*epsilon_cable_temp1;
        %         else if load_step==2
        %             da = 0 * incre;
        %             epsilon_cable_temp=epsilon_cable_temp1;
        %             else if load_step
        da = (load_step) * [incre(1); ...
                        incre(2); ...
                            incre(3); ...
                            incre(4)];
        epsilon_cable_temp = epsilon_cable_temp1 * load_step;
        %                 end
        %             end
        %     end

        %         [f] = Load_1(load_step,f);

        %         [f] = Load_one_module(load_step,f);

        %      [f,da] = Load_3cha_cluster(f,nnode);

        [fe] = Load_tower_cluster(nnode, load_step, mdof, lrx, lry, lrz, nrx, nry, nrz);

        %         [fe]=Load_twocell_cluster(nnode,load_step,mdof,lrx,lry,lrz,nrx,nry,nrz);

        %     [fe]=Load_beam_cluster(load_step,nnode,mdof,lrx,lry,lrz,nrx,nry,nrz);

        %         [fe]=Load_grid2(nnode,load_step,mdof,lrx,lry,lrz,nrx,nry,nrz);

        f = fe;

        for n_step = 1:1e3

            %================================ Form Kt_spring ==============================================
            [Kt_spring, delta_spring, epsilon_spring, L0_spring, weight_spring] ...
            = Assemble_Kt_spring(mdof, nod, nelem_spring, stiff_spring1, stiff_spring2, ele_spring, dis0, delta_spring0);

            %================================== Form Kt_bar ===============================================
            [Kt_bar, delta_bar, epsilon_bar, L0_bar, Ln_bar, weight_bar] ...
            = Assemble_Kt_bar(mdof, nod, nelem_bar, e_bar, a_bar, ele_bar, dis0, delta_bar0);

            %============================== Form Kt_cable ==================================================
            [Kt_cable, delta_cable, epsilon_cable, L0_cable, Ln_cable, weight_cable] ...
            = Assemble_Kt_cable(mdof, nod, nelem_cable, e_cable, a_cable, ele_cable, dis0, delta_cable0, epsilon_cable_temp);

            %============================= Form Kt_clusters ================================================
            [Kt_cluster, delta_cluster, epsilon_cluster, L0_cluster, Ln_cluster, weight_cluster] ...
            = Assemble_Kt_cluster(mdof, cluster, m, n, nod, e_cluster, a_cluster, ele_cluster, dis0, delta_cluster0, da0, da);

            weight =- (weight_spring + weight_bar + weight_cable + weight_cluster); % tower
            %         weight = -(weight_spring + weight_bar + weight_cable + weight_cluster);

            %========================== Boundary condition for Kt ==========================================
            [Kt] = Assemble_Kt(Kt_spring, Kt_bar, Kt_cable, Kt_cluster, lrx, lry, lrz, nrx, nry, nrz);

            %============================ Internal nodal forces ============================================
            [q, q_bar, q_cable, q_cluster, NF_spring, NF_bar, NF_cable, NF_cluster] = Internal_force(mdof, cluster, m, n, nod, nelem_spring, nelem_bar, nelem_cable, e_bar, e_cable, e_cluster, ...
            a_bar, a_cable, a_cluster, ele_spring, ele_bar, ele_cable, ele_cluster, dis0, L0_bar, L0_cable, L0_cluster, L0_spring, stiff_spring1, stiff_spring2, epsilon_cable_temp);

            %==================== Boundary condition for out-of-balance forces =============================
            [df, f] = Get_df(f, q, weight, lrx, lry, lrz, nrx, nry, nrz);

            %============================== Solve "Kt*dU=dF" ===============================================
            delta_dis = Kt \ df;

            %================================= "U1=U0+dU" ==================================================
            dis1 = dis0 + delta_dis;

            dis0 = dis1;
            %============================= Convergece criteria =============================================

            err_f = norm(df);

            %         if(load_step==1)
            %             yyy(n_step)=err_f;
            %             xxx(n_step)=n_step;
            %         end

            if (err_f < 1e-5)
                'Yes!!!';
                break
            end

            %=================================== "U0=U1" ===================================================

        end

    end

    %    disp(n_step);

    %     [nod_now0] = Disposal_grid2(nnode, nod, m, n, nelem_spring, nelem_bar, ...
    %     nelem_cable, cluster, ele_spring, ele_bar, ele_cable, ele_cluster, dis1);

    [nod_now] = nod_now_result(nnode, nod, m, n, nelem_spring, nelem_bar, ...
    nelem_cable, cluster, ele_spring, ele_bar, ele_cable, ele_cluster, dis1);

    nod_000 = [26.5000000000000, 39.7500000000000, 0; 79.3220677260045, 12.3351489396036, 0.0992035026548445; 0, -13.2500000000000, 0; 53.0087147639479, -40.6300144322402, -0.865453081740054; ...
                52.3313501941159, 38.1085214377346, 30.5567297980734; 0, 13.2500000000000, 30; 79.3379615489612, -14.4899984960731, 29.8438701279774; 27.2078850703319, -39.6304465317048, 29.7454334994341; ...
                91.8152214376121, 37.7314789080797, -0.926648423125315; 144.632414277766, 7.41915001481255, -0.121508553780224; 65.9914961793518, -14.3565502691039, 0.0765000814888062; 118.723310210205, -44.7904521579717, -0.991158422629326; ...
                117.726468909301, 34.3404903180150, 29.4192745591611; 65.6087403832400, 12.0002766180268, 30.2266166195369; 145.196309745074, -19.0611219657251, 29.9272272909059; 92.9534143815626, -41.3919867230393, 29.4747904775614; ...
                157.535540550642, 33.6576579633543, -1.11739715229474; 210.831241539454, 6.35968534141468, 0.0435781058352010; 131.358740320793, -19.3005932072914, -0.163807701517905; 184.142148981115, -46.7683054613913, -0.237374037462820; ...
                183.253138924127, 32.6004124733525, 29.5609111019889; 131.412754746299, 7.40286035090904, 29.6805028620628; 210.574083403007, -20.2067325245193, 30.0184329416879; 158.332414276323, -45.0587507979157, 30.3345269782941];

    dis_now = nod_now - nod_000;

    dis_23x = dis_now(23, 1);
    dis_23y = dis_now(23, 2);
    dis_23z = dis_now(23, 3);
    dis_z = 1/3 * (dis_now(23, 3) + dis_now(20, 3) + dis_now(18, 3));

    stress_cable = (NF_cable / a_cable); % 短绳应力

    huatu = {nnode, nod, m, n, nelem_spring, nelem_bar, ...
            nelem_cable, cluster, ele_spring, ele_bar, ele_cable, ele_cluster, dis1};

    xinxi(nn, :) = [{nn, n_step, data_c, dis_now, stress_cable}, huatu];
    output_data(nn, :) = [n_step, data_c, dis_z];
    %==========================================================================
    %==========================================================================
    %==========================================================================
end

% writecell(xinxi, '.\data_output\xinxi.csv');
% clear;clc
toc

%%
save(['..\outputs\output_', filename], 'output_data')
% save('..\outputs\output_new.mat', 'output_data')
%%
histogram(output_data(1:1000, 34))
