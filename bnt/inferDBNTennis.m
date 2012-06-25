function marginals = inferDBNTennis(bnet) 

evidence = cell(6,3);
evidence(4,1) = 1;
evidence(6,2) = 1;

engine = jtree_dbn_inf_engine(bnet);

[engine, ll] = enter_evidence(engine, evidence);

nodes = 5;
t = 3;
marginals = marginal_nodes(engine, nodes, t);
end