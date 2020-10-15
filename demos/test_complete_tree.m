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

[T, I] = completetree(X, max_height, A);
print_tree(T)

% it's expected to receive the following output
% 000000 100000 010000 001000 101000 000100 100100 010100 000010 100010 010010 001010 101010 000001 100001 010001 001001 101001 000101 100101 010101
%
% where nodes 010010, 010100, 010000, 010101, 010001 are not admissible (branches have only 1 leaf)


