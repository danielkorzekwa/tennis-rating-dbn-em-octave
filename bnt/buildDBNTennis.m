% This function creates 2TBN network for tennis ratings.
%
% @param N Number of tennis players
%
%
function bnet = buildDBNTennis(N=3)

matches = nchoosek([1:N],2);
G = size(matches,1); % Number of tennis matches for a single time slice.

intra = zeros(N+G);
for i=1:size(matches,1)
intra(matches(i,1),N+i)=1; % Connect hidden node with a corresponding observed node;
intra(matches(i,2),N+i)=1;
end

inter = zeros(N+G);
for i=1:N
  inter(i,i) = 1; % Node 1 in slice t-1 connects to node 1 in slice t.
end

Q = 3; % num hidden states, rating values
O = 2; % num observable symbols, 1 - won, 2 - lost

ns = [repmat(Q,1,N) repmat(O,1,G)]; % Sizes of variables in a slice t.

eclass1 = [repmat(1,1,N) repmat(2,1,G)]; % Parameter tying for slice t 1.
eclass2 = [repmat(3,1,N) repmat(2,1,G)]; % Parameter tying for slice t 2.
eclass = [eclass1 eclass2];

bnet = mk_dbn(intra, inter, ns,'eclass1', eclass1, 'eclass2', eclass2);
%bnet = mk_dbn(intra, inter, ns);
prior0 = [0.2 0.5 0.3];
transmat0 = [0.98 0.01 0.01 ; 0.01 0.98 0.01 ;0.01 0.02 0.97];
obsmat0 = [0.5 2/3 0.75 1/3 0.5 0.6 0.25 0.4 0.5 0.5 1/3 0.25 2/3 0.5 0.4 0.75 0.6 0.5];
bnet.CPD{1} = tabular_CPD(bnet, 1, prior0);
bnet.CPD{2} = tabular_CPD(bnet, N+1, obsmat0);
bnet.CPD{3} = tabular_CPD(bnet, N+G+1, transmat0);

end