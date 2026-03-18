".launcher" 服务是干什么的？
.launcher 是 Skynet 框架中非常核心的一个内置服务（用 Lua 写的，文件是 service/launcher.lua）。
它的主要职责就是：

负责创建（启动）几乎所有的 Lua 服务。
当你调用 skynet.newservice("xxx", ...) 时，底层其实是向 .launcher 服务发送一条 "LAUNCH" 消息，让它去执行真正的启动操作。
它会调用底层的 skynet.launch("snlua", "xxx", ...) 来创建一个新的 snlua 服务（即带 Lua 虚拟机的服务）。
同时管理服务的名字注册（skynet.name）、查询等。

简单来说：
所有 skynet.newservice()、skynet.launch() 的请求，最终都交给 .launcher 这个服务来处理。
它是在 Skynet 启动的最早期（bootstrap.lua 中）就被启动的第一个用户级 Lua 服务，然后给自己注册名字 .launcher（带点前缀表示系统服务）。
#=======================================================================================================================
跨 harbor 是什么意思？
Harbor 是 Skynet 多节点（分布式）集群里的概念，翻译成“港口”或“节点ID”。

每个 Skynet 进程（节点）启动时都会分配一个 harbor id（范围通常是 1~255）。
本节点的 harbor id 一般是 1（或配置文件里指定的）。
同一个 harbor 内的服务：直接通过 handle（数字地址）互相发消息，速度很快（本地消息队列）。
不同 harbor（跨 harbor）：表示服务在不同的 Skynet 进程/机器上。
消息发送时，Skynet 会把消息转发给本节点的 harbor 服务（一个特殊的 C 服务）。
harbor 服务通过 TCP 把消息打包发到目标节点的 harbor，再投递给目标服务。


skynet_isremote(ctx, handle, &harbor) 这个函数的作用就是：

判断给定的 handle 是否跨 harbor（即不在当前节点）。
如果是远程的，会把对方节点的 harbor id 写到 *harbor 里。

实际意义：

单机部署时，通常只有一个 harbor，所有服务都在本地，不存在跨 harbor。
多机/多进程集群时（比如游戏服分 login、game、db 等不同节点），就需要通过 harbor 进行跨节点通信。
性能上，跨 harbor 消息会有额外开销（序列化 + TCP），所以框架提供了 skynet_isremote 让你能判断并做优化。
#=======================================================================================================================
总结一句话：
.launcher = “服务孵化器 / 服务管理中心”，负责生孩子（启动新服务）。
跨 harbor = “跨节点 / 跨进程 / 跨机器”，需要走网络（TCP）通信。