function [NegsWindows] = createNegWindows(Image,FacesWinIdx)
    NegsWindows = cell(1,size(FacesWinIdx,2));
    for i=1:size(FacesWinIdx,2)
        upX = FacesWinIdx(1,i);
        downX = FacesWinIdx(3,i);
        leftY = FacesWinIdx(2,i);
        rightY = FacesWinIdx(4,i);
        NegsWindows{i} = Image(upX:downX,leftY:rightY);
    end
end