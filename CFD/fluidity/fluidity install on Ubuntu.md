#fluidity install on Ubuntu

###1.编译器安装gcc-4.6.4

###2.python
Ubuntu 14.0自带python2.7，所以直接安装dev即可

```
sudo apt-get install python-dev
```

* setuptools
```
$ tar -xvf setuptools-12.0.5.tar.gz
$ cd setuptools-12.0.5
$ su
python setup.py install --prefix=/hpcdata1/xiaozhong/public
```
此时在`/hpcdata1/xiaozhong/public`目录下生成`lib/python2.7/site-packages`目录，运行里面`setuptools-12.0.5-py2.7.egg`脚本，便在`/usr/local/bin/`目录下生成`easy_install`命令。
```
sudo sh ./setuptools-12.0.5-py2.7.egg
```
测试
```
    easy_install numpy
```

###3.petsc

* bison & flex

首先安装bison和flex
```
sudo apt-get install bison flex
```

* cmake
metis安装需要cmake-2.8以上版本

* petsc-3.3-p7


