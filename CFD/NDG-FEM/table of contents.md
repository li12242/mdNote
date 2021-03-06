# table of contents

## 1.Introduction of Discontinuous Galerkin Finite Element Methods
### 1.1.DG方法简介
### 1.2.DG-FEM与FV及FE之间共同点与区别
### 1.3.DG未来发展

<a href="1.Intro/1.Introduction.md">Introduction</a>

## 2.NDG-FEM方法

### 2.1.间断有限元数值离散过程

### 2.2.基函数
#### 2.2.1.基函数分类
#### 2.2.2.各类基函数优缺点


### 2.3.NDG-FEM基函数选取
#### 2.3.1.一维单元
#### 2.3.2.二维单元

### 2.4.数值积分
#### 2.4.1.积分精度
#### 2.4.2.NDG-FEM中积分简化方法

### 2.5.数值通量

### 2.6.时间积分

## 3.模型介绍
### 3.1.程序模块划分
### 3.2.各个模块主要功能
### 3.3.模型并行

## 4.NDG-FEM在守恒方程中应用
### 3.1.一维非守恒方程
#### 3.1.1.一维波动方程
#### 3.1.2.一维扩散方程

### 3.2.Burgers方程
#### 3.2.1.一维Burgers方程
#### 3.2.2.二维Burgers方程

### 3.3.限制器
#### 3.3.1.限制器比较
#### 3.3.2.NDG-FEM限制器


## 4.NDG-FEM方法在浅水方程中应用

### 4.1.NDG-FEM在一维浅水方程应用
#### 4.1.1.控制方程
#### 4.1.2.方程离散
#### 4.1.3.well-balanced 格式
#### 4.1.4.干湿处理
#### 4.1.5.边界条件
#### 4.1.6.数值验证

### 4.2.NDG-FEM在二维浅水方程应用
#### 4.2.1.控制方程
#### 4.2.2.方程离散
#### 4.2.3.well-balanced 格式
#### 4.2.4.干湿处理
#### 4.2.5.边界条件
#### 4.2.6.数值验证

## 5.三维水动力模型
