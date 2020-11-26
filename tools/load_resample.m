function X = load_resample(filename)
	fid = fopen(filename, "r");
	txt = fgets(fid);
	fclose(fid);
	X = zeros(1, length(txt));
	for i = 1:length(txt)
  		X(i) = str2num(txt(i));
	endfor
end
