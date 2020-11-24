function [tree, idx, V, NODES, STATS] = bic_WCT(X, Alphabet, height, c)
%BIC_WCT Estimate a context tree model from a sequence using the BIC
%        criterion introduced in Csiszar 2005 IEEE Trans. Inf. Theory 
%
% Inputs
%   X           : sequence of symbols taking values in the alphabet
%   Alphabet    : alphabet
%   height      : height of the complete tree
%   c           : penalization constant of the BIC criteria
%
% Outputs
%   tree        : context tree estimated
%   idx         : indexes of the context in the sample X
%   V           : log(V) values for the contexts (see the article)
%   NODES       : nodes of the complete tree that were analised
%   STATS       : the values [Phat, ProdV, V, Xi] for each of the analysed
%                   nodes
%  

%Author : Noslen Hernandez (noslenh@gmail.com), Aline Duarte (alineduarte@usp.br)
%Date   : 10/2020


% set the default value of the penalization constant c to 1 
if ~exist('c', 'var')
    c = 1;
end

% call the function that estimate the tree
[tree, idx, V, NODES, STATS] = get_maximizingTree([], Alphabet, height, [], X, c);

end