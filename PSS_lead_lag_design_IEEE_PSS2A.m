%% Initialize
% clc: Clears the command window.
% clear: Removes all variables from the workspace.
% clf: Clears the current figure window.
clc
clear
clf

%% Set up initial constants
% These constants represent various gains and time constants used in the transfer function of the generator.
% K_2, K_3, K_6, and K_e are gains.
% T_e, T_3, and T_R are time constants.
K_2 = 1.2;
K_3 = 0.5;
K_6 = 0.5;
K_e = 10;
T_e = 0.1;
T_3 = 2;
T_R = 0;

% Set up the initaial transfer function
% This line creates the transfer function G_gen for the generator using the tf function. 
% The numerator is the product of the gains, and the denominator is a polynomial formed from the time constants.
G_gen = tf(K_2*K_3*K_e, [T_3*T_e T_3+T_e 1+K_3*K_6*K_e]);

%% Solve for time constants for the Lead Compensater by given phase
% P_1 and P_2 are the phase criteria at which the lead compensator will be designed. The goal is to achieve a certain phase margin at these frequencies.
% k_1 and k_2 are ratios that will be used to determine the time constants for the lead compensators.
P_1 = -63; % Carteria of T_1: frequency at -63 deg
P_2 = -63; % Carteria of T_3: frequency at -63 deg after 1x lead-lag compensation
k_1 = 10; % Set T_1/T_2 ratio
k_2 = 10; % Set T_3/T_4 ratio

%% 1x lead-lag compensator
% Find phase at set-point frequency
figure (1)
[mag,phase,wout] = bode(G_gen);
W_1 = interp1(squeeze(phase), wout, P_1);
F_1 = 1/(2*pi*W_1);
T_1 = 1/(W_1);
T_2 = T_1/k_1;
% Set up the Lead Compensater
G_pss_1 = tf([T_1, 1],[T_2,1]);
G_1 = G_gen*G_pss_1;

%% 2x lead-lag compensator
% Find phase at set-point frequency
figure (1)
[mag,phase,wout] = bode(G_1);
W_2 = interp1(squeeze(phase), wout, P_2);
F_2 = 1/(2*pi*W_2);
T_3 = 1/(W_2);
T_4 = T_3/k_2;
% Set up the Lead Compensater
G_pss_2 = tf([T_3, 1],[T_4,1]);
G_2 = G_1*G_pss_2;

%% Obtain bode plots
figure (1)
hold on
bode(G_gen);
bode(G_pss_1);
bode(G_1);
bode(G_pss_1*G_pss_2);
bode(G_2);
hold off
grid on
% xLim([.6 13])
% legend('Un-compensated','1xLead-lag','1xCompensated','Location','East');
% legend('Un-compensated','2xLead-lag','2xCompensated','Location','NorthEast');
legend('Un-compensated','1xLead-lag','1xCompensated','2xLead-lag','2xCompensated','Location','Best');
fontsize(gca,15,"pixels")
