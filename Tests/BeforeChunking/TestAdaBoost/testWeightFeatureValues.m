nFeatures = 100000;
nExamples = 10;
A = rand(nFeatures,nExamples);
Weights=ones(1,nExamples)*(1/nExamples);
B=A;
tic
for i=1:nExamples
    B(:,i) = A(:,i).*Weights(i);
end
toc

A = rand(nExamples,nFeatures);
D=A;
tic
for i=1:nExamples
    D(i,:) = A(i,:).*Weights(i);
end
toc

% tic
% DiagWeights = diag(Weights);
% C = DiagWeights*A;
% toc

% if isequal(B,C)
%     ' B, C equal'
% else
%     'B, C not equal'
% end