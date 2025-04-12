%Author: CHAN Yun Sang Ethan
clc
clear
clf

K_2 = 1.2;
K_3 = 0.5;
K_6 = 0.5;
K_e = 10;
T_e = 0.1;
T_3 = 2;
T_R = 0;

Ggen = tf(K_2*K_3*K_e, [T_3*T_e T_3+T_e 1+K_3*K_6*K_e]);
frequency_range=0:0.001:400;
hold on;
bp_gen = bodeplot(Ggen, frequency_range, 'b.-');
bp_gen.FrequencyScale = "log";
bp_gen.FrequencyUnit = "rad/s";
bp_gen.PhaseVisible = "on";
bp_gen.MagnitudeVisible = "on";
bp_gen.Title.FontSize = 20;
bp_gen.XLabel.FontSize = 15;
bp_gen.Title.Color = [0 0 0];
bp_gen.Title.String = 'Uncompensated Generator Frequency Response';
grid on;
hold off;

% Get the Bode plot axes
ax = findall(1, 'Type', 'Axes');

% Set x-axis ticks and labels for the magnitude plot (first axis)
xtick=[0.1, 0.2, 0.3, 0.4,0.6, 0.8,1.2, 1.6, 2,3,4,6,8,10, 12.6];
XTickLabel=[{'0.1'}, {'0.2'},{'0.3'}, {'0.4'}, {'0.6'},{'0.8'}, {'1.2'}, {'1.6'}, {'2'},{'3'}, {'4'}, {'6'}, {'8'}, {'10'},{'12.6'}];

set(ax(1), 'XTick', xtick); % Adjust as needed
set(ax(1), 'XTickLabel', XTickLabel); % Set labels as integers

% Set x-axis ticks and labels for the phase plot (second axis)
set(ax(2), 'XTick', xtick); % Adjust as needed
set(ax(2), 'XTickLabel', XTickLabel); % Set labels as integers

% Increase font size for x-axis and y-axis tick labels
set(ax(1), 'FontSize', 14); % Font size for magnitude plot
set(ax(2), 'FontSize', 14); % Font size for phase plot

% Create dummy plots for legends
hold(ax(1), 'on');
hold(ax(2), 'on');
plot(ax(1), NaN, NaN, 'b-', 'DisplayName', 'Uncompensated Magnitude');
plot(ax(2), NaN, NaN, 'b-', 'DisplayName', 'Uncompensated Phase');

% Create legends
legend(ax(1), 'Uncompensated Magnitude', 'Location', 'southwest', 'box', 'off');
legend(ax(2), 'Uncompensated Phase', 'Location', 'southwest', 'box', 'off');


% Increase font size for the title
% title(ax(1), 'Uncompensated Generator Frequency Response', 'FontSize', 15);

% Set x-axis tick label color to pure black
set(ax(1), 'XColor', 'k'); % Set x-axis color for magnitude plot
set(ax(2), 'XColor', 'k'); % Set x-axis color for phase plot

% Set the color of the tick labels to black
ax(1).XAxis.TickLabelFormat = '%g'; % Ensure the format is correct
ax(2).XAxis.TickLabelFormat = '%g'; % Ensure the format is correct
set(ax(1), 'TickLabelInterpreter', 'none'); % Disable interpreter for tick labels
set(ax(2), 'TickLabelInterpreter', 'none'); % Disable interpreter for tick labels

% % 1st stage Lead-Lag Filter 
% Generate Bode plot data

% Generate logarithmically spaced frequencies from 0.5 Hz to 2 Hz
frequencies_in_hz = logspace(log10(0.01), log10(3), 10000); % 10,000 points from 0.1 to 3 Hz

[~, phase, wout] = bode(Ggen, 2 * pi * frequencies_in_hz);

% Convert phase to degrees and squeeze the arrays
phase_deg = squeeze(phase); % Remove singleton dimensions
wout = squeeze(wout); % Remove singleton dimensions

% Find the index where phase is closest to -45 degrees
target_phase_1st = -65;
[~, idx] = min(abs(phase_deg - target_phase_1st));

% Get the corresponding frequency in radian
frequency_at_phase = (wout(idx));

