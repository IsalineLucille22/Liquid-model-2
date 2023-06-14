% Generation of heatmaps for stationary proportions of P.veronii simulated
% vs observed and stationary abundance simulated vs observed

clear;
close all;

%Model considered are of type: S + R -> P -> 2S, P <-> S + W, P -> S + F.
%Model with double waste, one (W) that can be reused by both species and the
%other (F) can't be reused.

% Enter parameters to test:

Name_file = 'Hill'; %Name the produced data.
save_data = 0; %If save = 1, figures and tables are saved (.fig/.pdf or .xlsx) and overwrite the actual file of the same name.

%% Allocation of the parameter values

%Parameters allocated accoridng to observed values
table_name = ['PVEManuAdaptScalLN'; 'PPUManuAdaptScalLN'];
%Estimated values
%Pve values
table_Pve = load(strcat('./Data/',table_name(1,:), '.mat'));
mean_LN_k1_Pve = table_Pve.LN_k1; %Kappa_1
mean_LN_k2_Pve = table_Pve.LN_k2; %Mu_max
mean_LN_k3_Pve = table_Pve.LN_k3; %Golbal yield
%Ppu values
table_Ppu = load(strcat('./Data/',table_name(2,:), '.mat'));
mean_LN_k1_Ppu = table_Ppu.LN_k1; %Kappa_1
mean_LN_k2_Ppu = table_Ppu.LN_k2; %Mu_max
mean_LN_k3_Ppu = table_Ppu.LN_k3; %Global yield

%If set mu_max to empty vector, mu_max = [], then estimated values from
%parameters inference are used (Table P__ManuAdptScalLN.mat) to generate kappa_2 (mu_max) and kappa_3
%(global yield). Values have to be given to the other parameters.
mu_max = [];%[0.48 1.05];%[0.52 1.2]; %Maximum growth rates of both species
std_mu_max = [0 0]; %Standard deviation mu_max. 

%The rate kappa_1 (h*g/ml)^(-1). They should be
%of the order 1/K_s where K_s is the half velocity constant in mL.
kappa_1 = [2.5090e+05; 2e+05]; %Rates for reaction S_i + R -> P_i
% where S_i is the species, R the unique resource initially present and P_i the complex corresponding to species i.
std_kappa_1 = [0 0]; %Standard deviation kappa_1.

%Concentration threshold. When the concentration of the reusable waste (W)
%is above this threshold, then the species i can use it.
% Threshold = 0*[1.400e-04; 2.8000e-05]; %Threshold values
%100:1, 10:1, 1:1, 1:10, 1:100
%T(1,:) for used of W_2 by PVE, T(2,:) for used of W_1 by PPU
%Indicative function
% Threshold = [1.397e-04 1.397e-04 1.397e-04 1.397e-04 1.4345e-04; 6.5e-05 1.0e-05 2.8000e-05 2.8000e-05 2.8000e-05];
%Sigmoid function

mean_R_0 = 2.4*10^(-4); %Initial resource concentration
sigma_R_0 = 0*0.5*10^(-5); %Standard deviation for the resource concentration.

Time_step = 0:0.25:24; %Time step, 0:0.25:24 corresponds to the real measurement times of the experiment.
%% Test 5 ratios
close all

num_ratio_min = 2; %Number of the ratio tested. In experiment, there are 5 different ratios 100:1, 10:1, 1:1, 1:10, 1:100.
num_ratio_max = 2;
ratios = [num_ratio_min num_ratio_max];

Threshold_W2 = 0:3e-05:1.60e-04;
Threshold_W1 = 0:0.9e-05:1.40e-04;

Name_Model = @fun_Monod_tot; %Type of the function to test. Description in the corresponding function file.

[mean_PVE_fin_props, ratio_mean, W1_used, W2_used] = deal(zeros(length(Threshold_W2), length(Threshold_W1)));
for j = 1:length(Threshold_W1)
    for i = 1:length(Threshold_W2)
        Threshold = [Threshold_W2(i)*ones(1, 5); Threshold_W1(j)*ones(1, 5)];
        [Fin_abund_sim_PVE, Fin_abund_sim_PPU, kappa_mat, mean_PVE_fin_props(i,j), Fin_props_sim, Fin_props_obs, W1_used(i,j), W2_used(i,j)] = Main_Fun(Name_Model, mu_max, std_mu_max, kappa_1, std_kappa_1,...
            mean_LN_k1_Pve, mean_LN_k2_Pve, mean_LN_k3_Pve, mean_LN_k1_Ppu, mean_LN_k2_Ppu, mean_LN_k3_Ppu,...
            Threshold, ratios, mean_R_0, sigma_R_0, Time_step, Name_file, save_data);
            ratio_mean(i,j) = mean(Fin_props_sim)/mean(Fin_props_obs);
    end
end

close all;

figure(1)
h_1 = heatmap(string(Threshold_W1), string(Threshold_W2), mean_PVE_fin_props);
h_1.NodeChildren(3).YDir='normal'; 

figure(2)
h_2 = heatmap(string(Threshold_W1), string(Threshold_W2), ratio_mean, 'Colormap', copper);
h_2.NodeChildren(3).YDir='normal';

figure(3)
h_3 = heatmap(string(Threshold_W1), string(Threshold_W2), W1_used);
h_3.NodeChildren(3).YDir='normal';

figure(4)
h_4 = heatmap(string(Threshold_W1), string(Threshold_W2), W2_used);
h_4.NodeChildren(3).YDir='normal';