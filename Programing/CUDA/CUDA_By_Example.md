# Ch6. Const Memory and Events

某些情况下存储吞吐才是瓶颈，采用常量内存代替全局内存可以减少内存访问吞吐量。

## 6.2. 常量内存
### 光线追踪问题（ray tracing）

当把三维物体投影到二维平面上时，常用的方法是栅格化（rasterization）。这种方法就是把我们看到的每一个点用一个图像摄像机代替，问题是如何确定这个点的颜色。采用逆向思维方法，让光线从这个射出，当光线与固体相交时，便可确定整个图像。

**特性1.在结构体中定义方法**

在结构体 `Sphere` 中定义方法 `hit` 用来判断球体与（ox, oy）位置处像素是否相交。

```CUDA
struct Sphere {
    float r,b,g;
    float radius;
    float x,y,z;
    __device__ float hit( float ox, float oy, float *n ) {
        float dx = ox - x;
        float dy = oy - y;
        if (dx*dx + dy*dy < radius*radius) {
            float dz = sqrtf( radius*radius - dx*dx - dy*dy );
            *n = dz / sqrtf( radius * radius );
            return dz + z;
        }
        return -INF;
    }
};
```

### 使用常量内存考虑光线追踪问题

使用常量内存主要特点

* 变量定义前加修饰符 `__constant__`
* 编译时指定大小
* 从host内存复制到常量内存时使用 `cudaMemcpyToSymbol` 函数
* 不必使用 `cudaFree` 函数释放内存

### 使用常量内存提升性能

使用常量内存是把双刃剑，当半个warp读取相同内存时可以大量节省时间，但是当这16个进程读取不同地址时会导致性能显著下降。

##6.3. 使用事件测试性能

不能使用 CPU 或者系统计时器，因为这其中包含各种原因产生的延迟（系统线程调度等）。事件 `event` 实际就是GPU的一个时间标记，来记录用户指定时刻的时间。当我们采用事件进行时间标记时只需要两个步骤：

1. 创立一个事件
2. 记录一个事件

其代码如下所示。

```
cudaEvent_t start;
cudaEventCreate(&start);
cudaEventRecord( start, 0 );
```

为了记录一段代码运行时间，只需要设立一个开始事件和一个停止事件，其主要过程为

```
cudaEvent_t start, stop;
cudaEventCreate(&start);
cudaEventCreate(&stop);
cudaEventRecord( start, 0 );
// do some work on the GPU
cudaEventRecord( stop, 0 );
```
在这里仍存在一点问题，由于GPU运行是异步的，当GPU开始运行我们的记录事件指令时，CPU会在GPU运行结束之前开始运行下一条指定。因此，我们需要采用另一个函数`cudaEventSynchronize`来同步CPU。当我们调用`cudaEventSynchronize`返回时，便可知道在GPU中stop前所有指令都已经完成了，因此可以正确统计GPU运行时间。

# Ch7. Texture Memory

## 7.2. 纹理内存概述

纹理内存是另一种只读内存。与常量内存相同，纹理内存也是在芯片上，因此在某些情形下可以通过减少内存请求次数来提供更高的带宽，但是要求内存读取具有空间局部性。

## 7.3. 热传导模拟

# Ch8. Graphics Interoperability
# Ch9. Atomics
# Ch10. Streams
# Ch11. Multiple GPUs
# Ch12. Final
