function dx = fun_Hill_HandlingTimev3(t, z, kappa, threshold)
%function with 3 wastes
%z(1), dx_1: biomass bacterial species 1. z(2), dx_2: biomass bacterial
%species 2. z(3), dy_1: biomass complex. z(4), dy_2: biomass complex.
%z(5), dw_1 biomass waste produced by species 1 that can be used by species
%2. z(6), dw_2: biomass waste produced by species 2 that can be used by
%species 1. z(7), dr_1: biomass resource 1. z(8) dr_2: biomass resource 1.
% Model: S_i + R_i -> P_i -> 2S_i, P_i <-> S_i + W_i, S_j + W_i -> P_j.
z(z<=0) = 0;
kappa(1,3) = 1.3*kappa(1,3); %Assumption when cross-feeding, the yield of P.veronii is slightly smaller to the one measured in mono-culture
Hill_Coeff_1 = (z(6) - threshold(1) > 0);%Use W_2 by S_1
Hill_Coeff_2 = (z(5) - threshold(2) > 0);%Use W_1 by S_2
Hill_Coeff_3 = 0;%z(5) - threshold(3) > 0);%Use W_1 by S_1
dx_1 = (2*kappa(1,2) + kappa(1,3))*z(3) - kappa(1,1)*z(1)*z(7) - Hill_Coeff_1*kappa(1,4)*z(1)*z(6) - Hill_Coeff_3*kappa(1,4)*z(1)*z(5);
dx_2 = (2*kappa(2,2) + kappa(2,3))*z(4) - kappa(2,1)*z(2)*z(8) - Hill_Coeff_2*kappa(2,4)*z(2)*z(5);
dy_1 = -(kappa(1,2) + kappa(1,3))*z(3) + kappa(1,1)*z(1)*z(7) + Hill_Coeff_1*kappa(1,4)*z(1)*z(6) + Hill_Coeff_3*kappa(1,4)*z(1)*z(5);
dy_2 = -(kappa(2,2) + kappa(2,3))*z(4) + kappa(2,1)*z(2)*z(8) + Hill_Coeff_2*kappa(2,4)*z(2)*z(5);
dw_1 = kappa(1,3)*z(3) - Hill_Coeff_2*kappa(2,4)*z(2)*z(5) - Hill_Coeff_3*kappa(1,4)*z(1)*z(5);
dw_2 = kappa(2,3)*z(4) - Hill_Coeff_1*kappa(1,4)*z(1)*z(6);
du_1 = Hill_Coeff_2*kappa(2,4)*z(2)*z(5) + 0*Hill_Coeff_3*kappa(1,4)*z(1)*z(5); %Used by PPU
du_2 = Hill_Coeff_1*kappa(1,4)*z(1)*z(6); %Used by PVE
dr_1 = -kappa(1,1)*z(1)*z(7);
dr_2 = -kappa(2,1)*z(2)*z(8);
dx = [dx_1 dx_2 dy_1 dy_2 dw_1 dw_2 dr_1 dr_2 du_1 du_2 0]';