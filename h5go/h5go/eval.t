var stack //状态栈

function getNowStack(layer=1)
    if(arraysize(stack)==0)
        return ""
    end    
    return stack[arraysize(stack)-layer]
end

function popStack()
    var len=arraysize(stack)
    var newstack=array()
    for(var i = 0; i < len-1; i++)
        arraypush(newstack,stack[i])
    end
    arrayclear(stack)
    stack=newstack
end

function pushStack(blockName)
    arraypush(stack,blockName)
end

function initStack()
    arrayclear(stack)
    stack=array()
    //初始化一堆零散状态
    initnavbarState()
    initContainer_sidebarState()
    initcontainer_blockState()
end

function getToken(str,terminatorList)
    var length=strlen(str)
    var newstr=""
    
    for(var i = 0; i <= length; i++)
        var char=strleft(str,1)
        
        for(var j = 0; j < arraysize(terminatorList); j++) //检查是否是某个终结符
            if(char==terminatorList[j])
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
    mistake("区块名不存在")
    return ""
end

function tranBlockEnd(blockName)
    //本来就没有结束代码的
    //因为集成在一个文件所以没有结束代码的
    if(blockName=="sidebar")
        var ret=readFile("templet\\container\\sidebar.html")
        ret=strreplace(ret,"_内容",container_sidebarReplace["_内容"])
        initContainer_sidebarState()
        return ret
    end
    if(blockName=="block")
        var ret=readFile("templet\\container\\block.html")
        ret=strreplace(ret,"_内容",container_blockReplace["_内容"])
        initcontainer_blockState()
        return ret
    end
    //有结束代码的
    if(blockName=="navbar")
        var ret=""
        if(haveNavbarMainentry)
            ret=readFile("templet\\navbar\\header.html")
            ret=strreplace(ret,"_mainentry",navbarReplace["_mainentry"])
        end
        ret=strcat(ret,readFile("templet\\navbar\\print.html"))
        ret=strreplace(ret,"_前内容",navbarReplace["_前内容"])
        ret=strreplace(ret,"_后内容",navbarReplace["_后内容"])
        initnavbarState()
        return strcat(ret,readFile("templet\\navbar\\end.html"))
    end
    if(blockName=="container")
        return readFile("templet\\container\\end.html")
    end
    //什么都不是
    mistake("区块名不存在")
    return ""
end

function isSingleLine(blockName)
    var allSingleLine=array("title","mainentry","entry","rightentry","p","button","disbutton","head")
    
    for(var i = 0; i < arraysize(allSingleLine); i++)
        if(allSingleLine[i]==blockName)
            return true
        end
    end
    return false
end

//一些由于没涉及好搞的零散状态
//navbar
var navbarReplace //list
var haveNavbarMainentry
function initnavbarState()
    haveNavbarMainentry=false
    arrayclear(navbarReplace)
    navbarReplace=array()
    arraypush(navbarReplace,"","_前内容")
    arraypush(navbarReplace,"","_后内容")
end
//container_sidebar
var container_sidebarReplace //list
function initContainer_sidebarState()
    arrayclear(container_sidebarReplace)
    container_sidebarReplace=array()
    arraypush(container_sidebarReplace,"","_内容")
end
//container_block
var container_blockReplace //list
function initcontainer_blockState()
    arrayclear(container_blockReplace)
    container_blockReplace=array()
    arraypush(container_blockReplace,"","_内容") 
end
//没涉及好搞的零散状态结束
function tranSingleLineHead(blockName,parList)
    var nowStack=getNowStack()
    
    if(nowStack=="")
        if(blockName=="head")
            var ret=readFile("templet\\head.html")
            ret=strreplace(ret,"页面名",parList["title"])
            return ret
        end
        
        mistake("父区块不支持这个子区块")
        return ""
    end
    
    if(nowStack=="navbar")
        
        if(blockName=="mainentry")
            if(haveNavbarMainentry)
                mistake("父区块不支持多于一个的mainentry子区块")
                return ""
            end
            haveNavbarMainentry=true
            var _mainentry=filereadini("navbar","_mainentry",codeinipath)
            _mainentry=strreplace(_mainentry,"链接",parList["herf"])
            _mainentry=strreplace(_mainentry,"文本",parList["content"])
            arraypush(navbarReplace,_mainentry,"_mainentry")
            return ""
        end
        
        if(blockName=="entry")
            var entry=filereadini("navbar","entry",codeinipath)
            entry=strreplace(entry,"链接",parList["herf"])
            entry=strreplace(entry,"文本",parList["content"])
            navbarReplace["_前内容"]=strcat(navbarReplace["_前内容"],entry)
            return ""
        end
        
        if(blockName=="rightentry")
            var rightentry=filereadini("navbar","entry",codeinipath)
            rightentry=strreplace(rightentry,"链接",parList["herf"])
            rightentry=strreplace(rightentry,"文本",parList["content"])
            navbarReplace["_后内容"]=strcat(navbarReplace["_后内容"],rightentry)
            return ""
        end
        
        mistake("父区块不支持这个子区块")
        return ""
    end
    
    if(nowStack=="sidebar")
        
        if(blockName=="mainentry")
            var mainentry=filereadini("container_sidebar","mainentry",codeinipath)
            mainentry=strreplace(mainentry,"文本",parList["content"])
            container_sidebarReplace["_内容"]=strcat(container_sidebarReplace["_内容"],mainentry)
            return ""
        end
        
        if(blockName=="entry")
            var entry=filereadini("container_sidebar","entry",codeinipath)
            entry=strreplace(entry,"链接",parList["herf"])
            entry=strreplace(entry,"文本",parList["content"])
            container_sidebarReplace["_内容"]=strcat(container_sidebarReplace["_内容"],entry)
            return ""
        end
        
        mistake("父区块不支持这个子区块")
        return ""
    end
    
    if(nowStack=="block")
        
        if(blockName=="title")
            var title=filereadini("container_block","title",codeinipath)
            title=strreplace(title,"文本",parList["content"])
            container_blockReplace["_内容"]=strcat(container_blockReplace["_内容"],title)
            return ""
        end
        
        if(blockName=="p")
            var p=filereadini("container_block","p",codeinipath)
            p=strreplace(p,"文本",parList["content"])
            container_blockReplace["_内容"]=strcat(container_blockReplace["_内容"],p)
            return ""
        end
        
        if(blockName=="disbutton")
            var disbutton=filereadini("container_block","disbutton",codeinipath)
            disbutton=strreplace(disbutton,"文本",parList["content"])
            container_blockReplace["_内容"]=strcat(container_blockReplace["_内容"],disbutton)
            return ""
        end
        
        if(blockName=="button")
            var button=filereadini("container_block","button",codeinipath)
            button=strreplace(button,"链接",parList["herf"])
            button=strreplace(button,"文本",parList["content"])
            container_blockReplace["_内容"]=strcat(container_blockReplace["_内容"],button)
            return ""
        end
        
        mistake("父区块不支持这个子区块")
        return ""
    end
    
    //什么都不是
    mistake("区块名不存在")
    return ""
end

function tranOtherContent(str)
    var nowStack=getNowStack(2)
    
    if(nowStack=="")
        return str
    end
    
    if(nowStack=="block")
        container_blockReplace["_内容"]=strcat(container_blockReplace["_内容"],str)
        return ""
    end
    
    mistake("父区块不支持这个子区块")
    return ""
end