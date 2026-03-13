#--------------------------------------方式1-----------------------------------------------------------------------------
通过VMWare workstation pro安装centos8.0，然后生成 ssh-keygen -t ed25519 -C "1737785826@qq.com" 公钥私钥，然后上传到我的github。
右上角头像 → Settings → SSH and GPG keys → New SSH key
git clone git@github.com:cloudwu/skynet.git
cd skynet
make linux
#--------------------------------------方式2-----------------------------------------------------------------------------
在 Windows 的 PowerShell 或 CMD 里运行：
wsl -l -v # 查看所以的wsl环境
wsl   # 进入wsl, 进入指定的环境 wsl -d Ubuntu18.04   sudo apt install -y make
然后编译 可以在/home/d/skynet或/mnt/e/ghou/github/skynet路径都可以
make linux
#--------------------------------------vscode远程连接wsl中ubuntu系统-------------------------------------------------------
前置条件（检查一下有没有漏）
1 Windows 已安装 WSL2 + Ubuntu（默认 distro 通常叫 Ubuntu 或 Ubuntu-22.04 等）
  命令行验证（PowerShell 或 CMD）：
    wsl -l -v
  看到 Ubuntu 状态 Running，版本 2 就 OK。
2 Windows 侧已安装 Visual Studio Code（不是在 WSL 里装！从 https://code.visualstudio.com 下载 Windows 版）。
#-----------------------------
步骤 1：安装 WSL 扩展（最关键一步）
1 打开 VS Code（Windows 版）。
2 按 Ctrl + Shift + X 打开 Extensions 面板。
3 搜索 WSL，安装下面这个官方扩展（作者 Microsoft）：
  WSL（ms-vscode-remote.remote-wsl）
  推荐一起装 Remote Development 扩展包（包含 WSL + SSH + Containers），
  搜索 “Remote Development” 安装即可（itemName: ms-vscode-remote.vscode-remote-extensionpack）。
安装完后 VS Code 左下角会出现一个绿色小图标（Remote 指示器），鼠标悬停会显示 “WSL: Ubuntu” 或类似。

步骤 2：连接到 WSL Ubuntu（三种常用方式，任选一种）
方式一：最简单，从 VS Code 里直接连（推荐新手）
  按 Ctrl + Shift + P（或 F1）打开命令面板。
  输入并选择：
    WSL: Connect to WSL（默认连接到主 Ubuntu distro）
    或 WSL: Connect to WSL using Distro → 选你的 Ubuntu 名字（如 Ubuntu-24.04）。

VS Code 会自动在 WSL 里安装 VS Code Server（第一次会稍等 10-30 秒）。
连接成功后：
  左下角显示 WSL: Ubuntu（或你的 distro 名）
  终端（Ctrl + `）已经是 Linux 的 bash/zsh
  文件路径显示为 Linux 风格（如 /home/yourname/project）

方式二：在 WSL 终端里直接打开文件夹（最常用日常方式）
打开你的 WSL Ubuntu 终端（Windows 开始菜单搜 “Ubuntu”）。
cd 到你的项目目录，例如：
  cd ~/projects/my-repo
直接输入：
  code .
这会自动在 VS Code（Windows 侧）打开当前文件夹，并连接到 WSL。
第一次会下载并安装 server，后续秒开。

方式三：从 Windows 命令行指定 distro 打开
# 在 PowerShell 或 CMD 里
code --remote wsl+Ubuntu ~/projects/my-repo
# 或指定具体 distro 名
code --remote wsl+Ubuntu-24.04 /home/yourname/code

连接成功后的提示 & 小技巧
左下角绿色图标：点击它能看到所有 Remote 命令（如 Reopen in WSL、Close Remote Connection）。
推荐把项目文件放在 WSL 文件系统里（性能最好）：
路径示例：/home/yourname/project（对应 Windows 的 \wsl$\Ubuntu\home\yourname\project）
不要放 C:\Users... 下（跨文件系统 IO 慢很多）。

扩展安装：在 WSL 连接状态下安装的扩展，会自动安装到 WSL 侧（比如 Python、C++、Docker 等扩展会用 Linux 里的解释器/工具）。
断开连接：文件 → Close Remote Connection（或左下角点击 → Close Remote Connection）。

常见问题快速排查
1 “正在安装 VS Code Server” 卡住很久？
#→ 检查网络（国内可能需代理/加速），或重启 WSL：PowerShell 里 wsl --shutdown 再重试。
2 连接失败 / Could not fetch remote environment？
#→ 删除 WSL 里的旧 server：
在 WSL 终端运行 rm -rf ~/.vscode-server
然后重新连接，它会重新下载。
3 没看到 WSL 选项？
#→ 确认 WSL 扩展已启用，重启 VS Code，或检查 Docker Desktop / 其他远程扩展是否冲突。
4 想连特定 distro？
#→ 用 “WSL: Connect to WSL using Distro” 选。
照着做基本零失败。如果你卡在哪一步（比如扩展装不上、连接报错），把具体报错贴出来，我再帮你 debug。享受 WSL + VS Code 的丝滑开发吧～