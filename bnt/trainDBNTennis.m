function trainedBnet = trainDBNTennis(bnet,iter=10)

cases = cell(1,1);
cases{1} = cell(6,3);
cases{1}(4,1) = 1;
cases{1}(6,2) = 1;

engine = jtree_dbn_inf_engine(bnet);

[trainedBnet, LLtrace] = learn_params_dbn_em(engine,cases,'max_iter',iter);
end