% Display the result
fprintf('Cut-off Frequency of 1st lead filter at %d degrees: %.4f rad/s\n', target_phase_1st, frequency_at_phase);

T_P1 = 1/frequency_at_phase
T_P2=T_P1/14.8

Gpss1 = tf([T_P1, 1],[T_P2,1]);
Ggen1 = Ggen*Gpss1;
figure(2);
hold on;

bp_gen = bodeplot(Ggen, frequency_range, 'b.-');
bp_gen.FrequencyScale = "log";
bp_gen.FrequencyUnit = "rad/s";
bp_gen.PhaseVisible = "on";
bp_gen.MagnitudeVisible = "on";
bp_gen.Title.FontSize = 20;
bp_gen.XLabel.FontSize = 15;
bp_gen.Title.Color = [0 0 0];

bp_G_1_compensated = bodeplot(Ggen1, frequency_range, 'r.-');
bp_G_1_compensated.FrequencyScale = "log";
bp_G_1_compensated.FrequencyUnit = "rad/s";
bp_G_1_compensated.PhaseVisible = "on";
bp_G_1_compensated.MagnitudeVisible = "on";
bp_G_1_compensated.Title.FontSize = 20;
bp_G_1_compensated.XLabel.FontSize = 15;
bp_G_1_compensated.Title.Color = [0 0 0];
bp_G_1_compensated.Title.String = 'First stage Lead-Lag Compensated Frequency Response';

bp_G_pss_1st = bodeplot(Gpss1, frequency_range, 'g.-');
bp_G_pss_1st.FrequencyScale = "log";
bp_G_pss_1st.FrequencyUnit = "rad/s";
bp_G_pss_1st.PhaseVisible = "on";
bp_G_pss_1st.MagnitudeVisible = "on";
bp_G_pss_1st.Title.FontSize = 20;
bp_G_pss_1st.XLabel.FontSize = 15;
bp_G_pss_1st.Title.Color = [0 0 0];

grid on;
hold off;

% Get the Bode plot axes
ay = findall(2, 'Type', 'Axes');

set(ay(1), 'XTick', xtick); % Adjust as needed
set(ay(1), 'XTickLabel', XTickLabel); % Set labels as integers

% Set x-axis ticks and labels for the phase plot (second axis)
set(ay(2), 'XTick', xtick); % Adjust as needed
set(ay(2), 'XTickLabel', XTickLabel); % Set labels as integers

% Increase font size for x-axis and y-axis tick labels
set(ay(1), 'FontSize', 14); % Font size for magnitude plot
set(ay(2), 'FontSize', 14); % Font size for phase plot

% Create dummy plots for legends
hold(ay(1), 'on');
hold(ay(2), 'on');

% Create dummy plots for the magnitude legend
plot(ay(1), NaN, NaN, 'b-', 'DisplayName', 'Uncompensated Magnitude');
plot(ay(1), NaN, NaN, 'r-', 'DisplayName', 'Compensated Magnitude');
plot(ay(1), NaN, NaN, 'g-', 'DisplayName', 'Gpss 1st Filter');

% Create dummy plot for the phase legend
plot(ay(2), NaN, NaN, 'b-', 'DisplayName', 'Uncompensated Phase');
plot(ay(2), NaN, NaN, 'r-', 'DisplayName', 'Compensated Phase');
plot(ay(2), NaN, NaN, 'g-', 'DisplayName', 'Gpss 1st Filter');

% Create legends for both axes
legend(ay(1), {'Uncompensated Magnitude', 'Compensated Magnitude', 'Gpss 1st Filter'},'Location', 'southwest', 'box', 'off');

legend(ay(2), {'Uncompensated Phase', 'Compensated Phase', 'Gpss 1st Filter'},'Location', 'southwest', 'box', 'off');

% Set x-axis tick label color to pure black
set(ay(1), 'XColor', 'k'); % Set x-axis color for magnitude plot
set(ay(2), 'XColor', 'k'); % Set x-axis color for phase plot

% Set the color of the tick labels to black
ay(1).XAxis.TickLabelFormat = '%g'; % Ensure the format is correct
ay(2).XAxis.TickLabelFormat = '%g'; % Ensure the format is correct
set(ay(1), 'TickLabelInterpreter', 'none'); % Disable interpreter for tick labels
set(ay(2), 'TickLabelInterpreter', 'none'); % Disable interpreter for tick labels


