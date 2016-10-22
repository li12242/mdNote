# 使用 Matlab 生成动画

# 1. 绘制动画的基本方法

动画与普通的图像最大区别在于要使图像动起来，而完成这一操作的方法就是不停更新`axes`上图像。更新手段有两种
1. 抹去上一帧的图线，重新绘制
2. 修改图形参数，更新图像

明显，在Matlab里采用第二种方法操作时程序运动会更快。而修改的参数也主要是 `XData`，`YData`或`ZData`等数据属性。

# 2. 储存

储存动画时最常用的方法是利用`VideoWriter`对象。首先生成对象并设置相关属性，并打开生成的对象

    writerObj = VideoWriter(videoName); % 通过视频文件名生成对象
    writerObj.FrameRate=5; % 设定帧数
    open(writerObj); % 打开对象

打开对象后便可以向其中一帧一帧的添加动画，使用`getframe`获得当前窗口内的图像，并将其写入`VideoWriter`对象中

    frame = getframe(gcf); % 获取当前窗口内图像
    writeVideo(writerObj,frame); % 将图像储写入文件中

设置完毕后，关闭对象，便得到动画文件。

    close(writerObj);
