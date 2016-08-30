# femtools guide

## femtools 库数据结构及相关函数

测试程序编译方法

```
cd femtools
make libfemtools
cd tests
make
```

### 1.quad 数据结构

quadrature_type 结构体

### 2.1.element 数据结构

element_type 结构体

### 2.2.related functions and subroutines about element_type

*. element_local_coord_count
*. element_local_coords
*. make_element_shape
*. ele_shape

---

**element_local_coord_count**

返回单元内局部坐标系维度

```
  function element_local_coord_count(element)
    integer :: element_local_coord_count
    type(element_type), intent(in) :: element
```

**element_local_coords**

返回单元内点n的局部坐标

```
  function element_local_coords(n, element)
    integer, intent(in) :: n
    type(element_type), intent(in) :: element
    real, dimension(local_coord_count(element)) :: element_local_coords
```

**make_element_shape**

生成单元数据接口函数

```
  interface make_element_shape
     module procedure make_element_shape_from_element, make_element_shape
  end interface


  function make_element_shape_from_element(model, vertices, dim, degree,&
       & quad, type, constraint_type_choice, stat, quad_s)  result (shape)

    !!< This function enables element shapes to be derived from other
    !!< element shapes by specifying which attributes to change.
    type(element_type) :: shape
    type(element_type), intent(in) :: model
    !! Vertices is the number of vertices of the element, not the number of nodes!
    !! dim may be 1, 2, or 3.
    !! Element constraints
    integer, intent(in), optional :: constraint_type_choice
    !! Degree is the degree of the Lagrange polynomials.
    integer, intent(in), optional :: vertices, dim, degree
    type(quadrature_type), intent(in), target, optional :: quad
    integer, intent(in), optional :: type
    integer, intent(out), optional :: stat
    type(quadrature_type), intent(in), optional, target :: quad_s


  function make_element_shape(vertices, dim, degree, quad, type, stat, quad_s, constraint_type_choice)  result (shape)
    !!< 根据已有单元数据生成新的单元
    !!< Generate the shape functions for an element. The result is a suitable
    !!< element_type.
    !!
    !!< At this stage only Lagrange family polynomial elements are supported.
    type(element_type) :: shape
    !! Vertices is the number of vertices of the element, not the number of nodes!
    !! dim \in [1,2,3] is currently supported.
    !! Degree is the degree of the Lagrange polynomials.
    integer, intent(in) :: vertices, dim, degree
    type(quadrature_type), intent(in), target :: quad
    integer, intent(in), optional :: type
    integer, intent(out), optional :: stat
    integer, intent(in), optional :: constraint_type_choice
    type(quadrature_type), intent(in), optional, target :: quad_s
```

**ele_shape**

返回包含的单元数据结构element_type

```
  interface ele_shape
     module procedure ele_shape_scalar, ele_shape_vector, ele_shape_tensor,&
          & ele_shape_mesh
  end interface

  function ele_shape_mesh(mesh, ele_number) result (ele_shape)

  function ele_shape_scalar(field, ele_number) result (ele_shape)
    type(scalar_field),intent(in), target :: field

  function ele_shape_vector(field, ele_number) result (ele_shape)
    type(vector_field),intent(in), target :: field

  function ele_shape_tensor(field, ele_number) result (ele_shape)
    type(tensor_field),intent(in), target :: field
```

###3.1.mesh 数据结构

mesh_type 结构体

**mesh_type中只有网格节点拓扑关系ndglno，没有网格节点坐标数据**

