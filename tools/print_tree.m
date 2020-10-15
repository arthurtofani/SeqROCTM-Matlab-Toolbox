function [ret] = print_tree(tree)
  arr = zeros(1, numel(tree));
  for i = 1 : numel(tree)
    node = tree{i};
    nodestr = cellstr(node + '0')(1, 1){1};
    printf(nodestr);
    printf(' ');
  end
  printf('\n')
end
