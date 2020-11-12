A = [0,1];
contexts  = {1,  [1 0], [1 0 0], [0 0 0]};
P = [1, 0; 0.3, 0.7; 0.2, 0.8; 0.25, 0.75];
n       = 20000;        % length of the stochastic sequence
max_height  = 6;        % height of the complete tree

% fix the seed if you want to control random generations

% rng(200);
rand('seed', 200); % change to the line above if this statement doesn't work on matlab
X = generatesampleCTM(contexts, P, A, n);
% for this fixed random seed we should expect the sample X to start with:
% '00010101010100100010101000100100101010101001...'
% pls ensure it first
X_str = num2str(X, "%i");
#printf(X_str);
#printf("\n\n");

c = 0
[tau, p] = estimate_contexttree(X, A, max_height, 'bic', c);
print_tree(tau)

[trees, Ps, ML, cutoff] = estimate_championTrees(X, max_height, A, 0, 500)

