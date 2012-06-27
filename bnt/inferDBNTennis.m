function marginals = inferDBNTennis(bnet) 

N = bnet.nnodes_per_slice; % Number of nodes per slice.
M =3; % Number of time slices.

evidence = cell(N,M);
evidence(4,1) = 1;
evidence(6,2) = 1;

engine = jtree_dbn_inf_engine(bnet);

[engine, ll] = enter_evidence(engine, evidence);

nodes = 5;
t = 3;
marginals = marginal_nodes(engine, nodes, t);
end