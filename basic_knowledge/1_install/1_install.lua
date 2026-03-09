--Lua 环境安装
--Linux 系统上安装
--Linux & Mac 上安装 Lua 安装非常简单，只需要下载源码包并在终端解压编译即可，本文使用了 5.4.7 版本进行安装：
print('--------------------------------------------源码安装-------------------------------------------------------------')
--源码安装
--下载源码安装：
--curl -L -R -O https://www.lua.org/ftp/lua-5.4.7.tar.gz
--tar zxf lua-5.4.7.tar.gz
--cd lua-5.4.7
--make all test
--make install
print('--------------------------------------------Debian/Ubuntu 系统--------------------------------------------------')
--使用包管理器安装
--Debian/Ubuntu 系统:
--sudo apt update
--sudo apt install lua5.3
print('--------------------------------------------CentOS/RHEL 系统----------------------------------------------------')
--CentOS/RHEL 系统:
--sudo yum install epel-release
--sudo yum install lua
print('--------------------------------------------Mac OS X 系统上安装--------------------------------------------------')
--Mac OS X 系统上安装
--源码安装
--下载源码安装：
--curl -L -R -O https://www.lua.org/ftp/lua-5.4.7.tar.gz
--tar zxf lua-5.4.7.tar.gz
--cd lua-5.4.7
--make all test
--make install
print('--------------------------------------------Homebrew安装--------------------------------------------------------')
--Homebrew
--使用 Homebrew 安装：
--brew install lua
--测试
--接下来我们创建一个 HelloWorld.lua 文件，代码如下:
--print("Hello World!")
--执行以下命令:
--$ lua HelloWorld.lua
--输出结果为：
--Hello World!
print('--------------------------------------------Window 系统上安装 Lua------------------------------------------------')
--Window 系统上安装 Lua
--window 下你可以使用一个叫 "SciTE" 的 IDE环 境来执行 lua 程序，下载地址为：
--Github 下载地址：https://github.com/rjpcomputing/luaforwindows/releases
--Google Code下载地址 : https://code.google.com/p/luaforwindows/downloads/list
--双击安装后即可在该环境下编写 Lua 程序并运行。