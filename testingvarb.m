function testingvarb()

numUnits = 8;

% Define time constants for all units:
tau = ones(numUnits,1);

% Define connection weights:
W = zeros(numUnits);

% Testing out random weights:
% W = 2*rand(numUnits) - 1;
% W = 6*rand(numUnits)/numUnits;
% load('WeightOctober 6, 2025 01-28-33');

W(1,:) = normrnd(0.5, 0.1, 1, numUnits);
W(2,:) = normrnd(1.5, 0.1, 1, numUnits);
W(3,:) = normrnd(1.5, 0.1, 1, numUnits);
W(4,:) = normrnd(2, 0.1, 1, numUnits);
W(:,4) = normrnd(-1, 0.1, 1, numUnits);

W(5,:) = normrnd(0.5, 0.1, 1, numUnits);
W(6,:) = normrnd(1, 0.1, 1, numUnits);
W(7,:) = normrnd(-1, 0.1, 1, numUnits);
W(8,:) = normrnd(1.5, 0.1, 1, numUnits);
W(1,1) = 0; W(2,2) = 0; W(3,3) = 0; W(4,4) = 0;
W(5,5) = 0; W(6,6) = 0; W(7,7) = 0; W(8,8) = 0;
% W(9,:) = normrnd(0.5, 0.1, 1, numUnits);
% W(10,:) = normrnd(1, 0.1, 1, numUnits);
% W(11,:) = normrnd(-1, 0.1, 1, numUnits);
% W(12,:) = normrnd(1.5, 0.1, 1, numUnits);
% W(3,4) = -4.5;

W

% Now save out the Weight matrix W:
% save("SynchronizingWeight"+string(datetime("now","Format",'MMMM d, yyyy HH-mm-ss'))+".mat",'W')
% save( 'myfile.mat', 'W' )

% Create inhibition unit with negative weight
% W(:,3) = -0.5*rand(numUnits, 1);

LIF_population5(numUnits, W, tau);

% tests(numUnits, W, tau);
