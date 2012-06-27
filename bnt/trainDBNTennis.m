function trainedBnet = trainDBNTennis(bnet,iter=10)

cases = cell(1,1); % Setup cases structure for a single test case only.

N = bnet.nnodes_per_slice; % Number of nodes per slice.
M =3; % Number of time slices.

cases{1} = cell(N,M);
cases{1}(4,1) = 1;
cases{1}(6,2) = 1;

engine = jtree_dbn_inf_engine(bnet);

[trainedBnet, LLtrace] = learn_params_dbn_em(engine,cases,'max_iter',iter);
end