function [ret] = print_tree(tree)
  ret = ""
  arr = zeros(1, numel(tree));
  for i = 1 : numel(tree)
    node = tree{i};    
    if isscalar(node)
      nodestr = num2str(node);
    else
      nodestr = cellstr(node + '0')(1, 1){1};
    endif
    
    ret = strcat(ret, nodestr);
    ret = strcat(ret, "-");
    #printf(nodestr);
    #printf(' ');
  end
  ret = strrep(ret, "-", " ");
  #printf('\n')
end
