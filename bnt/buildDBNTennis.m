function bnet = buildDBNTennis()

N = 3; % Number of tennis players
G = size(nchoosek([1:N],2),1); % Number of tennis matches in a single time slice.

intra = zeros(N+G);
intra(1,4) = 1; % node 1 in slice t connects to node 2 in slice t
intra(2,4) = 1;
intra(1,5) = 1;
intra(3,5) = 1;
intra(2,6) = 1;
intra(3,6) = 1;

inter = zeros(N+G);
inter(1,1) = 1; % node 1 in slice t-1 connects to node 1 in slice t
inter(2,2) = 1;
inter(3,3) = 1;

Q = 3; % num hidden states
O = 2; % num observable symbols

ns = [repmat(Q,1,N) repmat(O,1,G)]

eclass1 = [1 1 1 2 2 2];
eclass2 = [3 3 3 2 2 2];
eclass = [eclass1 eclass2];

bnet = mk_dbn(intra, inter, ns,'eclass1', eclass1, 'eclass2', eclass2);
%bnet = mk_dbn(intra, inter, ns);
prior0 = [1/3 1/3 1/3];
transmat0 = [0.98 0.01 0.01 ; 0.01 0.98 0.01 ;0.01 0.02 0.97];
obsmat0 = [0.5 2/3 0.75 1/3 0.5 0.6 0.25 0.4 0.5 0.5 1/3 0.25 2/3 0.5 0.4 0.75 0.6 0.5];
bnet.CPD{1} = tabular_CPD(bnet, 1, prior0);
bnet.CPD{2} = tabular_CPD(bnet, 4, obsmat0);
bnet.CPD{3} = tabular_CPD(bnet, 7, transmat0);

end