function Log(leve,str)
    global level;
    global fid;
    if level <= leve     
        fprintf(fid,'%s',str);
    end
end