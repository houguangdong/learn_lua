#!/usr/local/bin/lua

print('===================评论笔记=================')
-- 按实例的写法，每次new新实例的时候都需要将第一个变量的值设为nil,很不方便。可以稍做变形，把变量o放在函数里创建，免去麻烦。
--创建一个类，表示四边形
local RectAngle = {length, width, area}     --声明类名和类成员变量

function RectAngle:new( len, wid)    --声明新建实例的New方法
    local o = {
        --设定各个项的值
        length = len or 0,
        width = wid or 0,
        area = len * wid
    }
    setmetatable(o, {__index = self})  --将自身的表映射到新new出来的表中
    return o
end

function RectAngle:getInfo()            --获取表内信息的方法
    return self.length, self.width, self.area
end

a = RectAngle:new(10, 20)
print(a:getInfo())

b = RectAngle:new(10, 10)
print(b:getInfo())
print(a:getInfo())
print(string.rep('*', 100))
print('---------------------------------------------------------------------------------------------------------------')
-- 补充： . 与 : 的区别在于使用 : 定义的函数隐含 self 参数，使用 : 调用函数会自动传入 table 至 self 参数，示例：
classA = {}

function classA:getob( name )
    print(self)
    ob = {}
    setmetatable(ob, self)
    self.__index = self
    self.name = name
    return ob
end

function classA:getself( ... )
    return self
end

c1 = classA:getob("A")
c2 = classA:getob("B")
print(string.rep("*", 100))
print(c1:getself())
print(c2:getself())
print(string.rep("*", 100))
----------------------继承------------------------
classB = classA:getob()     ----非常重要，用于获取继承的self
function classB:getob( name, address )
    ob = classA:getob(name)
    setmetatable(ob, self)
    self.__index = self
    self.address = address
    return ob
end

c3 = classB:getob("gray.yang", "shenzhen")
print(c3:getself())
print(string.rep("*", 100))
print('---------------------------------------------------------------------------------------------------------------')
-- 模拟类和继承
classA = {}

function classA.new(cls, ... )  --定义类方法时使用"."号，不适用隐式传参
    this = {}
    setmetatable(this, cls)
    cls.__index = cls           --将元表的__index设为自身，访问表的属性不存在时会搜索元表
    print("111111")
    cls.init(this, ...)         --初始化表，注意访问类的方法都是"."，此时不会隐式传入参数
    print("33333")
    return this
end

function classA.init( self, name )
    print("22222")
    self.name = name
end

function classA.getname( self )
    return self.name
end

p = classA:new("gray.yang")
print(p:getname())
print(string.rep("*", 100))
print('---------------------------------------------------------------------------------------------------------------')
-- 模拟继承
classB = classA:new()                       --获得实例

function classB.new( cls, ... )
    this = {}
    setmetatable(this, cls)
    cls.__index = cls
    cls.init(this,...)
    return this
end

function classB.init( self, name, address )
    super = getmetatable(self)
    super:init(name)                        --使用父类初始化
    self.address = address
end


function classB.getaddress( self )
    return self.address
end

b = classB:new("tom.li", "shenzhen")
print("getbname==============>", b:getname())
print("getbaddress===========>", b:getaddress())
print('---------------------------------------------------------------------------------------------------------------')
-- 多重继承
-- 在table 'plist'中查找'k'
local function search( k, plist )
    for i=1, #plist do
        local v = plist[i][k]      -- 尝试第i个基类
        if v then
            return v
        end
    end
end

function createClass( ... )
    local c = {}                   -- 新类
    local parents = { ... }

    -- 类在其父类列表中的搜索方法
    setmetatable(c, {
        __index = function( t, k )
            return search(k, parents)
        end}
    )

    -- 将'c'作为其实例的元表
    c.__index = c

    -- 为这个新类定义一个新的构造函数
    function c:new( o )
        o = o or {}
        setmetatable(o, c)
        return o
    end
    return c                     -- 返回新类
end

-- 类Named
Named = {}
function Named:getname()
    return self.name
end

function Named:setname( n )
    self.name = n
end

--类Account
Account = {balance = 0}
function Account:withdraw( w )
    self.balance = self.balance - v
end

-- 创建一个新类NamedAccount，同时从Account和Named派生
NamedAccount = createClass(Account, Named)
account = NamedAccount:new()
account:setname("Ives")
print(account:getname())                -- 输出 Ives
print(string.rep("*", 50))
print('---------------------------------------------------------------------------------------------------------------')
-- 一个简单的面向对象实现
--[[
    Lua 中使用":"实现面向对象方式的调用。":"只是语法糖，它同时在方法的声明与实现中增加了一个名为 self 的隐藏参数，这个参数就是对象本身。
]]

--实例：
Account = {balance = 0};

--生成对象
function Account:new(o)
    o = o or {};                    --如果用户没有提供对象，则创建一个。
    setmetatable(o, self);          --将 Account 作为新创建的对象元表
    self.__index = self;            --将新对象元表的 __index 指向为 Account（这样新对象就可以通过索引来访问 Account 的值了）
    return o;                       --将新对象返回
end

--存款
function Account:deposit(v)
    self.balance = self.balance + v;
end

--取款
function Account:withdraw(v)
    self.balance = self.balance - v;
