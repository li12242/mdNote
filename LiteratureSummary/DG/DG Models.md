#DG Models

间断有限元数值方法海洋模拟
<~/Document>
离散方法：
1. 网格
2. 垂向坐标
3. 未知数离散

##1.基函数
**modal**
**nodal**

##2.时间递进方法
**Semi-implicit**

**IMEX-RK**

**Rosenbrock with optimized Schwarz**

##3.网格
###3.1.垂向坐标
**z坐标** 存在缺点

**terrain following/terrain-fitted**
$\sigma$坐标

**Isopycnal coordinate**
等密度坐标

**hybrid coordinates**
混合坐标
Bleck, 1978

**shaved cells**
Adcroft et al., 1997
###3.2.边界
**High-order boundaries**
线性障碍物边界导致高阶振荡情况，使用曲线边界单元来避免振荡出现

****

##4.变量离散
Fix, 1975, finite element formulation for ocean modeling, suffer from advective instabilities
**mixed finite element formulations**