% % 2nd stage Lead-Lag Filter 
% Generate Bode plot data
[mag, phase, wout] = bode(Ggen1, 2 * pi * frequencies_in_hz);

% Convert phase to degrees and squeeze the arrays
phase_deg = squeeze(phase); % Remove singleton dimensions
wout = squeeze(wout); % Remove singleton dimensions

% Find the index where phase is closest to -45 degrees
target_phase_2nd = -45;
[~, idx] = min(abs(phase_deg - target_phase_2nd));

% Get the corresponding frequency in Radian
frequency_at_phase_2nd = (wout(idx));
% frequency_at_phase_2nd = 3;

% Display the result
fprintf('Cut-off Frequency of 2nd lag filter at %d degrees: %.4f rad/s\n', target_phase_2nd, frequency_at_phase_2nd);

T_P3 = 1/frequency_at_phase_2nd
T_P4=T_P3/14.8

T_P1P2_Ratio=T_P1/T_P2;
T_P3P4_Ratio=T_P3/T_P4;

fprintf('T1/T2 ratio is %.1f and T3/T4 ratio is %.1f\n', T_P1P2_Ratio, T_P3P4_Ratio);

Gpss2 = tf([T_P3, 1],[T_P4,1]);
Ggen2 = Ggen*Gpss2;
Gpss=Gpss1*Gpss2;

figure(3);
hold on;

bp_gen = bodeplot(Ggen, frequency_range, 'b.-');
bp_gen.FrequencyScale = "log";
bp_gen.FrequencyUnit = "rad/s";
bp_gen.PhaseVisible = "on";
bp_gen.MagnitudeVisible = "on";
bp_gen.Title.FontSize = 20;
bp_gen.XLabel.FontSize = 15;
bp_gen.Title.Color = [0 0 0];

bp_G_2_compensated = bodeplot(Ggen2, frequency_range, 'r.-');
bp_G_2_compensated.FrequencyScale = "log";
bp_G_2_compensated.FrequencyUnit = "rad/s";
bp_G_2_compensated.PhaseVisible = "on";
bp_G_2_compensated.MagnitudeVisible = "on";
bp_G_2_compensated.Title.FontSize = 20;
bp_G_2_compensated.XLabel.FontSize = 15;
bp_G_2_compensated.Title.Color = [0 0 0];
bp_G_2_compensated.Title.String = 'Second stage Lead-Lag Compensated Frequency Response';

bp_G_pss_1st = bodeplot(Gpss1, frequency_range, 'k.-');
bp_G_pss_1st.FrequencyScale = "log";
bp_G_pss_1st.FrequencyUnit = "rad/s";
bp_G_pss_1st.PhaseVisible = "on";
bp_G_pss_1st.MagnitudeVisible = "on";
bp_G_pss_1st.Title.FontSize = 20;
bp_G_pss_1st.XLabel.FontSize = 15;
bp_G_pss_1st.Title.Color = [0 0 0];

bp_G_pss_2nd = bodeplot(Gpss2, frequency_range, 'g.-');
bp_G_pss_2nd.FrequencyScale = "log";
bp_G_pss_2nd.FrequencyUnit = "rad/s";
bp_G_pss_2nd.PhaseVisible = "on";
bp_G_pss_2nd.MagnitudeVisible = "on";
bp_G_pss_2nd.Title.FontSize = 20;
bp_G_pss_2nd.XLabel.FontSize = 15;
bp_G_pss_2nd.Title.Color = [0 0 0];

bp_G_pss = bodeplot(Gpss, frequency_range, 'm.-');
bp_G_pss.FrequencyScale = "log";
bp_G_pss.FrequencyUnit = "rad/s";
bp_G_pss.PhaseVisible = "on";
bp_G_pss.MagnitudeVisible = "on";
bp_G_pss.Title.FontSize = 20;
bp_G_pss.XLabel.FontSize = 15;
bp_G_pss.Title.Color = [0 0 0];

grid on;
hold off;

% Get the Bode plot axes
az = findall(3, 'Type', 'Axes');