end

--查询
function Account:demand()
    print(self.balance);
end

--创建对象
myAccount = Account:new();
--通过索引访问
print(myAccount.balance);
--调用函数
myAccount:deposit(100);
myAccount:withdraw(50);
myAccount:demand();
print('---------------------------------------------------------------------------------------------------------------')
--其中 A 为抽象类，B 为矩形类，C 为立方体类。
--C 继承 B，B 继承 A。
--类对象各自独立，不影响类默认成员属性值。
B = {length, width, area}

function B:new(len,wid)
    local A = {length=0,width=0}
    local o = {}
    setmetatable(o,A)
    B.__index=A
    o.length=len or A.length
    o.width=wid or A.width
    o.area=o.length*o.width
    return o
end

a=B:new(2,3)
b=B:new(3,4)
print("长方形a的面积为"..a.area)
print("长方形b的面积为"..b.area)
print("长方形a的面积仍然为"..a.area..", a与b独立存在")

c=B:new()
print("长方形c根据默认构造函数的面积为"..c.area..", c的长宽分别为",c.length,c.width)

--立方体C，继承长方形类B
C = {high=0, volume=0, rectangle=B.new()} --增加体积值和高度
C.__index=C
function C:new(len, wid, hig)
    local o={}

    setmetatable(o,C)    --将原始类C作为它对象的原表

    o.rectangle=B:new(len,wid)
    o.high=hig or C.high
    o.volume=o.high*o.rectangle.area
    return o
end

cubeA=C:new(2,3,4)
cubeB=C:new(3,4,5)
print("立方体A的体积为"..cubeA.volume)
print("立方体B的体积为"..cubeB.volume)
print("立方体A的体积仍然为"..cubeA.volume..", A与B独立存在")

print("立方体A底面长方体的长与宽分别为" ,cubeA.rectangle.length ,cubeA.rectangle.width)
print("立方体B底面长方体的长与宽分别为" ,cubeB.rectangle.length ,cubeB.rectangle.width)
print("cubeA和cubeB的底边长方形同样独立存在")
print('---------------------------------------------------------------------------------------------------------------')
--我的实测结果与作者的理论有出入，先创建多个对象，然后再依次输出，会发现结果都是最后一个对象的值。
--Rectangle 的封装:

Rectangle = {area = 0, length = 0, breadth = 0}

function Rectangle:new (o,length,breadth)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    self.length = length or 0
    self.breadth = breadth or 0
    self.area = length*breadth;
    return o
end

function Rectangle:printArea ()
    print("矩形面积为 ",self.area)
end
-- 创建

local r = Rectangle:new(nil, 2, 3);
local p = Rectangle:new(nil, 4, 5);

-- 输出
r:printArea();
p:printArea();
--结果:
--    矩形面积为     20
--    矩形面积为     20
--也就是说，p 和 r 其实不是两个完全无关的对象。
print('---------------------------------------------------------------------------------------------------------------')
--回楼上，两个新建实例并没有关系，只是新建实例时修改了元表，第二次新建覆盖了值:
local Rect = {area = 0,length = 0, windth = 0};
function Rect:new(length, windth)
    local t = {};
    setmetatable(t,self);
    self.__index = self;
    t.length = length;
    t.windth = windth;
    t.area = t.length * t.windth;
    return t;
end

function Rect:ShowArea()
    print(self.area);
end

local a = Rect:new(1,2);
local b = Rect:new(3,4);
a:ShowArea();
b:ShowArea();
print(a);
print(b);
--输出结果:
--2
--12
--table: 0000000019AA22A0
--table: 0000000019AA2610
print('---------------------------------------------------------------------------------------------------------------')
--对楼上补充说明：
--Rect 作为 new 出来的表(楼上代码写的 a 和 b)的元表：由于没有设置 __newindex 元方法。
--所以 a 和 b 在赋值的时候把长和宽的值赋给了自己，并没有把值赋给 Rect (也就是说 Rect 表中的数据一直都没有改变过)。
--a 和 b 在调用 ShowArea 方法的时候，自己的表里没有这个方法，会到元表中寻找这个方法，元表(Rect)中设置了 __index 元方法，
--所以能找到 ShowArea 这个方法，然后调用。(注意这里是 a 和 b 调用的 ShowArea 方法，所以 ShowArea 方法中 self 指向的是 a 和 b，而不是 Rect)。
print('---------------------------------------------------------------------------------------------------------------')
--简化了 Rectangle 的定义，只需一个空的表格即可：
-- 定义矩形类
Rectangle = {}

-- 初始化矩形对象
function Rectangle:new(length, breadth)

-- 创建一个新的对象
local newObj = {
    length = length or 0,
    breadth = breadth or 0,
    area = 0
}
-- 设置新对象的元表为 Rectangle，以便继承 Rectangle 的方法
setmetatable(newObj, self)
self.__index = self
-- 计算矩形的面积
newObj.area = length * breadth
-- 返回创建的对象
return newObj
end

-- 打印矩形的面积
function Rectangle:printArea()
print("矩形面积为", self.area)
end

-- 示例用法
-- 创建一个矩形对象
local myRectangle = Rectangle:new(5, 10)
-- 打印矩形的面积
myRectangle:printArea()