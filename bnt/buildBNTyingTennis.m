% This function creates unrolled dynamic bayesian network for tennis ratings. 
% Parameter tying is configured, but bnt tool doesn't support learning unrolled bayesian networks with parameter tying using EM algorithm.
function bnet  = buildBNTyingTennis()

dag = zeros(12,12);
R1_0=1;R2_0=2;R3_0=3;R1_1=4;R2_1=5;R3_1=6;R1_2=7;R2_2=8;R3_2=9; % tennis ratings (hidden variables)
S0_R1_R2=10;S1_R2_R3=11;S2_R1_R3=12; % tennis match results (observed variables). 1 - won, 2 - lost

dag(R1_0,[R1_1,S0_R1_R2]) = 1;
dag(R2_0,[R2_1,S0_R1_R2]) = 1;
dag(R3_0,R3_1) = 1;
dag(R1_1,R1_2)=1;
dag(R2_1,[R2_2,S1_R2_R3])=1;
dag(R3_1,[R3_2,S1_R2_R3])=1;
dag(R1_2,S2_R1_R3)=1;
dag(R3_2,S2_R1_R3)=1;

nodeSizes=[3,3,3,3,3,3,3,3,3,2,2,2];
variableNames = {'R1_0','R2_0','R3_0','R1_1','R2_1','R3_1','R1_2','R2_2','R3_2','S0_R1_R2','S1_R2_R3','S2_R1_R3'};

priorNodes = [R1_0 R2_0 R3_0];
hiddenNodes = [R1_1 R2_1 R3_1 R1_2 R2_2 R3_2];
observedNodes = [S0_R1_R2 S1_R2_R3 S2_R1_R3];
priorClass=1; hiddenClass=2; observedClass=3;
eClass(priorNodes) = priorClass;
eClass(hiddenNodes) = hiddenClass;
eClass(observedNodes) = observedClass;

bnet = mk_bnet(dag,nodeSizes,'equiv_class', eClass,'names', variableNames);

bnet.CPD{priorClass} = tabular_CPD(bnet,priorNodes(1),[1/3 1/3 1/3]);
bnet.CPD{hiddenClass} = tabular_CPD(bnet,hiddenNodes(1),[0.98 0.01 0.01 ; 0.01 0.98 0.01 ;0.01 0.02 0.97](:));
bnet.CPD{observedClass} = tabular_CPD(bnet,observedNodes(1),[0.5 2/3 0.75 1/3 0.5 0.6 0.25 0.4 0.5 0.5 1/3 0.25 2/3 0.5 0.4 0.75 0.6 0.5]);

end