# 使用实验室集群建立VPN服务

集群操作系统为：centos 5

1. 先看看你的主机是否支持pptp，返回结果为yes就表示通过

	```
	# modprobe ppp-compress-18 && echo ok
	```

2. 是否开启了TUN，有的虚拟机主机需要开启，返回结果为`cat: /dev/net/tun: File descriptor in bad state` 就表示通过

	```
	# cat /dev/net/tun
	```


3. 安装ppp , pptpd 和 iptables

	```
	#wget http://acelnmp.googlecode.com/files/pptpd-1.3.4-1.rhel5.1.x86_64.rpm
	#rpm -ivh pptpd-1.3.4-1.rhel5.1.x86_64.rpm
	```

4. 配置pptpd.conf，找到`locapip`和`remoteip`这两个配置项，将前面#去掉，将后面的IP地址更改为自己需要IP，locapip表示服务器的IP地址，remoteip表示客户端连到服务器上将会被分配的IP地址范围

	```
	#vim /etc/pptpd.conf
	localip 192.168.11.1
	remoteip 192.168.0.234-238,192.168.0.245
	```

5. 配置options.pptpd

	```
	# vi /etc/ppp/options.pptpd
	在末尾添加DNS地址：
	ms-dns  8.8.4.4
	```

6. 配置连接VPN客户端要用到的帐号密码

	```
	vi /etc/ppp/chap-secrets    #格式很通俗易懂。
	#  client为帐号，server是pptpd服务，secret是密码，*表示是分配任意的ip
	# Secrets for authentication using CHAP
	# client        server    secret                  IP addresses
	count        pptpd    771297972            *
	```
7. 配置sysctl.conf

	```
	#vi /etc/sysctl.conf
	将net.ipv4.ip_forward = 0 中的 0 改为 1 就OK
	重启
	#sysctl –p
	```

8. 这个时候把iptables关闭的话是可以连接VPN了，之所以要把iptables关闭是因为没有开放VPN的端口，客户如果直接连接的话是不允许的。这里还需要设置iptables的转发规则，让你的客户端连接上之后能访问外网

	```
	iptables -t nat -F
	iptables -t nat -A POSTROUTING -s 192.168.0.234/24 -j SNAT --to 服务器的公网IP
	#192.168.0.234/24是你分配给客户的ip，后面的那个是你的服务器的公网IP
	```

9. 这个时候还是连接不上的，因为iptables把客户的VPN连接拦截了，不允许连接，所以得开放相应的端口，为防火墙添加一条规则：

	```
	iptables -I INPUT -p tcp --dport 1723 -j ACCEPT
	iptables -I INPUT -p tcp --dport 47 -j ACCEPT
	iptables -I INPUT -p gre -j ACCEPT
	```
10. 然后保存配置并且重启防火墙服务

	```
	#/etc/init.d/iptables save
	# service iptables restart
	```
11. 重启PPTP服务

	```
	#/etc/init.d/pptpd restart
	```

使用Ipad设置：
设置-->通用-->网络-->VPN-->添加VPN配置...-->
选择PPTP
描述 随意填
服务器  xxx.xxx.xxx.xxx
帐号: xx
密码：xx


参考网站：

<http://blog.sina.com.cn/s/blog_a8414f7001016tqx.html>

<http://www.linuxidc.com/Linux/2014-10/108609.htm>
