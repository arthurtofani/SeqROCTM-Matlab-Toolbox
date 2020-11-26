A = [0,1];
contexts  = {1,  [1 0], [1 0 0], [0 0 0]};
P = [1, 0; 0.3, 0.7; 0.2, 0.8; 0.25, 0.75];
n       = 20000;        % length of the stochastic sequence
max_height  = 6;        % height of the complete tree

path = '/home/arthur/Documents/Neuromat/projects/SMC/smallest_maximizer_criterion/examples/example2/samples/model1_5000.mat';
M = getfield(load(path), 'model1_5000');
idx = 99
X = M(idx,:);

[renwpoint, renewals] = tree_renewalpoint(contexts, P, A, X)
