
本文对海洋环流模型的边界条件进行总结。
海洋环流模型边界条件主要分为三种

1. 特征边界（Characteristic boundary condition）
2. 辐射边界（Radiation condition）
3. 海绵层边界（sponge layer）

其中辐射边界条件也可以认为是一种特征边界方程，但是由于其广泛应用于各类海洋模型中，故将其单独列为一种开边界条件。

首先回顾下有关海洋模型开边界条件的综述类文章。
  
储敏和徐永福（2009）总结了海洋模型数值求解过程中边界条件出现的原因（计算区域和计算尺度之间协调），以及边界条件需要满足的特征（1.适定；2.无反射；3.数值兼容；4.精度和稳定；5.收敛）。
文章分析了5种边界条件，包括

1. 简单边界条件  
在简单边界条件中，包括固壁，Clamped，零梯度，简单辐射边界等。其中 Clamped 边界是边界值不随时间变化边界，零梯度边界是边界附近没有物质或能量输运情形。
2. 辐射边界条件  
辐射边界主要有 Sommerfeld，Orlanski，Raymond 三种。Sommerfeld 最早提出辐射边界。Orlanski 提出相速度 $c_g$ 计算方法，但是此方法存在缺陷，Reymond 提出了二维情形下相速度计算方法。
3. 松弛边界条件  
松弛方法是将牛顿阻尼项加入到控制方程中来，许多模型将松弛边界与辐射边界结合，得到了很好的结果。
4. Steven 开边界方法
5. Gill 开边界方法
  
文章结论认为，不存在普世的理想边界条件，边界条件依赖于所解决的物理问题。
[储敏, 徐永福. 区域海洋模式中的开边界问题[J]. 海洋科学, 2009, 33(6): 112-117.]()


<!-- TOC -->

- [1. 特征边界条件](#1-特征边界条件)
    - [1.1. Sanders, 2002](#11-sanders-2002)
- [2. 辐射边界总结](#2-辐射边界总结)
    - [2.1. MT 1981](#21-mt-1981)
    - [2.2. BK, 1985](#22-bk-1985)
    - [2.3. MP, MJ, SA, 2001](#23-mp-mj-sa-2001)

<!-- /TOC -->

# 1. 特征边界条件

| No | Author | Year | Journal | Title |
| :--- | :---:  | :---  | :---  | :---  |
| 1 | Sanders | 2002 | AWR | Non-reflecting boundary flux function for finite volume shallow-water models |

## 1.1. Sanders, 2002

作者在文中采用 Roe 格式计算数值通量，并应用一种简化计算 Roe 平均值计算公式。
在此方法中，入流采用指定流量，出流指定水位。
根据浅水方程特征线进入和流出计算域，在入流和出流边界内，采用内部出流特征线和外部值一起确定最终特征向量，进而计算 Roe 数值通量。

这种方法在河口边界在入流和出流状态下转换时，可能存在问题。

# 2. 辐射边界总结

| No | Author | Year | Journal | Title |
| :--- | :---:  | :---  | :---  | :---  |
| 1 | Miller & Thorpe | 1981 | Q J ROY METEOR SOC | Radiation conditions for the lateral boundaries of limited-area numerical models |
| 2 | Blumberg & Kantha | 1985 | Journal of Hydraulic Engineering  | Open boundary condition for circulation models |
| 3 | Marchesiello et al. | 2001 | Ocean Modelling | Open boundary conditions for long-term integration of regional oceanic models |


## 2.1. MT 1981

Radiation conditions for the lateral boundaries of limited-area numerical models
Miller and Thorpe, 1981

* There are at least four important considerations in assessing any boundary condition: stability, accuracy, well-posedness, and suitability for the algorithm.
* If a boundary condition is stable then in most cases it will probably be accurate enough; however, as higher order finite-difference schemes are being introduced into meteorological models the problem of accuracy may become a niore important one than it has been in the past.

分析了辐射边界条件和外插方法的精度，并对其进行了比较。

## 2.2. BK, 1985

采用辐射边界条件，并添加驱动项，使其能够使内部波动传出计算域，并生成入射波驱动内部水体。

## 2.3. MP, MJ, SA, 2001

本文在 ROMS 中实现一种新的自适应辐射边界，这种边界可以在入流和出流条件进行转换，保证稳定性。




