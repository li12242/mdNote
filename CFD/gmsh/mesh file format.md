#gmsh 网格文件格式


```
$MeshFormat
2.2 0 8
$EndMeshFormat
```

节点信息
```
$Nodes
184         - 总节点个数
1 0 0 0     - 节点序号 x y z（坐标值）
2 0 200 0
...
$EndNodes
```

单元信息
```
$Elements
366                 - 总单元个数
1 1 2 18 1 2 13     - 单元序号 单元类型 保留字 physical值 physical元素序号 （单元包含节点号）
2 1 2 18 1 13 14
...
$EndElements
```