```
  type mesh_type
     !!< Mesh information for (among other things) fields.
     integer, dimension(:), pointer :: ndglno
     !! Flag for whether ndglno is allocated
     logical :: wrapped=.true.
     type(element_type) :: shape
     integer :: elements
     integer :: nodes
     character(len=FIELD_NAME_LEN) :: name
     !! path to options in the options tree
#ifdef DDEBUG
     character(len=OPTION_PATH_LEN) :: option_path="/uninitialised_path/"
#else
     character(len=OPTION_PATH_LEN) :: option_path
#endif
     !! Degree of continuity of the field. 0 is for the conventional C0
     !! discretisation. -1 for DG.
     integer :: continuity=0
     !! Reference count for mesh
     type(refcount_type), pointer :: refcount=>null()
     !! Mesh face information for those meshes (eg discontinuous) which need it.
     type(mesh_faces), pointer :: faces=>null()
     !! Information on subdomain_ mesh, for partially prognostic solves:
     type(mesh_subdomain_mesh), pointer :: subdomain_mesh=>null()
     type(adjacency_cache), pointer :: adj_lists => null()
     !! array that for each node tells which column it is in
     !! (column numbers usually correspond to a node number in a surface mesh)
     integer, dimension(:), pointer :: columns => null()
     !! if this mesh is extruded this array says which horizontal mesh element each element is below
     integer, dimension(:), pointer :: element_columns => null()
     !! A list of ids marking different parts of the mesh
     !! so that initial conditions can be associated with it.
     integer, dimension(:), pointer :: region_ids=>null()
     !! Halo information for parallel simulations.
     type(halo_type), dimension(:), pointer :: halos=>null()
     type(halo_type), dimension(:), pointer :: element_halos=>null()
     type(integer_set_vector), dimension(:), pointer :: colourings=>null()
     !! A logical indicating if this mesh is periodic or not
     !! (does not tell you how periodic it is... i.e. true if
     !! any surface is periodic)
     logical :: periodic=.false.
  end type mesh_type
```

#### 3.2.related functions and subroutines about mesh_type

1. mesh_dim
2. mesh_periodic
3. make_mesh

---

**mesh_dim**

```
pure function mesh_dim(mesh)
integer :: mesh_dim
```

**mesh_periodic**

```
pure function mesh_periodic(mesh)
```

**make_mesh**

生成新网格

```
  function make_mesh (model, shape, continuity, name) result (mesh)
    !!< Produce a mesh based on an old mesh but with a different shape and/or continuity.
    type(mesh_type) :: mesh

    type(mesh_type), intent(in) :: model
    type(element_type), target, intent(in), optional :: shape
    integer, intent(in), optional :: continuity
    character(len=*), intent(in), optional :: name
```

###4.field(场) 数据结构

scalar_field 结构体

```
  type scalar_field
     !! Field value at points.
     real, dimension(:), pointer :: val
     !! Stride of val
     integer :: val_stride = 1
     !! Flag for whether val is allocated
     logical :: wrapped=.true.
     !! The data source to be used
     integer :: field_type = FIELD_TYPE_NORMAL
     !! boundary conditions:
     type(scalar_boundary_conditions_ptr), pointer :: bc => null()
     character(len=FIELD_NAME_LEN) :: name
     !! path to options in the options tree
#ifdef DDEBUG
     character(len=OPTION_PATH_LEN) :: option_path="/uninitialised_path/"
#else
     character(len=OPTION_PATH_LEN) :: option_path
#endif
     type(mesh_type) :: mesh
     !! Reference count for field
     type(refcount_type), pointer :: refcount=>null()
     !! Indicator for whether this is an alias to another field.
     logical :: aliased=.false.
     !! Python-field implementation.
     real, dimension(:, :), pointer :: py_locweight => null()
     character(len=PYTHON_FUNC_LEN) :: py_func
     type(vector_field), pointer :: py_positions
     logical :: py_positions_same_mesh
     integer :: py_dim
     type(element_type), pointer :: py_positions_shape => null()
  end type scalar_field
```

vector_field 结构体

