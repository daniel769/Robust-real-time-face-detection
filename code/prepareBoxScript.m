amount = 100000;
fnPosSet = 'posSetMerged.mat';
fnNegSet = 'negSetMerged.mat';
PreProcess = 0;

dir_name = 'C:\M.Sc\CV\faces\merged\face';
[faces,PosSet] = prepareBox(dir_name, amount,PreProcess);
dir_name = 'C:\M.Sc\CV\faces\merged\non-face';
[nonFaces,NegSet] = prepareBox(dir_name, amount,PreProcess);
save('posSetMerged.mat','PosSet','faces');
save('negSetMerged.mat','NegSet','nonFaces');

