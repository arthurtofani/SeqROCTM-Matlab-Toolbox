function r = test_block_resample(sz)
% rng(200);
rand('seed', 200); % change to the line above if this statement doesn't work on matlab
# X = generatesampleCTM(contexts, P, A, n);

% for this fixed random seed we should expect the sample X to start with:
% '00010101010100100010101000100100101010101001...'
% pls ensure it first
#X_str = num2str(X, "%i");



renewal_point =  1;
model = "model1";
spath = "/home/arthur/Documents/Neuromat/projects/SMC/smallest_maximizer_criterion/examples/example2/samples/";
spath = strcat(spath, model, '_', num2str(sz), '.mat');
M = getfield(load(spath), strcat(model, '_', num2str(sz)));

#for sz = [5000 10000 20000]
	for n = 1:100
		for b = 1:200
			folder = strcat("/home/arthur/tmp/samples/", num2str(sz), "/", num2str(n));
			filename = strcat(folder, "/", num2str(b), ".txt")
			X = M(n,:);
			B = bootstrap_blocks(X, renewal_point, sz, b);
			if ~exist(folder, 'dir')
       			mkdir(folder)
    		end
			fid = fopen (filename, "w");
			fputs (fid, strrep(num2str(B(1, :)), ' ', ''));
			fclose (fid);
		end
	end
#end



#stats

#[trees, Ps, ML, cutoff] = estimate_championTrees_newtest(X, max_height, A, 0, 1000)
