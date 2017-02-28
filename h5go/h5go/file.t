function readFile(filename)
    var pa=strcat(path,filename)
    return filereadex(pa)
end

function writeCode(code,filename)
    filename=strcat(makepath,filename)
    var hand=filecreate(filename,"rw")
    filewrite(hand,code)
    fileclose(hand)
end