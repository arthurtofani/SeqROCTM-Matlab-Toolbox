function filenames = get_resamples(folder, sample_size, sample_idx)
  fld = strcat(folder, "/", num2str(sample_size), "/", num2str(sample_idx));
  files = dir(fld);
  filenames = arrayfun(@(x) strcat(fld, "/", x.name), files, "UniformOutput", false)(3:end);
end
# get_resamples("/home/arthur/tmp/samples", 5000, 1)
