H5go
========
H5go is a XML style markup language. It package some of the effects of bootstrap and jQuery as labels. Then you can easily use these effects directly without writing complex HTML and JS code. After compiling, the H5go code will be generated as an executable HTML code and package all the dependables.

labels
-------------
### head
关于页面整体信息的设置
* title:主页标题
```
<head title=主页标题>
```

### navbar
顶端导航栏内容的设置
#### mainentry
设定导航栏最前端的醒目选项
* herf:链接到的地址
* content:显示的文字
#### entry
邻接最前端的选项，可设定多个
* herf:链接到的地址
* content:显示的文字
#### rightentry
设定导航栏最右端的选项
* herf:链接到的地址
* content:显示的文字
```
<navbar>
	<mainentry herf=index.htm content=主页>
	<entry href=1.htm content=栏目1>
	<rightentry href=2.htm content=栏目2>
</navbar>
```

### container
网页中部的内容

#### sidebar
左端导航栏内容的设置
##### mainentry
设定导航栏最顶端的醒目选项
* herf:链接到的地址
* content:显示的文字
##### entry
邻接最前端的选项，可设定多个
* herf:链接到的地址
* content:显示的文字
```
<sidebar>
	<mainentry herf=index.htm content=主页>
	<entry herf=1.htm content=栏目1>
	<entry herf=2.htm content=栏目2>
</sidebar>
```

#### block
网页中的内容块，可设定多个
##### title
块的主标题
* content:标题内容
```
<block>
	<title content=普通块>
	<p content=一句普通的话>
	<button herf=but.htm content=测试按钮>
	<disbutton herf=but.htm content=不可用的测试按钮>
</block>
```

#### p
正文（可在container内，除other块外任意层级使用）
* content:正文内容
```
<p content=一句普通的话>
```

#### button
可用的按钮（可在container内，除other块外任意层级使用）
* content:按钮标题
* herf:链接到的地址
```
<button herf=but.htm content=测试按钮>
```

#### disbutton
不可用的按钮（可在container内，除other块外任意层级使用）
* content:按钮标题
```
<disbutton content=不可用的测试按钮>
```

#### other
嵌入的HTML代码
```
<other>
	<h4>这里可以写HTML</h4>
	<script>
		var a=1;
	</script>
</other>
```
