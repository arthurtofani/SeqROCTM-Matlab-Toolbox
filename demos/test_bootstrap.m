csv_file = "/home/arthur/Documents/Neuromat/projects/SMC/smallest_maximizer_criterion/examples/example2/results/SeqROCTM/2/model1_5000.csv";
sample_folder = "/home/arthur/Documents/Neuromat/projects/SMC/smallest_maximizer_criterion/examples/example2/results/SeqROCTM/2/model1_5000";
header = "model_name,sample_idx,method,tree_idx,tree,num_contexts,likelihood,opt\n";


#csv_file = "/var/tmp/tofani/smc/data/model1_5000.csv"
#sample_folder = "/var/tmp/tofani/smc/data/samples";


time_file = strcat(csv_file, ".time.txt")
fid = fopen(csv_file, "wb");
fputs(fid, header);
fclose(fid);
fid = fopen(time_file, "wb");
fputs(fid, header);
fclose(fid);



A = [0,1];
contexts  = {1,  [1 0], [1 0 0], [0 0 0]};
P = [1, 0; 0.3, 0.7; 0.2, 0.8; 0.25, 0.75];
n       = 5000;        % length of the stochastic sequence
max_height  = 6;        % height of the complete tree
pkg load statistics
% fix the seed if you want to control random generations

% rng(200);
rand('seed', 200); % change to the line above if this statement doesn't work on matlab

th_renwpoint = 1;
Repetitions = 100;				% number of times the procedure is repeated
B 			= 200;				% number of bootstrap samples
n1 			= floor(0.3*n); 	% proportion of the size of the sample corresponding to the size of the smaller resample.
n2 			= floor(0.9*n);		% proportion of the size of the sample corresponding to the size of the larger resample.
alpha 		= 0.01;            	% alpha level to use on thefid = fopen(csv_file, "a");

c_min 		= 0;				% minimum value of the BIC constant
c_max 		= 1000;				% maximum value of the BIC constant


# X = generatesampleCTM(contexts, P, A, n);

% for this fixed random seed we should expect the sample X to start with:
% '00010101010100100010101000100100101010101001...'
% pls ensure it first
#X_str = num2str(X, "%i");

path = '/home/arthur/Documents/Neuromat/projects/SMC/smallest_maximizer_criterion/examples/example2/samples/model1_5000.mat';
M = getfield(load(path), 'model1_5000');
#pkg load dataframe
#idx = 99
#X = M(idx,:);


mG1 = []; mG2 = []; mG3 = [];

for r = 1 : Repetitions
t1 = time
#r = 1
X = M(r,:);
[championTrees, Ps, ML, cutoff] = estimate_championTrees_newtest(X, max_height, A, c_min, c_max);
#bootsamples_n2 = bootstrap_resample_files(X, th_renwpoint, n2, Repetitions, B);
nTrees = length(championTrees);
bootsamples_n2 = bootstrap_blocks(X, th_renwpoint, n2, B);
diff_n1 = zeros(nTrees-1, B);
diff_n2 = zeros(nTrees-1, B);

% initialize L_current
L_current = zeros(B,2);

for b = 1 : B
    L_current(b,1) = treeloglikelihood(championTrees{1}, A, bootsamples_n2(b, 1:n1));
    L_current(b,2) = treeloglikelihood(championTrees{1}, A, bootsamples_n2(b,:));
    fld2 = strcat(sample_folder, "/", num2str(r), "_", num2str(b));
    write_sample(bootsamples_n2(b, 1:n1), strcat(fld2, "_n1.txt"));
    write_sample(bootsamples_n2(b,:), strcat(fld2, "_n2.txt"));
end

for t = 1 : nTrees-1
    L_next = zeros(B,2); % store the log-likelihood of tree t+1 to speed-up
    for b = 1 : B
        %
        L_next(b,1) = treeloglikelihood(championTrees{t+1}, A, bootsamples_n2(b, 1:n1));
        L_next(b,2) = treeloglikelihood(championTrees{t+1}, A, bootsamples_n2(b,:));
        
        % difference for n1 
        diff_n1(t,b) = (L_current(b,1) - L_next(b,1))/(n1^0.9);
        
        % difference for n2
        diff_n2(t,b) = (L_current(b,2) - L_next(b,2))/(n2^0.9);
    end
    L_current = L_next;
end

% looks for the smallest context tree such that the null hypothesis is rejected
pvalue = 1;
t = nTrees;
  while (pvalue > alpha)&&(t > 1)
      t = t - 1;
      [~, pvalue] = ttest2(diff_n1(t,:), diff_n2(t,:), 'Alpha', alpha, 'Tail', 'right');
      #dlmwrite('/home/arthur/Documents/Neuromat/projects/SMC/arquivo/n1.txt', diff_n1(t,:), 'delimiter','\n', 'newline','pc','precision',13);
      #dlmwrite('/home/arthur/Documents/Neuromat/projects/SMC/arquivo/n2.txt', diff_n2(t,:), 'delimiter','\n', 'newline','pc','precision',13);
      pvalue
      xx = 0;
      xx = xx+1;      
  end
  
  idx = t+1;
  opt_tree = championTrees{idx};
  t2 = time

  col_mdl = "model1";
  col_met = "seqROCTM";
  for i = 1 : length(championTrees)
    ss = col_mdl;
    col_sample_idx = num2str(r-1);
    ss = strcat(ss, ", ", col_sample_idx);
    ss = strcat(ss, ", ", col_met);
    col_tree_idx = num2str(i-1);  
    ss = strcat(ss, ", ", col_tree_idx);
    col_tree = print_tree(championTrees{i});
    ss = strcat(ss, ", ", col_tree);
    col_num = num2str(length(championTrees{i}));
    ss = strcat(ss, ", ", col_num);
    col_likelihood = num2str(ML(i));
    ss = strcat(ss, ", ", col_likelihood);
    col_opt = num2str(i == idx);
    ss = strcat(ss, ", ", col_opt, "\n" );
    
    ss
    fid = fopen(csv_file, "a");
    fputs(fid, ss);
    fclose(fid);
  end
  fid = fopen(time_file, "a");
  tt = num2str(t2 - t1)
  fputs(fid, strcat(tt, "\n"));
  fclose(fid);

end
#folder = "/home/arthur/tmp/out"
#csv_file = "/home/arthur/Documents/Neuromat/projects/SMC/smallest_maximizer_criterion/examples/example2/results/SeqROCTM/2/model1_5000.csv"
#header = "model_name,sample_idx,method,tree_idx,tree,num_contexts,likelihood,opt"

