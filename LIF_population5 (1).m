function LIF_population5(n, W, tau)

% A revised version of the LIF network model we've built, with poisson input that stimulates spikes.

% Number of units in simulation:
numUnits = n;


% Define time variables:
dt = 0.005;
maxTime = 50;
t = 0 : dt : maxTime; % the main time vector
numSteps = length(t);
theta = 0.95;


% Define noise coefficient using Poisson process:
noise = zeros(numUnits, numSteps);
% noise = exprnd(1, numUnits, numSteps);
% noise(1,:) = rand(1,numSteps) > theta;


% Define voltage thresholds for generating a spike:
% threshold = 0.5*ones(numUnits,1);
% threshold = ones(numUnits,1);
threshold = 1 .* ones(numUnits,1);


% Define input: 
I = zeros(numUnits,numSteps);
% I = ones(numUnits, numSteps);
I(1,:) = 1 * (rand(1,numSteps) > theta);
% total = sum(I, 2);
% rate = total/maxTime


% Define voltage and spikes arrays:
V = zeros(numUnits, numSteps);
% V(:,1) = 0;
Spikes = zeros(numUnits, numSteps);
% Spikes(:,1) = 0;


tau_rise = 1;
tau_decay = 1;

last_spike = -inf(numUnits, 1);

% Simulation loop:
for i = 1 : numSteps-1

    for u = 1 : numUnits
        if Spikes(u,i) == 1
            last_spike(u) = t(i);
        end
    end 

    V(:,i) = V(:,i) + I(:,i)./tau;

    K = (tau_decay / (tau_rise + tau_decay)) * (tau_rise / (tau_rise + tau_decay))^(tau_rise / tau_decay);

    % Decay process after inputs
    s = W / K * exp( -(t(i) - last_spike(:)) ./ tau_decay) .* (1 - exp( -(t(i) - last_spike(:)) ./ tau_rise));
    % dV = -V(:,i)./tau + s + I(:,i)./tau;
    dV = -V(:,i)./tau + s;
    V(:,i+1) = V(:,i) + dV * dt + noise(:,i).*sqrt(dt).*randn(numUnits,1);


    % Now deal with instantaneous jumps provided by other spiking units:
    % V(:,i+1) = V(:,i+1) + W*Spikes(:,i)./tau;

    Spikes(:,i+1) = V(:,i+1) > threshold;

    V( logical(Spikes(:,i+1)), i+1 ) = 0;

    % Don't let units go negative in voltage:
    V( V(:,i+1) < 0, i+1 ) = 0;

end



% Plot out the outputs in one subplot, and external input in second
% subplot:
f = figure; 
subplot(3,1,1)
hold on
title('Unit activations')
for i = 1:numUnits
    plot( t, V(i,:) + (i-1)*(threshold(i,1)+1), 'k' );
end

subplot(3,1,2)
hold on
title('External inputs')
for i = 1:numUnits
    % plot( t, I(i,:) + 1.1*max(I,[],'all')*i, 'b' );
    plot( t, 0.6 * I(i,:) + (i-1), 'b');
end


subplot(3,1,3)
hold on
title('Spikes')
for i = 1:numUnits
    plot( t, 0.6 * Spikes(i,:) + (i-1), 'm' );
end


% Count up spikes in sliding windows
figure
window = 1;
dw = 0.001;
% maxStep = maxTime - window;
windTime = 0 : dw : maxTime;
windStep = length(windTime);

for i = 1 : windStep
    if windTime(1,i) + window > maxTime
        SpikeRate(:,i) = sum( Spikes(:, t > windTime(1,i)), 2);
    end
    SpikeRate(:,i) = sum( Spikes(:, t > windTime(1,i) & t < windTime(1,i) + window), 2);
end

SpikeRate = sum(SpikeRate);
subplot(3,1,1);
hold on
title('Population Spike Rate')
plot(windTime, SpikeRate);

numWindows = maxTime/window;
for i = 1 : numWindows
    SpikeCount(:,i) = sum( Spikes(:, t > (i-1)*window & t < i*window), 2);
end

popCount = sum(SpikeCount);
subplot(3,1,2);
hold on
title('Population Spike Count')
bar(1:numWindows, popCount, "BarWidth", 1)


subplot(3,1,3)
hold on
title('Weights')
imagesc(W)



% for i = 1:numUnits
%     subplot(numUnits,1,i);
%     hold on
%     title("Unit " + i)
%     bar(SpikeCount(i,:)); 
% end

% % keyboard
% 
% % Now plot correlation plots:
% figure
% for i = 1:numUnits
%     for j = 1:numUnits
%         subplot(numUnits,numUnits,(i-1)*numUnits+j);
%         scatter(SpikeCount(i,:),SpikeCount(j,:));
%         ylim('padded'), xlim('padded')
%         hold on
%         title(sprintf('Row %d Column %d',i,j))
%     end
% end
