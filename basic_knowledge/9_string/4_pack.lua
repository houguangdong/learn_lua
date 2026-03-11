#!/usr/local/bin/lua

--string.pack(">s2", pack) 是 Lua 5.3+（以及 LuaJIT 的部分版本）中用来打包字符串为二进制数据的经典写法。
--这里 ">s2" 是 format string，表示：
--    >：大端序（big-endian，网络字节序最常用）
--    s2：带 2 字节长度前缀的字符串（length-prefixed string）
--
--打包规则详解（s2 的行为）
--格式,     含义,                     长度前缀大小,                      字符串最大长度（理论）,               实际打包总字节数
--s1,      1 字节长度前缀,             1 byte,                          0~255,                           1 + 字符串长度
--s2,      2 字节长度前缀（uint16）,    2 bytes,                         0~65535,                         2 + 字符串长度
--s4,      4 字节长度前缀（uint32）,    4 bytes,                         0~4294967295,                    4 + 字符串长度
--s,       size_t 长度前缀（通常 8 字节或 4 字节，取决于平台）,  size_t,      取决于 size_t,                    size_t 大小 + 字符串长度

--所以 ">s2" 最常见于：
--网络协议
--文件格式
--与其他语言（如 C、Go、Python struct）互操作
--需要明确知道字符串长度不超过 65535 的场景
--
--实际打包例子（假设 pack 是字符串变量）
local pack = "hello世界"

local binary = string.pack(">s2", pack)
-- binary 内容（十六进制表示）：
-- 前 2 字节：长度 11（0x000B，因为 "hello世界" 是 5+6=11 个字节，UTF-8）
-- 后面 11 字节：实际字符串数据

print(#binary)                      -- → 13（2 + 11）
print(binary:byte(1,2))      -- → 0  11   （大端：高字节 0，低字节 11）

-- 更直观打印
for i = 1, #binary do
    io.write(string.format("%02X ", binary:byte(i)))
end
-- 输出示例（UTF-8 下）：
-- 00 0B 68 65 6C 6C 6F E4 B8 96 E7 95 8C

--对应的解包（unpack）
local str, next_pos = string.unpack(">s2", binary)
print(str)       -- → "hello世界"
print(next_pos)  -- → 14（正好是 #binary + 1，表示读完）

--常见使用场景对比
--场景,                   推荐格式,            为什么用 s2 而不是 s4/s1
--网络协议（TCP/UDP）,      >s2 或 >s4,         长度通常够用，节省 2 字节
--短字符串（<256 字节）,     >s1,               最省空间
--可能很长的字符串,          >s4 或 >s8,         防止溢出
--与 Java/Go/Python 互操作, >s2 或 >s4,        很多库默认 uint16/uint32
--极致性能/内存敏感,         >s1,                少 1~3 字节
--
--小结：一句话记住
--string.pack(">s2", str) = 把字符串 str 前面加上2 字节大端长度，总共打包成 (2 + #str) 字节的二进制数据，常用于网络/文件协议中传递字符串。
--如果你现在是想：
--    写某个具体协议的打包？
--    处理中文/UTF-8 时的坑？
--    与其他语言对齐？
--    批量打包多个字段？