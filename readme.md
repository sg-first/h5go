H5go
========
H5go is a XML style markup language. It package some of the effects of bootstrap and jQuery as labels. Then you can easily use these effects directly without writing complex HTML and JS code. After compiling, the H5go code will be generated as an executable HTML code and package all the dependables.

labels
-------------
### head
����ҳ��������Ϣ������
* title:��ҳ����
`<head title=��ҳ����>`

### navbar
���˵��������ݵ�����
#### mainentry
�趨��������ǰ�˵���Ŀѡ��
* herf:���ӵ��ĵ�ַ
* content:��ʾ������
#### entry
�ڽ���ǰ�˵�ѡ����趨���
* herf:���ӵ��ĵ�ַ
* content:��ʾ������
#### rightentry
�趨���������Ҷ˵�ѡ��
* herf:���ӵ��ĵ�ַ
* content:��ʾ������
```
<navbar>
	<mainentry herf=index.htm content=��ҳ>
	<entry href=1.htm content=��Ŀ1>
	<rightentry href=2.htm content=��Ŀ2>
</navbar>
```

### container
��ҳ�в�������

#### sidebar
��˵��������ݵ�����
##### mainentry
�趨��������˵���Ŀѡ��
* herf:���ӵ��ĵ�ַ
* content:��ʾ������
##### entry
�ڽ���ǰ�˵�ѡ����趨���
* herf:���ӵ��ĵ�ַ
* content:��ʾ������
```
<sidebar>
	<mainentry herf=index.htm content=��ҳ>
	<entry herf=1.htm content=��Ŀ1>
	<entry herf=2.htm content=��Ŀ2>
</sidebar>
```

#### block
��ҳ�е����ݿ飬���趨���
##### title
���������
* content:��������
```
<block>
	<title content=��ͨ��>
	<p content=һ����ͨ�Ļ�>
	<button herf=but.htm content=���԰�ť>
	<disbutton herf=but.htm content=�����õĲ��԰�ť>
</block>
```

#### p
���ģ�����container�ڣ���other��������㼶ʹ�ã�
* content:��������
`<p content=һ����ͨ�Ļ�>`

#### button
���õİ�ť������container�ڣ���other��������㼶ʹ�ã�
* content:��ť����
* herf:���ӵ��ĵ�ַ
`<button herf=but.htm content=���԰�ť>`

#### disbutton
�����õİ�ť������container�ڣ���other��������㼶ʹ�ã�
* content:��ť����
`<disbutton content=�����õĲ��԰�ť>`

#### other
Ƕ���HTML����
##### js
��HTML������Ƕ���js����
```
<other>
	<h4>�������дHTML</h4>
	<js>
		var a=1;
	</js>
</other>
```