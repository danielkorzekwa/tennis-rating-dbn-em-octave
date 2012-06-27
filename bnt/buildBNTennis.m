% This function creates unrolled dynamic bayesian network for tennis ratings. 
% Learing this network with EM algorithm makes no sense as there is no parameter tying configured in this network for prior, transition and emmission probabilities. 
function bnet  = buildBNTennis()

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

bnet = mk_bnet(dag,nodeSizes,'names', variableNames);

priorProb = [1/3 1/3 1/3];
for i=1:3
  bnet.CPD{priorNodes(i)} = tabular_CPD(bnet,priorNodes(i),priorProb);
end

transitionProb = [0.98 0.01 0.01 ; 0.01 0.98 0.01 ;0.01 0.02 0.97];
for i=1:6
  bnet.CPD{hiddenNodes(i)} = tabular_CPD(bnet,hiddenNodes(i),transitionProb(:));
end

emmissionProb = [0.5 2/3 0.75 1/3 0.5 0.6 0.25 0.4 0.5 0.5 1/3 0.25 2/3 0.5 0.4 0.75 0.6 0.5];
for i=1:3
  bnet.CPD{observedNodes(i)} = tabular_CPD(bnet,observedNodes(i),emmissionProb);
end
 
end