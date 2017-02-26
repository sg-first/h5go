var stack //状态栈
var state //当前语句的解析状态

function getNowStack()
    return stack[arraysize(stack)-1]
end

function popStack()
    arraydeletepos(stack,arraysize(stack)-1)
end

function pushStack(blockName)
    arraypush(stack,blockName)
end

function initStack()
    stack=数组清空()
    state=""
end

function getToken(str,terminatorList)
    var length=strlen(str)
    var newstr=""
    
    for(var i = 0; i <= length; i++)
        var char=strleft(str,1)
        
        for(var i = 0; i < 数组大小(terminatorList); i++) //检查是否是某个终结符
            if(char==terminatorList[i])
				return newstr
			end
        end

        //不是终结符,直接拼接即可
        str=strcut(str,1,true)
        newstr=strcat(newstr,char)
    end
    
    mistake("规约区块名时没有遇到终结符")
    return ""
end

function getblockName(str)
    return getToken(str,array(" ",">"))
end

function getparVal(str)
    return getToken(str,array(" ",">"))
end

function getparName(str)
    return getToken(str,array(" ","="))
end

function tranVoidBlockHead(blockName)
    //本来就没有头代码的
    if(blockName=="other")
        return ""
    end
    //因为集成在一个文件所以没有头代码的
    if(blockName=="sidebar"||blockName=="block")
        return ""
    end
    //有头代码的
    if(blockName=="navbar")
        return readFile("templet\\navbar\\head.html")
    end
    if(blockName=="container")
        return readFile("templet\\container\\head.html")
    end
    //什么都不是
    mistake("区块头存在不存在的无参数区块名")
    return ""
end

function tranBlockEnd(blockName)
    //本来就没有结束代码的
    if(blockName=="other")
        return ""
    end
    //因为集成在一个文件所以没有结束代码的
    if(blockName=="sidebar"||blockName=="block")
        return ""
    end
	//有结束代码的
    if(blockName=="navbar")
        return readFile("templet\\navbar\\end.html")
    end
    if(blockName=="container")
        return readFile("templet\\container\\end.html")
    end
    //什么都不是
    mistake("区块尾存在不存在的区块名")
    return ""
end