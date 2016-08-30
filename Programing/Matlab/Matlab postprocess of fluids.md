#Matlab流体后处理中的奇淫巧术总结

主要参考`\demos\volvec.m`示例

#1.等值面绘制
  
```
%% Isosurface of MRI Data
cla
load mri
D = squeeze(D);
[x, y, z, D] = subvolume(D, [nan nan nan nan nan 4]);
p = patch(isosurface(x,y,z,D, 5), 'FaceColor', 'red', 'EdgeColor', 'none');
patch(isocaps(x,y,z,D, 5), 'FaceColor', 'interp', 'EdgeColor', 'none');
isonormals(x,y,z,D,p);
view(3)
daspect([1 1 .4])
colormap(gray(100))
camva(9)
box on
camlight(40, 40)
camlight(-20,-10)
lighting gouraud

```

* isosurface(x,y,z,D, 5)

参数意义为，从由X,Y,Z构造的体积V数据中提取由isovalue指定的等值数据，返回结果为一个结构体，包含了等值面的顶点和面（顶点的次序），这些参数可以直接传给patch命令画出图形来。

![](http://fmn.rrimg.com/fmn063/20150114/2225/original_mE7r_494600003fe9118c.jpg)

#2.圆锥体流线图绘制

```
cla
load wind
[cx, cy, cz] = meshgrid(linspace(71,134,10),linspace(18,59,10),3:4:15);
daspect([1 1 1])    % gca, 'DataAspectRatio' 属性设置 
h = coneplot(x,y,z,u,v,w,cx,cy,cz,y,3);
set(h,'EdgeColor', 'none')
colormap(hsv)
box on
axis tight              % 使坐标系的最大值和最小值和你的数据范围一致
camproj perspective
camva(35)               % Camera view angle.
campos([175 10 85])     % Camera position.
camtarget([105 40 0])   % Camera target. （三维图形质心）
camlight left           % Create or set position of a light.
lighting gouraud        % 查看曲面单元时使用lighting gouraud 或 lighting phong


```

* h = coneplot(x,y,z,u,v,w,cx,cy,cz,y,3);

用圆锥体绘制三维流速图，$$$x,y,z,u,v,w$$$是流速场分布，$$$cx,cy,cz$$$是圆锥体位置
  
![](http://fmn.rrimg.com/fmn062/20150114/2225/original_LG3P_2468000025b7125f.jpg)

#3.绘制流线图
```
cla
[sx, sy, sz] = meshgrid(80, 20:10:50, 0:5:15);
h = streamline(x,y,z,u,v,w,sx,sy,sz);
set(h, 'Color', 'cyan')
daspect([1 1 1])
box on
camproj perspective
camva(32)
axis tight
campos([175 10 85])
camtarget([105 40 0])
camlight left
lighting gouraud
```

* h = streamline(x,y,z,u,v,w,sx,sy,sz);

$$$x,y,z,u,v,w$$$是流速场分布，$$$sx,sy,sz$$$定义了流线起点。(有关如何定义流线起始点问题，请参考附录B)
  
![](http://fmn.rrfmn.com/fmn059/20150114/2225/original_02N7_33fa00002245125d.jpg)

#4.流管图

```
cla
[sx, sy, sz] = meshgrid(80, [20 30 40], [5 10]);
daspect([1,1,1])
h = streamtube(x,y,z,u,v,w,sx,sy,sz);
set(h,'facecolor','cyan','edgecolor','none')
box on
camproj perspective
axis([70 138 17 60 2.5 16])
axis tight
camva(28)
campos([175 10 95])
camtarget([105 40 0])
camlight left
lighting gouraud  
```

* h = streamtube(x,y,z,u,v,w,sx,sy,sz);

    streamtube(X,Y,Z,U,V,W,STARTX,STARTY,STARTZ) draws stream
    tubes from vector data U,V,W. The arrays X,Y,Z define the
    coordinates for U,V,W and must be monotonic and 3D plaid (as if
    produced by MESHGRID). STARTX, STARTY, and STARTZ define the
    starting positions of the streamlines at the center of the
    tubes.  `The width of the tubes is proportional to the
    normalized divergence of the vector field.` A vector of surface
    handles (one per start point) is returned in H.
 
 	`矢量管的粗细和该点处散度有关`
 	
![](http://fmn.rrimg.com/fmn064/20150114/2225/original_1DMN_643b000024581191.jpg)

#5.流线带图

```
cla
[sx, sy, sz] = meshgrid(80, [20 30 40], [5 10]);
daspect([1,1,1])
h = streamribbon(x,y,z,u,v,w,sx,sy,sz);
set(h,'facecolor','cyan','edgecolor','none')
box on
camproj perspective
axis([70 138 17 60 2.5 16])
axis tight
camva(28)
campos([175 10 85])
camtarget([105 40 0])
camlight left
lighting gouraud
```

 * h = streamribbon(x,y,z,u,v,w,sx,sy,sz);
 
    streamribbon(X,Y,Z,U,V,W,STARTX,STARTY,STARTZ) draws stream
    ribbons from vector data U,V,W. The arrays X,Y,Z define the
    coordinates for U,V,W and must be monotonic and 3D plaid (as if
    produced by MESHGRID). STARTX, STARTY, and STARTZ define the
    starting positions of the streamlines at the center of the
    ribbons.  The twist of the ribbons is proportional to the
    curl of the vector field. The width of the ribbons is
    calculated  automatically.

![](http://fmn.rrfmn.com/fmn058/20150114/2225/original_wbSc_0398000024251190.jpg)

#附录A.Accessing Subregions of Volume Data
The subvolume function provides a simple way to access subregions of a volume data set. subvolume enables you to select regions of interest based on limits rather than using the colon operator to index into the 3-D arrays that define volumes. Consider the following two approaches to creating the data for a subvolume — indexing with the colon operator and using subvolume.

Indexing with the Colon Operator

When you index the arrays, you work with values that specify the elements in each dimension of the array.  

```
load wind
xsub = x(1:10,20:30,1:7);
ysub = y(1:10,20:30,1:7);
zsub = z(1:10,20:30,1:7);
usub = u(1:10,20:30,1:7);
vsub = v(1:10,20:30,1:7);
wsub = w(1:10,20:30,1:7);
```

Using the subvolume Function

subvolume enables you to use coordinate values that you can read from the axes. For example:

	lims = [100.64 116.67 17.25 28.75 -0.02 6.86];
	[xsub,ysub,zsub,usub,vsub,wsub] = subvolume(x,y,z,u,v,w,lims);
	
You can then use the subvolume data as inputs to any function requiring vector volume data.

#附录B.Specifying Starting Points for Stream Plots
Stream plots (stream lines, ribbons, tubes, and cones or arrows) illustrate the flow of a 3-D vector field. The MATLAB® stream-plotting functions (streamline, streamribbon, streamtube, coneplot, stream2, stream3) all require you to specify the point at which you want to begin each stream trace.  
  
**Determining the Starting Points**

Generally, knowledge of your data's characteristics helps you select the starting points. Information such as the primary direction of flow and the range of the data coordinates helps you decide where to evaluate the data.
  
The streamslice function is useful for exploring your data. For example, these statements draw a slice through the vector field at a z value midway in the range.  

```
load wind
zmax = max(z(:)); zmin = min(z(:));
streamslice(x,y,z,u,v,w,[],[],(zmax-zmin)/2)
```

![streamslice](http://cn.mathworks.com/help/matlab/visualize/volvis_startpoint1.png)  

This stream slice plot indicates that the flow is in the positive x-direction and also enables you to select starting points in both x and y. You could create similar plots that slice the volume in the x-z plane or the y-z plane to gain further insight into your data's range and orientation.

**Specifying Arrays of Starting-Point Coordinates**

To specify the starting point for one stream line, you need the x-, y-, and z-coordinates of the point. The meshgrid command provides a convenient way to create arrays of starting points. For example, you could select the following starting points from the wind data displayed in the previous stream slice.

	[sx,sy,sz] = meshgrid(80,20:10:50,0:5:15);
	
This statement defines the starting points as all lying on x = 80, y ranging from 20 to 50, and z ranging from 0 to 15. You can use plot3 to display the locations.  

```
plot3(sx(:),sy(:),sz(:),'*r');
axis(volumebounds(x,y,z,u,v,w))
grid on 
set(gca,'BoxStyle','full','Box','on')
daspect([2 2 1])
```

![](http://cn.mathworks.com/help/matlab/visualize/volvis_startpoint2.png)
  
You do not need to use 3-D arrays, such as those returned by meshgrid, but the size of each array must be the same, and meshgrid provides a convenient way to generate arrays when you do not have an equal number of unique values in each coordinate. You can also define starting-point arrays as column vectors. For example, meshgrid returns 3-D arrays:

```
[sx,sy,sz] = meshgrid(80,20:10:50,0:5:15);
whos
  Name      Size             Bytes  Class     Attributes

  sx        4x1x4              128  double              
  sy        4x1x4              128  double              
  sz        4x1x4              128  double      
```

In addition, you could use 16-by-1 column vectors with the corresponding elements of the three arrays composing the coordinates of each starting point. (This is the equivalent of indexing the values returned by meshgrid as sx(:), sy(:), and sz(:).)

For example, adding the stream lines to the starting points produces:

	streamline(x,y,z,u,v,w,sx(:),sy(:),sz(:))  

![](http://cn.mathworks.com/help/matlab/visualize/volvis_startpoint3.png)


    