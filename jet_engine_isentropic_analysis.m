%% Jet Engine Isentropic Analysis

% PARAMETERS 
ri = 0.4;              % Inlet radius [m]
Vi = 130;              % Indicated airspeed [m/s]
rc = 6;                % Compressor pressure ratio
T04 = 1300;            % Max temperature after combustion [K]

% CONSTANTS
gamma = 1.4;           % Specific heat ratio
R = 287;               % Gas constant [J/kg·K]
Cp = 1005;             % Specific heat at constant pressure [J/kg·K]
QR = 43.15e6;          % Fuel heating value [J/kg]

% SEA LEVEL ISA CONDITIONS 
T0 = 288.15;           % Temperature [K]
P0 = 101325;           % Pressure [Pa]
rho0 = 1.225;          % Density [kg/m³]

% ALTITUDE 
h = 0:1000:8000;       % Altitude [m]
n = length(h);         % Number of points

% ATMOSPHERIC CONDITIONS AT ALTITUDE
Ta = T0 - 0.0065 * h;                                % Ambient temperature [K]
Pa = P0 .* (1 - 2.2558e-5 * h).^5.25864;             % Ambient pressure [Pa]
rho_a = Pa ./ (R * Ta);                              % Density [kg/m³]
a = sqrt(gamma * R .* Ta);                           % Speed of sound [m/s]
M = Vi ./ a;                                         % Mach number

% INLET 
T02 = Ta .* (1 + 0.2 * M.^2);                         % Total temperature [K]
P02 = Pa .* (1 + 0.2 * M.^2).^(gamma/(gamma - 1));    % Total pressure [Pa]

% COMPRESSOR 
P03 = rc .* P02;                                      % Pressure after compression [Pa]
T03 = T02 .* (P03 ./ P02).^((gamma - 1)/gamma);       % Temperature after compression [K]

% COMBUSTION
f = (Cp * (T04 - T03)) ./ (QR - Cp * T04);            % Fuel-air ratio
P04 = P03;                                            % Assume no pressure loss

% TURBINE 
T05 = T04 - (T03 - T02) ./ (0.8 * (1 + f));           % Turbine exit temp [K]
P05 = P04 .* (T05 ./ T04).^(gamma / (gamma - 1));     % Turbine exit pressure [Pa]

% NOZZLE 
Pc = P05 ./ ((gamma + 1) / 2).^(gamma / (gamma - 1)); % Critical pressure [Pa]
choked = Pc >= Pa;                                    % Choked flow condition

P7 = Pa;
P7(choked) = Pc(choked);                              % Nozzle exit pressure [Pa]
T7 = T05;
T7(choked) = T05(choked) * (2 / (gamma + 1));         % Nozzle exit temp [K]

V7 = zeros(1, n);
V7(choked) = sqrt(gamma * R * T7(choked));            % Nozzle exit velocity [m/s]
T7(~choked) = T05(~choked) ./ ((P05(~choked) ./ Pa(~choked)).^((gamma - 1)/gamma));
V7(~choked) = sqrt(2 * Cp .* (T05(~choked) - T7(~choked)));

% THRUST CALC
Ae = pi * ri^2;                                       % Engine cross-sectional area [m²]
mdot_a = rho_a .* Vi .* Ae;                           % Mass flow rate of air [kg/s]
Thrust = mdot_a .* ((1 + f) .* V7 - Vi) + Ae .* (P7 - Pa);  % Thrust [N]

% EFFICIENCY 
eta_P = 2 * Vi ./ (Vi + V7);

% PLOTS

% 1) Thrust vs Altitude
figure;
plot(h, Thrust, 'LineWidth', 2);
xlabel('h, m');
ylabel('Thrust, N');
title('Thrust vs Altitude');
grid on;

% 2) Efficiency vs Altitude
figure;
plot(h, eta_P, 'LineWidth', 2);
xlabel('h, m');
ylabel('Propulsive Efficiency, η');
title('Efficiency');
grid on;

% 3) Total Temperature Profile
figure;
plot(1:6, [Ta(1), T02(1), T03(1), T04, T05(1), T7(1)], '-o', 'LineWidth', 2);
xticks(1:6); xticklabels({'1','2','3','4','5','7'});
xlabel('Engine Sections');
ylabel('T_t, K');
title('Total Temperature Profile');
grid on;

% 4) Total Pressure Profile
figure;
plot(1:6, [Pa(1), P02(1), P03(1), P03(1), P05(1), P7(1)], '-o', 'LineWidth', 2);
xticks(1:6); xticklabels({'1','2','3','4','5','7'});
xlabel('Engine Sections');
ylabel('P_t, Pa');
title('Total Pressure');
grid on;

% 5) Temperature-Entropy Diagram
figure;
plot(0:5, [Ta(1), T02(1), T03(1), T04, T05(1), T7(1)], '-o', 'LineWidth', 2);
xlabel('Entropy (abstract)');
ylabel('T_t, K');
title('Temperature-Entropy Diagram');
grid on;
