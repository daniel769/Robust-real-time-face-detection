counter = 0
for i=1:numel(ImageResults)
counter = counter + size(ImageResults(i).DecAmount,2);
end

for i=1:numel(ImageResults)
if numel(ImageResults(i).DecAmount) == 0
    disp(ImageResults(i).name)
end
end