#[Tips] ssh
1. 指定用户登录
```
    ssh -l root 211.81.49.66
```
或
```
    ssh root@211.81.49.66
```
2. 传输文件命令
```
    sudo scp yanbing@TH-1A-LN3:[file path]/[file name] [local folder]/
```
3. 断点续传
```
    sudo rsync -P --rsh=ssh yanbing@TH-1A-LN3:[file path]/[file name] [local folder]/
```