function value = FetchIIValue(ind,Set)
    [x y] = ind2sub([size(Set,1) size(Set,2)],ind);
    value = reshape(Set(x,y,:),1,size(Set,3));
end