set(az(1), 'XTick', xtick); % Adjust as needed
set(az(1), 'XTickLabel', XTickLabel); % Set labels as integers

% Set x-axis ticks and labels for the phase plot (second axis)
set(az(2), 'XTick', xtick); % Adjust as needed
set(az(2), 'XTickLabel', XTickLabel); % Set labels as integers

% Increase font size for x-axis and y-axis tick labels
set(az(1), 'FontSize', 14); % Font size for magnitude plot
set(az(2), 'FontSize', 14); % Font size for phase plot

% Create dummy plots for legends
hold(az(1), 'on');
hold(az(2), 'on');

% Create dummy plots for the magnitude legend
plot(az(1), NaN, NaN, 'b-', 'DisplayName', 'Uncompensated Magnitude');
plot(az(1), NaN, NaN, 'r-', 'DisplayName', 'Magnitude of Compensated by 2nd Stage Filter');
plot(az(1), NaN, NaN, 'k-', 'DisplayName', 'Gpss 1st Filter');
plot(az(1), NaN, NaN, 'g-', 'DisplayName', 'Gpss 2nd Filter');
plot(az(1), NaN, NaN, 'm-', 'DisplayName', 'Gpss 1st + 2nd Filter');

% Create dummy plot for the phase legend
plot(az(2), NaN, NaN, 'b-', 'DisplayName', 'Uncompensated Phase');
plot(az(2), NaN, NaN, 'r-', 'DisplayName', 'Magnitude of Compensated by 2nd Stage Filter');
plot(az(2), NaN, NaN, 'k-', 'DisplayName', 'Gpss 1st Filter');
plot(az(2), NaN, NaN, 'g-', 'DisplayName', 'Gpss 2nd Filter');
plot(az(2), NaN, NaN, 'm-', 'DisplayName', 'Gpss 1st + 2nd Filter');

% Create legends for both axes
legend(az(1), {'Uncompensated Magnitude', 'Magnitude of Compensated by 2nd Stage Filter','Gpss 1st Filter', 'Gpss 2nd Filter', 'Gpss 1st + 2nd Filter'},'Location', 'southwest', 'box', 'off');
legend(az(2), {'Uncompensated Phase', 'Magnitude of Compensated by 2nd Stage Filter', 'Gpss 1st Filter','Gpss 2nd Filter','Gpss 1st + 2nd Filter'},'Location', 'southwest', 'box', 'off');


% Set x-axis tick label color to pure black
set(az(1), 'XColor', 'k'); % Set x-axis color for magnitude plot
set(az(2), 'XColor', 'k'); % Set x-axis color for phase plot

% Set the color of the tick labels to black
az(1).XAxis.TickLabelFormat = '%g'; % Ensure the format is correct
az(2).XAxis.TickLabelFormat = '%g'; % Ensure the format is correct
set(az(1), 'TickLabelInterpreter', 'none'); % Disable interpreter for tick labels
set(az(2), 'TickLabelInterpreter', 'none'); % Disable interpreter for tick labels

GgenCompensated=Ggen*Gpss;

figure(4);
hold on;

bp_gen = bodeplot(Ggen, frequency_range, 'b.-');
bp_gen.FrequencyScale = "log";
bp_gen.FrequencyUnit = "rad/s";
bp_gen.PhaseVisible = "on";
bp_gen.MagnitudeVisible = "on";
bp_gen.Title.FontSize = 20;
bp_gen.XLabel.FontSize = 15;
bp_gen.Title.Color = [0 0 0];

bp_G_1_compensated = bodeplot(Ggen1, frequency_range, 'r.-');
bp_G_1_compensated.FrequencyScale = "log";
bp_G_1_compensated.FrequencyUnit = "rad/s";
bp_G_1_compensated.PhaseVisible = "on";
bp_G_1_compensated.MagnitudeVisible = "on";
bp_G_1_compensated.Title.FontSize = 20;
bp_G_1_compensated.XLabel.FontSize = 15;
bp_G_1_compensated.Title.Color = [0 0 0];
bp_G_1_compensated.Title.String = 'Combined Effect of Lead-Lag Compensation Filter';

