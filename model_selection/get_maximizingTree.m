function [F, I, log_V, NODES, STATS] = get_maximizingTree(w, Alphabet, l, ind_father, X, c)
% GET_MAXIMIZINGTREE Recursive function to compute the maximizing tree (see
%                    the definition in the article Csiszar 2005 IEEE Trans.
%                    Inf. Theory)
%
% Inputs
%
%   w           : node
%   Alphabet    : alphabet
%   l           : heigth of the complete tree
%   ind_father  : indexes where the father of the node w appears in the
%                   sequence
%   X           : sequence of symbols
%   c           : penalization constant in the bic criteria
%
% Outputs
%
%   F           : contexts
%   I           : indexes where the contexs appears in the sequence X
%   log_V       : logarithm of V for the contexts (see definition of V in
%                   the article)
%   NODES       : nodes of the complete tree that were analised
%   STATS       : the values [Phat, ProdV, V, Xi] for each of the analysed
%                   nodes
%

%Author : Noslen Hernandez (noslenh@gmail.com), Aline Duarte (alineduarte@usp.br)
%Date   : 10/2020

    % initialize the variables
    F = {};
    I = {};
    log_V = 0;
    NODES = {};
    STATS = [];
    
    % penalization constant (log scale)
    log_flag = c * (1-length(Alphabet))/2 * log(length(X)); 
   
    % get the frequencies N(w) and N(wa)
    lX = length(X);
    if isempty(w)
        % begin counting the contexts/leaves associated to X(1:l). Inside
        % this subsequence nothing is count. This allows that the counting
        % corresponding to the nodes across the tree be consistent.
        ind = (l+1 : lX);
        count = zeros(size(Alphabet));
        for i = l+1 : lX-1
            count(X(i)+1) = count(X(i)+1) + 1;
        end
        printf('ok\n');
    else
        [ind, count] = is_in_sample(w, ind_father, X, Alphabet);
    end
    
    if numel(ind) > 0  %~isempty(ind)
        if length(w) == l % if w is at maximum level 
            % store w as a context
            F = w;
            I = ind;
            % compute log(V)            
            idxp = count > 0;
            log_V = log_flag + sum( count(idxp).* log(count(idxp)/numel(ind)) );
            
            % store the statistics
            NODES = w;
            STATS(1:3) = log_V;
            STATS(4) = 0;
        else
%             % trick to check if the data begins with w (OJO: esto tuve que incluirlo porque da mal el resultado)
%             if isequal(X(1:length(w)), w)&&(numel(ind)>1) 
%                 idx = find(Alphabet == X(length(w)+1));
%                 count(idx) = count(idx) - 1; 
%             end
            % compute log(L) for the tree with w
            idxp = count > 0;
            log_L = log_flag + sum( count(idxp).* log(count(idxp)/sum(count)) );
            
            % compute the sum of log(L) for the sons of w 
            log_prodV = 0;
            for a = Alphabet
                [f, i, logv, nodes, stats] = get_maximizingTree([a w], Alphabet, l, ind, X, c);
                F = [F, f];
                I = [I, i];
               
                log_prodV = log_prodV + logv;
                
                % store the statistics
                NODES = [NODES; nodes];
                STATS = [STATS; stats];
            end
            if isempty(F)||(log_prodV <= log_L) % X = 0, discard previous contexts, new context is w  
                % None of the children is leaf, so w is leaf
                log_V = log_L;
                F = w;
                I = ind;
                
                % store the statistics
                STATS = [STATS; log_L log_prodV log_V 0];
            else
                % X = 1, keep the previous contexts              
                log_V = log_prodV;
                
                % store the statistics
                STATS = [STATS; log_L log_prodV log_V 1];
            end
            % store the statistics
            NODES = [NODES; w];
        end 
    end
end

function [ind, count] = is_in_sample(w, ind_father, X, A)  % if ind = [], w is not in the sample
    
    ind = [];
    count = zeros(size(A));
    for i = 1 : length(ind_father)
        idxson = ind_father(i) - 1;
        if (idxson > 0) && (w(1) == X(idxson))
            % index at which w appears in X (the beginning of w)
            ind = [ind, idxson];
            idx = X(idxson + length(w)) + 1;  %find(A == X(ii + length(w)));
            count(idx) = count(idx) + 1;
        end
    end
end