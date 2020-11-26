function [ret] = write_sample(sample, filename)
  fid = fopen(filename, "wb");
  fputs(fid, strrep(num2str(sample), " ", ""));
  fclose(fid);
endfunction