```
  type vector_field
     !! dim x nonods vector values
     real, dimension(:,:), pointer :: val
     !! Flag for whether val is allocated
     logical :: wrapped = .true.
     !! The data source to be used
     integer :: field_type = FIELD_TYPE_NORMAL
     !! boundary conditions:
     type(vector_boundary_conditions_ptr), pointer :: bc => null()
     character(len=FIELD_NAME_LEN) :: name
     integer :: dim
     !! path to options in the options tree
#ifdef DDEBUG
     character(len=OPTION_PATH_LEN) :: option_path="/uninitialised_path/"
#else
     character(len=OPTION_PATH_LEN) :: option_path
#endif
     type(mesh_type) :: mesh
     !! Reference count for field
     type(refcount_type), pointer :: refcount=>null()
     !! Indicator for whether this is an alias to another field.
     logical :: aliased=.false.
     !! Picker used for spatial indexing (pointer to a pointer to ensure
     !! correct handling on assignment)
     type(picker_ptr), pointer :: picker => null()
  end type vector_field
```


###4.2.related functions and subroutines about fields

1. remap_field

---

**remap_field**

数据映射函数

```
  interface remap_field
     module procedure remap_scalar_field, remap_vector_field, remap_tensor_field, &
                    & remap_scalar_field_specific, remap_vector_field_specific
  end interface

  subroutine remap_scalar_field(from_field, to_field, stat)
    !!< Remap the components of from_field onto the locations of to_field.
    !!< This is used to change the element type of a field.
    !!<
    !!< This will not validly map a discontinuous field to a continuous
    !!< field.
    type(scalar_field), intent(in) :: from_field
    type(scalar_field), intent(inout) :: to_field
    integer, intent(out), optional :: stat


  subroutine remap_scalar_field_specific(from_field, to_field, elements, output, locweight, stat)
    !!< Remap the components of from_field onto the locations of to_field.
    !!< This is used to change the element type of a field.
    !!<
    !!< This will not validly map a discontinuous field to a continuous field.
    !!< This only does certain elements, and can optionally take in a precomputed locweight.
    type(scalar_field), intent(in) :: from_field
    type(scalar_field), intent(inout) :: to_field
    integer, dimension(:), intent(in) :: elements
    real, dimension(size(elements), to_field%mesh%shape%loc), intent(out) :: output
    integer, intent(out), optional:: stat

  subroutine remap_vector_field(from_field, to_field, stat)
    !!< Remap the components of from_field onto the locations of to_field.
    !!< This is used to change the element type of a field.
    !!<
    !!< The result will only be valid if to_field is DG.
    type(vector_field), intent(in) :: from_field
    type(vector_field), intent(inout) :: to_field
    integer, intent(out), optional :: stat
```


##femtools 库函数

**test_differentiate_field(infield, positions, derivatives, pardiff)**

偏导数计算

```
brief: 计算函数偏导数
test file: test_differentiate_field.F90
var:
      type(scalar_field), intent(in), target :: infield
      type(vector_field), intent(in) :: positions
      logical, dimension(:), intent(in) :: derivatives    !判断相应维度是否计算
      type(scalar_field), dimension(:), intent(inout) :: pardiff  !储存相应维度偏导值
```

**set_ele_nodes**

```
  subroutine set_ele_nodes(mesh, ele, nodes)
    type(mesh_type), intent(inout) :: mesh
    integer, intent(in) :: ele
    integer, dimension(:), intent(in) :: nodes
```

##femtools 库数据检索函数

Fields_Base.F90 :: module fields_base

**node_val**

返回场中节点值

```
  interface node_val
     module procedure node_val_scalar, node_val_vector, node_val_tensor, &
          & node_val_scalar_v, node_val_vector_v, node_val_vector_dim_v,&
          & node_val_tensor_v, node_val_vector_dim, node_val_tensor_dim_dim, &
          & node_val_tensor_dim_dim_v
  end interface

  function node_val_scalar(field, node_number) result (val)
    ! Return the value of field at node node_number
    type(scalar_field),intent(in) :: field
    integer, intent(in) :: node_number
    real :: val

  pure function node_val_vector(field, node_number) result (val)
    ! Return the value of field at node node_number
    type(vector_field),intent(in) :: field
    integer, intent(in) :: node_number
    real, dimension(field%dim) :: val
```

