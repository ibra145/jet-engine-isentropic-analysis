# Jet Engine Isentropic Analysis

MATLAB coursework project by Ibrahim Abdile analysing a simplified turbojet across altitudes from 0 to 8,000 m. The script calculates atmospheric conditions, engine station temperatures and pressures, fuel-to-air ratio, nozzle exit velocity, thrust and propulsive efficiency.

## Run

Open `jet_engine_isentropic_analysis.m` in MATLAB and run the script. It uses built-in MATLAB operations and generates five figures. No external data files are required.

## Inputs

- Inlet radius: 0.4 m
- Velocity used in the calculations: 130 m/s
- Compressor pressure ratio: 6
- Combustor exit total temperature: 1,300 K
- Constant specific heats, with gamma = 1.4, Cp = 1,005 J/(kg K) and R = 287 J/(kg K)

## Figures

The `figures` folder contains the five original graph images extracted from the submitted Word document.

- Thrust versus altitude
- Propulsive efficiency versus altitude
- Engine temperature profile
- Engine pressure profile
- Diagram labelled temperature–entropy in the original document

## Model notes

The MATLAB code and graph images are preserved from the original document. They have not yet been executed or validated in MATLAB as part of this extraction.

The efficiency graph decreases slightly with altitude; the original report states that it increases. The station profile plots mix static and total quantities despite their original total-temperature and total-pressure labels. The last plot uses an abstract station index rather than calculated entropy, so it is not a physical temperature–entropy diagram. The simplified model also uses the inlet area as the nozzle exit area, includes a factor of 0.8 in the turbine work relation without defining it, and applies a simplified propulsive efficiency expression. The velocity is labelled indicated airspeed in the code but is used directly in the Mach and mass-flow calculations.
