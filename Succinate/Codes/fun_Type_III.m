function dx = fun_Type_III(t, z, kappa, threshold)
%z(1), dx_1: biomass bacterial species 1. z(2), dx_2: biomass bacterial
%species 2. z(3), dy_1: biomass complex. z(4), dy_2: biomass complex.
%z(5), dw_1 biomass waste produced by species 1 that can be used by species
%2. z(6), dw_2: biomass waste produced by species 2 that can be used by
%species 1. z(7), dr: biomass resource.
% Model: S_i + R -> P_i -> 2S_i, P_i <-> S_i + W_i, S_j + W_i -> P_j.
z(z<=0) = 0;
T_1 = 1.5;%(z(6) - threshold(1) > 0);
T_2 = 1.5;%(z(5) - threshold(2) > 0);
t_1 = 0; t_2 = 0; %Lag time, if there are lag times then t_i > 0.
dx_1 = (2*kappa(1,2) + kappa(1,3))*z(3) - kappa(1,1)*z(1)*z(7) - kappa(1,4)*z(1)*z(6)^T_1;
dx_2 = (2*kappa(2,2) + kappa(2,3))*z(4) - kappa(2,1)*z(2)*z(7) - kappa(2,4)*z(2)*z(5)^T_2;
dy_1 = -(kappa(1,2) + kappa(1,3))*z(3) + kappa(1,1)*z(1)*z(7) + kappa(1,4)*z(1)*z(6)^T_1;
dy_2 = -(kappa(2,2) + kappa(2,3))*z(4) + kappa(2,1)*z(2)*z(7) + kappa(2,4)*z(2)*z(5)^T_2;
dw_1 = kappa(1,3)*z(3) - kappa(2,4)*z(2)*z(5)^T_2;
dw_2 = kappa(2,3)*z(4) - kappa(1,4)*z(1)*z(6)^T_1;
dr = -(t >= t_1)*kappa(1,1)*z(1)*z(7) - (t >= t_2)*kappa(2,1)*z(2)*z(7);
du_1 = kappa(2,4)*z(2)*z(5)^T_2; %Used by PPU
du_2 = kappa(1,4)*z(1)*z(6)^T_1; %Used by PVE
dx = [(t >= t_1)*dx_1; (t >= t_2)*dx_2; (t >= t_1)*dy_1; (t >= t_2)*dy_2; (t >= t_1)*dw_1; (t >= t_2)*dw_2; dr; du_1; du_2; 0];