**surface_element_count**

```
  interface surface_element_count
    module procedure surface_element_count_scalar, surface_element_count_vector, &
          & surface_element_count_tensor, surface_element_count_mesh
  end interface

  pure function surface_element_count_scalar(field) result (element_count)
    ! Return the number of surface elements in a field.
    integer :: element_count
    type(scalar_field),intent(in) :: field

    if (associated(field%mesh%faces)) then
      element_count=size(field%mesh%faces%boundary_ids)
    else
      element_count=0
    end if

  end function surface_element_count_scalar
```

**ele_nodes**

返回单元内点的全局节点号数组

*注意，返回值为指针，调用函数中需要指针直接指向返回指针*

```
  interface ele_nodes
     module procedure ele_nodes_scalar, ele_nodes_vector, ele_nodes_tensor,&
          & ele_nodes_mesh
  end interface

  function ele_nodes_mesh(mesh, ele_number) result (ele_nodes)
    ! Return a pointer to a vector containing the global node numbers of
    ! element ele_number in mesh.
    integer, dimension(:), pointer :: ele_nodes
    type(mesh_type),intent(in) :: mesh
    integer, intent(in) :: ele_number
```

**ele_loc**

返回单元内点个数

```
  interface ele_loc
     module procedure ele_loc_scalar, ele_loc_vector, ele_loc_tensor,&
          & ele_loc_mesh
  end interface

  pure function ele_loc_mesh(mesh, ele_number) result (ele_loc)
    ! Return the number of nodes of element ele_number.
    integer :: ele_loc
    type(mesh_type),intent(in) :: mesh
    integer, intent(in) :: ele_number
```

**ele_val**

返回单元内点数据值

```
!> Return the value of a field at all of the nodes in an element.
!> The precise shape of the function value depends on the rank and dimension of the field.
  function ele_val(field, ele_number)
    type(scalar field), intent(in) :: field
    integer, intent(in) :: ele_number
    real, dimension(ele_loc(field, ele_number)) :: ele_val

  function ele_val(field, ele_number)
    type(vector_field),intent(in) :: field
    integer, intent(in) :: ele_number
    real, dimension(field%dim, ele_loc(field, ele_number)) :: ele_val

  function ele_val(field, ele_number)
    type(tensor_field),intent(in) :: field
    integer, intent(in) :: ele_number
    real, dimension(field%dim, field%dim, ele loc(field, ele_number)) :: ele_val

  function ele_val(field, ele_number, dim)
    type(vector_field), intent(in) :: field
    integer, intent(in) :: ele_number, dim
    real, dimension(ele loc(field, ele_number)) :: ele_val

  function ele_val(field, ele_number, dim1, dim2)
    type(tensor field), intent(in) :: field
    integer, intent(in) :: ele_number, dim1, dim2
    real, dimension(ele_loc(field, ele_number)) :: ele_val
```

**local_coords**

返回单元ele中全局节点node的局部坐标（或局部节点号）

*注意，输入全局节点号=>>局部节点号，输入全局坐标值=>>局部坐标值*

