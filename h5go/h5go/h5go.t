var makepath
var path
var inipath
var isError

function output(str)
    str=strcat(str,"\r\n")
    editsettext("处理输出",strcat(editgettext("处理输出"),str))
end

function mistake(str)
    str=strcat("-----error: ",str)
    output(strcat(str,"-----"))
    isError=true
end

function 热键0_热键()
    isError=false
    output("-----start: 开始构建-----")
    output("初始化栈状态")
    initStack()
    output("创建构建文件夹")
    makepath=strcat(path,"build")
    folderdelete(makepath)
    foldercreate(makepath)
    makepath=strcat(makepath,"\\")
    
    var buildtxt=readFile("build.txt")
    var allcodepath
    strsplit(buildtxt,",",allcodepath) //获得所有等构建h5go文件
    
    for(var i = 0; i < arraysize(allcodepath); i++)
        PCodeFile(allcodepath[i]) //本函数直接承包从读文件到写文件
    end
end

function 构建_点击()
    热键0_热键()
end

function h5go_初始化()
    path=sysgetcurrentpath()
    inipath=strcat(path,"build.txt")
end

function PCodeFile(codepath)
    output(strcat("预处理文件",codepath))
    var newcode=""
    var code=filereadex(strcat(path,codepath))
    var ary
    
    strsplit(code,"\r\n",ary)
    for(var i = 0; i < arraysize(ary); i++)
        newcode=strcat(newcode,prepro(ary[i]))
        newcode=strcat(newcode,"\r\n")
        if(isError)
            return
        end
    end
end


function prepro(str)
    str=deleteSpace(str)
    str=removeChar(str," ") //去空格
    
    if(getNowStack()=="other") //在other区块内,写的是HTML代码,没有特殊格式限制
        if(str=="</other>") //碰到这个退出即可
            popStack()
            return ""
        end
        return str //不是那个就是HTML代码,原样返回即可
    end
    
    //不在other区块内,都是一样的格式
    //检验开头是否是<
    if(isChar(str,"<")==false) 
        mistake("无法识别的语句开头")
        return ""
    end
    str=strcut(str,1,true) //去掉<
    str=removeChar(str," ") //每结束一部分解析都必须去空格
    
    //正式开始解析内容
    if(isChar(str,"/"))
        //区块结尾
        //获取区块名
		var blockName=getblockName(str)
		if(isError) //解析错误(没有终结符)直接停止
			return ""
		end
        str=strcut(str,strlen(blockName)) //消耗字符
        str=removeChar(str," ") //每结束一部分解析都必须去空格
        if(isChar(str,">")==false||strlen(str)!=strlen(">")) //获取到区块名之后,下一个字符必须是>
            mistake("区块尾不能含有除区块名外其它的元素")
            return ""
        end
        //检查与区块头是否对应
        if(getNowStack()!=blockName)
            mistake("区块头与区块结尾不对应")
            return ""
        end
        popStack()
        return tranBlockEnd(blockName)
    else
        //区块开头
		//获取区块名
		var blockName=getblockName(str)
		if(isError) //解析错误(没有终结符)直接停止
			return ""
		end
		pushStack(blockName)
		str=strcut(str,strlen(blockName)) //消耗字符
		str=removeChar(str," ") //每结束一部分解析都必须去空格
        
		
		if(isChar(str,">")) //检查该区块是否没写参数
            //没写参数
			if(strlen(str)!=strlen(">")) //确认>后面没有字符
				mistake("区块头结束后必须换行")
				return ""
			end
			return tranVoidBlockHead(blockName)
		end
        
        //写了参数
        var parList
        
        while(1) //循环获取所有的参数名-值对
			//开始获取参数名
			var parName=getparName(str)
			if(isError) //解析错误(没有终结符)直接停止
				return ""
			end
			str=strcut(str,strlen(parName)) //消耗字符
			str=removeChar(str," ") //每结束一部分解析都必须去空格
			if(isChar(str,"=")==false)
				mistake("每个区块参数必须有一个值")
				return ""
			end
			str=strcut(str,1,true) //去掉=
			str=removeChar(str," ") //每结束一部分解析都必须去空格
			//开始获取参数值
			var parVal=getparVal(str)
			if(isError) //解析错误(没有终结符)直接停止
				return ""
			end
			str=strcut(str,strlen(parVal)) //消耗字符
			str=removeChar(str," ") //每结束一部分解析都必须去空格
			arraypush(parList,parName,parVal)
            
            if(isChar(str,">"))
                break
            end
            if(strlen(str)==0)
                mistake("区块头必须由>作为结尾")
                break
            end
        end
        
        if(isError) //解析错误(获取参数过程中耗尽所有字符)直接停止
			return ""
		end
        if(strlen(str)!=strlen(">")) //确认>后面没有字符
			mistake("区块头结束后必须换行")
			return ""
		end
        
    end
end
