#Publish Matlab Code

一直在找类似doxygen一样将程序注释发表成手册的方法，现在发现，MATLAB的publish功能自己就能做到，这里介绍下Matlab的publish相关功能。


| 输出格式 | 示例 |
| --- | --- |
| 段落标题 | `%% SECTION TITLE`
| 文字格式 | `% _斜体_ ` `% *加粗*`
| 编号 | `% * 加点编号` `% # 数字编号` 
| 代码 | `%   三个空格`
| 图片 | `% <<filename.png>>`
| LaTeX 公式 | `% $内嵌公式$` `% $$ 块公式 $$`
| 超链接 | `% <http://www.google.com.hk>`

**注意**

1. 文本必须以段落标题起始
2. 有格式的问题前必须要空行