```
  interface local_coords
    module procedure local_coords_interpolation, &
          local_coords_interpolation_all, local_coords_mesh, &
          local_coords_scalar, local_coords_vector, local_coords_tensor
  end interface

  ! 返回position位置对应单元ele局部坐标
  function local_coords_interpolation(position_field, ele, position) &
    & result(local_coords)
    !!< Given a position field, this returns the local coordinates of
    !!< position with respect to element "ele".
    !!<
    !!< This assumes the position field is linear. For higher order
    !!< only the coordinates of the vertices are considered
    type(vector_field), intent(in) :: position_field
    integer, intent(in) :: ele
    real, dimension(:), intent(in) :: position
    real, dimension(size(position) + 1) :: local_coords

  ! 返回全局节点node对应单元ele内局部节点号
  function local_coords_mesh(mesh, ele, node, stat) result(local_coord)
    !!< returns the local node number within a given element ele of the global
    !!< node number node
    type(mesh_type), intent(in) :: mesh
    integer, intent(in) :: ele, node
    integer, intent(inout), optional :: stat
    integer :: local_coord

  function local_coords_vector(field, ele, node, stat) result(local_coord)
    !!< returns the local node number within a given element ele of the global
    !!< node number node
    type(vector_field), intent(in) :: field
    integer, intent(in) :: ele, node
    integer, intent(inout), optional :: stat
    integer :: local_coord

```

##附A:测试工具

在`unittest_tools`模块内添加专门显示Fluidity数据结构的函数print_mesh, print_scalar, print_vector，并给其命名统一接口名称为`print_val`。

记得将接口类型定义为public，方便测试函数调用

```
 !!< print user type definded values
  public
    print_val

  interface print_val
    module procedure print_mesh, print_scalar, print_vector
  end interface
```


###1.print_shape

显示element_type单元信息

1. 单元维度
2. 单元节点数
3. 单元精度
4. 单元内点个数
5. 单元高斯节点数

```
  subroutine print_shpe(shape)
  use elements
  type(element_type) :: shape

  write(*,*)"shape info"
  write(*,*)"shape dim: ", shape%dim
  write(*,*)"shape vertices: ", shape%quadrature%vertices
  write(*,*)"shape degree: ", shape%degree
  write(*,*)"shape local nodes: ", shape%loc
  write(*,*)"shape ngi: ", shape%ngi
  write(*,*)"shape info finish"

  end subroutine print_shpe
```

###2.print_mesh

显示mesh_type数据结构内容

1. 网格维度
2. 单元数
3. 节点数
4. 单元连续阶数
5. 输出单元拓扑关系 ndglno

```
  subroutine print_mesh(mesh)
  use fields_data_types
  use fields_base
  type(mesh_type) :: mesh
  integer :: i, vertices

  write(*,*)"mesh info"
  write(*,*)"mesh dim: ", mesh_dim(mesh)
  write(*,*)"mesh elemet: ", mesh%elements
  write(*,*)"mesh node: ", mesh%nodes
  write(*,*)"mesh continuity: ", mesh%continuity
  write(*,*)"mesh ndglno: [element x vertices]"

  vertices = mesh%shape%quadrature%vertices
  do i = 1,mesh%elements
    wirte(*,*)mesh%ndglno(vertices*(i-1)+1:vertices*i)
  end do
  write(*,*)"mesh info finish"
  end subroutine print_mesh
```

###3.print_scalar

显示scalar_field数据结构内容

1.

```
  subroutine print_scalar(scalar)
  use fields_data_types
  type(scalar_field) :: scalar

  write(*,*)"scalar info"
  write(*,*)

  end subroutine print_scalar
```

###4.print_vector

显示vector_field数据结构内容

1. 向量数据大小 vector size = [dim x length]
2. 向量维度 vector dimension
3. 向量引用数
4. 边界是否赋值
5. 向量数据

```
  subroutine print_vector(vector)
  use fields_data_types
  type(vector_field) :: vector

  write(*,*)"vector info"
  write(*,*)"vector size: [", size(vector%val, 1),",", size(vector%val, 2), "]"
  write(*,*)"vector dimension: ", vector%dim
  write(*,*)"vector references count: ", vector%refcount%count
  write(*,*)"vector have bc: ", associated(vector%bc)
  write(*,*)"vector values: [dim 1,   dim 2 ...]"
  do i = 1, size(vector%val, 2)
    write(*,*)"[", vector%val(:, i) ,"]"
  end do

  end subroutine print_vector
```
