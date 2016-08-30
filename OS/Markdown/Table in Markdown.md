这个算是Markdown的扩展语法 https://github.com/trentm/python-markdown2/wiki/wiki-tables

使用很简单

| *Year* | *Temperature (low)* | *Temperature (high)* |
| 1900 | -10 | 25 |
| 1910 | -15 | 30 |
| 1920 | -10 | 32 |

生成代码如下

```
<table>
<tbody>
<tr><td><em>Year</em></td><td><em>Temperature (low)</em></td><td><em>Temperature (high)</em></td></tr>
<tr><td>1900</td><td>-10</td><td>25</td></tr>
<tr><td>1910</td><td>-15</td><td>30</td></tr>
<tr><td>1920</td><td>-10</td><td>32</td></tr>
</tbody>
</table>
```

显示效果

<table>
<tbody>
<tr><td><em>Year</em></td><td><em>Temperature (low)</em></td><td><em>Temperature (high)</em></td></tr>
<tr><td>1900</td><td>-10</td><td>25</td></tr>
<tr><td>1910</td><td>-15</td><td>30</td></tr>
<tr><td>1920</td><td>-10</td><td>32</td></tr>
</tbody>
</table>


目前sublime text 2的 Markdown to Clipboard 插件支持

Reference:

[1] http://lutaf.com/155.htm