bp_G_2_compensated = bodeplot(Ggen2, frequency_range, 'k.-');
bp_G_2_compensated.FrequencyScale = "log";
bp_G_2_compensated.FrequencyUnit = "rad/s";
bp_G_2_compensated.PhaseVisible = "on";
bp_G_2_compensated.MagnitudeVisible = "on";
bp_G_2_compensated.Title.FontSize = 20;
bp_G_2_compensated.XLabel.FontSize = 15;
bp_G_2_compensated.Title.Color = [0 0 0];

bp_G_gen_compensated = bodeplot(GgenCompensated, frequency_range, 'g.-');
bp_G_gen_compensated.FrequencyScale = "log";
bp_G_gen_compensated.FrequencyUnit = "rad/s";
bp_G_gen_compensated.PhaseVisible = "on";
bp_G_gen_compensated.MagnitudeVisible = "on";
bp_G_gen_compensated.Title.FontSize = 20;
bp_G_gen_compensated.XLabel.FontSize = 15;
bp_G_gen_compensated.Title.Color = [0 0 0];

bp_G_pss = bodeplot(Gpss, frequency_range, 'm.-');
bp_G_pss.FrequencyScale = "log";
bp_G_pss.FrequencyUnit = "rad/s";
bp_G_pss.PhaseVisible = "on";
bp_G_pss.MagnitudeVisible = "on";
bp_G_pss.Title.FontSize = 20;
bp_G_pss.XLabel.FontSize = 15;
bp_G_pss.Title.Color = [0 0 0];

grid on;
hold off;

% Get the Bode plot axes
aa = findall(4, 'Type', 'Axes');

set(aa(1), 'XTick', xtick); % Adjust as needed
set(aa(1), 'XTickLabel', XTickLabel); % Set labels as integers

% Set x-axis ticks and labels for the phase plot (second axis)
set(aa(2), 'XTick', xtick); % Adjust as needed
set(aa(2), 'XTickLabel', XTickLabel); % Set labels as integers

% Increase font size for x-axis and y-axis tick labels
set(aa(1), 'FontSize', 14); % Font size for magnitude plot
set(aa(2), 'FontSize', 14); % Font size for phase plot

% Create dummy plots for legends
hold(aa(1), 'on');
hold(aa(2), 'on');

% Create dummy plots for the magnitude legend
plot(aa(1), NaN, NaN, 'b-', 'DisplayName', 'Uncompensated Magnitude');
plot(aa(1), NaN, NaN, 'r-', 'DisplayName', 'G1 compensated');
plot(aa(1), NaN, NaN, 'k-', 'DisplayName', 'G2 compensated');
plot(aa(1), NaN, NaN, 'g-', 'DisplayName', 'Ggen compensated');
plot(aa(1), NaN, NaN, 'm-', 'DisplayName', 'Gpss');

% Create dummy plot for the phase legend
plot(aa(2), NaN, NaN, 'b-', 'DisplayName', 'Uncompensated Magnitude');
plot(aa(2), NaN, NaN, 'r-', 'DisplayName', 'G1 compensated');
plot(aa(2), NaN, NaN, 'k-', 'DisplayName', 'G2 compensated');
plot(aa(2), NaN, NaN, 'g-', 'DisplayName', 'Ggen compensated');
plot(aa(2), NaN, NaN, 'm-', 'DisplayName', 'Gpss');

% Create legends for both axes
legend(aa(1), {'Uncompensated Magnitude', 'G1 compensated','G2 compensated', 'Ggen compensated', 'Gpss'},'Location', 'southwest', 'box', 'off');
legend(aa(2), {'Uncompensated Phase', 'G1 compensated', 'G2 compensated','Ggen compensated','Gpss'},'Location', 'southwest', 'box', 'off');


% Set x-axis tick label color to pure black
set(aa(1), 'XColor', 'k'); % Set x-axis color for magnitude plot
set(aa(2), 'XColor', 'k'); % Set x-axis color for phase plot

% Set the color of the tick labels to black
aa(1).XAxis.TickLabelFormat = '%g'; % Ensure the format is correct
aa(2).XAxis.TickLabelFormat = '%g'; % Ensure the format is correct
set(aa(1), 'TickLabelInterpreter', 'none'); % Disable interpreter for tick labels
set(aa(2), 'TickLabelInterpreter', 'none'); % Disable interpreter for tick labels
