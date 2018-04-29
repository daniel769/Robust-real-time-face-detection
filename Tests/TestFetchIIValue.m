function TestFetchIIValue
Set = rand(3,3,5);
Set(2,2,:) = 5;
value = FetchIIValue(5,Set)
end

function value = FetchIIValue(ind,Set)
    [x y] = ind2sub([size(Set,1) size(Set,2)],ind);
    value = reshape(Set(x,y,:),1,size(Set,3));
end