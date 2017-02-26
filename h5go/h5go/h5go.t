var makepath
var path

function output(str)
    str=strcat(str,"\r\n")
    editsettext("处理输出",strcat(editgettext("处理输出"),str))
end

function 热键0_热键()
    output("-----start: 开始构建-----")
    output("创建构建文件夹")
    folderdelete(makepath)
    foldercreate(makepath)
    makepath=strcat(makepath,"\\")
    
end

function 构建_点击()
    热键0_热键()
end


function h5go_初始化()
    path=sysgetcurrentpath()
    makepath=strcat(path,"build")
end
