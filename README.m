% Code Running Instructions
% 
% This project contains two MATLAB functions:
% 
% LIF_population5.m
% This function runs the main leaky integrate-and-fire (LIF) population simulation and generates all figures.
% 
% testingvarb.m
% This function defines and tests different network configurations by setting the number of units, membrane time constants, and the connection weight matrix.


% How to run the project
% 
% Place LIF_population5.m and testingvarb.m in the same MATLAB working directory.
% 
% Open MATLAB and set the current folder to this directory.
% 
% Run
% testingvarb
% from the command window or by pressing Run in the editor.

% What testingvarb does
% 
% The function testingvarb constructs a small network (by default, 4 units) and defines the parameters needed for the simulation:
% 
% numUnits
% Number of neurons in the population.
% 
% tau
% Membrane time constant for each unit (currently set to 1 for all units).
% 
% W
% Connection weight matrix that determines how activity from one unit affects others.
% 
% The weight matrix is manually constructed using values drawn from normal distributions with different means.
% Some rows mainly produce excitatory effects, while one column contains negative weights to approximate inhibition.
% Self-connections are removed by setting the diagonal of the matrix to zero.
% 
% After defining these parameters, testingvarb calls:
% 
% LIF_population5(numUnits, W, tau)

% What LIF_population5 does
% 
% This function runs a population-level leaky integrate-and-fire simulation with the following components:
% 
% External input
% 
% Only unit 1 receives external input.
% 
% The input is generated as a Poisson-like random spike train using a thresholded random process.
% 
% The input is added directly to the membrane voltage.
% 
% LIF dynamics
% 
% Each unit follows leaky voltage dynamics:
% 
% Voltage decays with time constant tau
% 
% When voltage crosses a fixed threshold (set to 1), a spike is generated and voltage is reset to 0
% 
% Voltages are constrained to be non-negative
% 
% Synaptic interaction (double exponential form)
% 
% Instead of instantaneous coupling, synaptic effects are modeled using a double exponential function:
% 
% s = (W / K) * exp(-(t - last_spike)/tau_decay) .* (1 - exp(-(t - last_spike)/tau_rise))
% 
% where:
% 
% tau_rise controls how fast synaptic input rises
% 
% tau_decay controls how fast it decays
% 
% last_spike records the most recent spike time of each unit
% 
% K is a normalization constant ensuring consistent peak amplitude
% 
% The synaptic term s is added to the voltage update at each time step.
% 
% Noise
% 
% Gaussian noise scaled by sqrt(dt) is added to the voltage update to introduce variability.


% Output figures
% 
% The function automatically generates figures showing:
% 
% Unit voltage traces (stacked for visualization)
% 
% External input signals
% 
% Spike raster plots
% 
% Population spike rate computed using a sliding window
% 
% Population spike counts in fixed time windows
% 
% The connection weight matrix

% Modifying the simulation
% 
% To explore different network behaviors, users can modify parameters inside testingvarb.m, such as:
% 
% the number of units,
% 
% the membrane time constants tau,
% 
% the structure and scale of the weight matrix W.
% 
% No other changes are required to run the simulation.