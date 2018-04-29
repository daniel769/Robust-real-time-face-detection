function box = createBox(nExamples,windowSize)
    box = zeros(windowSize,windowSize,nExamples);
    box(2:windowSize,2:windowSize,:) = round(rand(windowSize-1,windowSize-1,nExamples)*10);
end