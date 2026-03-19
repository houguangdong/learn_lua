# local c = require "skynet.core" # 没看见这个skynet.core的文件呀
你没找到 skynet.core 文件是很正常的。
为什么看不到 skynet.core 这个文件？

require "skynet.core"不是一个 Lua 文件。
它是一个 C 语言编写的 Lua 模块（动态库），在 Skynet 编译时生成。
对应的源代码文件是：
lualib-src/lua-skynet.c（在 Skynet 源码根目录下）
编译后会生成：
Linux 下通常是 lualib/skynet/core.so
或者被静态链接进 skynet 主程序中
所以你在 lualib/skynet/ 目录下通常只能看到 skynet.lua，而看不到 core.lua 或 core 文件夹，这就是原因。


简单说明 skynet.core 的作用
它提供了 Skynet 最底层的接口，例如：
c.command() → 执行 LAUNCH、REG 等底层命令
c.send()、c.call() 等底层消息发送
c.now()、c.int2ptr() 等底层工具函数
高层 skynet.lua 模块就是封装了 skynet.core，让你用起来更方便。

实际使用建议（新手）
99% 的情况下你不需要直接 require "skynet.core"。
正确写法是：
Lualocal skynet = require "skynet"     -- 推荐，只 require 这个就够了

-- 下面这些底层用法一般用不到，除非你要写很底层的代码
-- local c = require "skynet.core"
如果你只是想看源码学习
去 GitHub 查看原始文件：
https://github.com/cloudwu/skynet/blob/master/lualib-src/lua-skynet.c （C 实现）
https://github.com/cloudwu/skynet/blob/master/lualib/skynet.lua （Lua 封装）
或者直接在你本地的 Skynet 源码目录搜索 lua-skynet.c。

总结：
看不到 skynet.core 文件是正常现象，它是编译后的 C 模块，不是 Lua 源码文件。
平时写服务时，直接 require "skynet" 就够了，不需要手动 require core。