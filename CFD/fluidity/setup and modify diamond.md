#diamond

###install ets packages

参考 <http://code.enthought.com/source/>

下载python脚本 ets.py 
from <https://raw.githubusercontent.com/enthought/ets/master/ets.py>

可以查看脚本包含命令
    
    python ets.py -h

**clone ets 各个packages**
```
python ets.py clone
```

此时文件夹内包含文件如下
```
-rw-r--r--   1 mac  staff  4829  6  3 00:58 ets.py
drwxr-xr-x  20 mac  staff   680  6  3 01:16 apptools
drwxr-xr-x  14 mac  staff   476  6  3 00:59 casuarius
drwxr-xr-x  17 mac  staff   578  6  3 01:10 chaco
drwxr-xr-x  19 mac  staff   646  6  3 01:16 codetools
drwxr-xr-x  27 mac  staff   918  6  3 01:16 enable
drwxr-xr-x  17 mac  staff   578  6  3 01:15 encore
drwxr-xr-x  15 mac  staff   510  6  3 01:09 envisage
drwxr-xr-x   8 mac  staff   272  6  3 01:14 graphcanvas
drwxr-xr-x  31 mac  staff  1054  6  3 01:22 mayavi
drwxr-xr-x  20 mac  staff   680  6  3 01:16 pyface
drwxr-xr-x  16 mac  staff   544  6  3 01:16 scimath
drwxr-xr-x  21 mac  staff   714  6  3 01:15 traits
drwxr-xr-x  24 mac  staff   816  6  3 01:16 traitsui
```

**install packages**
diamond只需要安装三个库mayavi、traits、traitsui，进到各个文件夹内使用
```
sudo python setup.py install
```

###modified diamond

由于各个packages是单独安装，与diamond默认设置不符，需要修改一些文件调用库函数命令。

1. <\fluidity_install_path>/lib/python2.7/site-packages/diamond/triangle_reader.py
```
# Enthought library imports.
from traits.api import Instance, String, List, Int
from traitsui.api import View, Item
from tvtk.api import tvtk

# Local imports.
from mayavi.core.file_data_source import FileDataSource
from mayavi.core.pipeline_info import PipelineInfo
from mayavi.core.trait_defs import DEnum
from os import path
from numpy import array, append, fromstring
from re import compile, MULTILINE
```

2. <\fluidity_install_path>/share/diamond/plugins/flml/show_triangle_mesh.py
```
from diamond.plugins import register_plugin, cb_decorator
from lxml import etree

# For now, I've put TriangleReader in diamond
from diamond.triangle_reader import TriangleReader

from mayavi.core.engine import Engine # Error occurs when this is imported
from mayavi.modules.api import Surface
from mayavi.core.ui.engine_view import EngineView
```
