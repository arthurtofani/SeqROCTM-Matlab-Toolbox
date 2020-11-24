function [ret] = print_tree(tree)
  arr = zeros(1, numel(tree));
  for i = 1 : numel(tree)
    node = tree{i};    
    if isscalar(node)
      nodestr = num2str(node)
    else
      nodestr = cellstr(node + '0')(1, 1){1};
    endif
    
    printf(nodestr);
    printf(' ');
  end
  printf('\n')
end
