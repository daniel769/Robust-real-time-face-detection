function InitLog(leve,path)
    global fid;
    global level;
    level = leve;
    mkdir(path);
    fid = fopen([path 'log' datestr(now, 'mmmm dd, yyyy HH,MM,SS.FFF') '.txt'],'w+');
end