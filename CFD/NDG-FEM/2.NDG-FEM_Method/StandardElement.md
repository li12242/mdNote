# 标准单元

###基本说明

element_type对象作用是建立标准单元类（standard element），使网格上一般单元的计算可以通过标准单元投影来进行。

标准单元对象通过 face 属性来表述面单元。element_type 对象主要为以下几种，其中 triangle 对象的 face_element 为 line 对象，prism 对象的 face_element 则为 triangle 和 quadrilateral 等等

1. line
2. triangle
3. quadrilateral
4. prism
5. tetrahedron
6. hexahedron

面单元类 （face_element） 与普通单元类最大的区别在于，其不需进行单元边界$\partial \Omega$积分，而其他内容与 element_type 类似，因此可以为 face_element 与 element_type 建立一个公共的超集 base_element_type。

###相关类

base_element_type 类主要属性

```Matlab
    properties(SetAccess=public)
        nDim
        nDegree
        nVertice    % vertices of element, i.e. line=2, triangle=3
        nameStr     % element name
    end %properties

    properties(SetAccess=protected)
        LocalCoord      % local coordinate of nodes
        nNode           % number of local node, defined by degree
        MassMatrix      % mass matrix of the standard element
    end %properties
```

face_element_type 与 base_element_type 完全相同。

element_type 类特殊属性

```Matlab
    properties(SetAccess=protected)
        face            % face element object
        nFace           % face number
        DifferenceMatrix      % partical difference matrix
    end % properties procted
    properties(SetAccess=private)
        FNNtoENN    % Face Node Number To Element Node Number
        FNNtoFENN   % Face Node Number To Face Element Node Number
        EdgeMassMatrix        % edge mass matrix $$\oint_{\partial \Omega} l_i l_{f_j} ds$$
    end %properties private
```

###类主要方法

构造函数参数采用与相应关键字对应的输入格式，避免参数过多产生错误，但是关键字名称一定要保证正确。

```Matlab
degree = 5;
shape = element_type('dim', 2, 'vertice', 3, 'degree', degree, 'name', 'triangle');
```

###单元对象包含序列

| 单元内编号集 | size  | abbreviation |
| --| --| --|
| element node numbering    | obj.nNode             | ENN |
| face node numbering       | obj.nface x obj.nNode     | FNN |
| face element node numbering   | obj.face.nNode        | FENN |

面单元及其属性 face 所表示的面单元主要有
