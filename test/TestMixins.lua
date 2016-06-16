--
-- Note: In the current implementation, mixins are intended to be the smallest element of code reuse after the function.
-- So you cannot subclass mixins, and a mixin cannot include another mixin.
--
require "luaunit"
local Object = require 'objectlua.Object'
local Class = require 'objectlua.Class'
local Mixin = require 'objectlua.Mixin'

TestMixins = {}

local AClass
local AMixin

local aMethod = function(self)
                    return 'Leopard'
                end

function TestMixins:setUp()
    Class:reset()
    AClass = Object:subclass 'AClass'
    AMixin = Mixin:subclass()
end

TestMixins:setUp()

function TestMixins:testDefintion()
    AMixin.getString = aMethod

    assertError(function()
                    AMixin.stateValue = 1
                end, 'Mixins have no state')
end

function TestMixins:testClassIncludingMixin()
    AMixin.getString = aMethod

    AClass:include(AMixin)
    local object = AClass:new()

    assertEquals(object:getString(), 'Leopard')
end
--TestMixins:testClassIncludingMixin()

function TestMixins:testMixinIncludingOtherMixinFails()
    local AnotherMixin = Mixin:subclass()
    assertError(function()
                    AMixin:include(AnotherMixin)
                end)
end
--TestMixins:testMixinIncludingOtherMixinFails()

function TestMixins:testClassMethodOverrideMixinMethod()
    function AClass:shouldBeFromClass()
        return 'From class'
    end

    function AMixin:shouldBeFromClass()
        return 'From mixin'
    end

    AClass:include(AMixin)

    local obj = AClass:new()
    assertEquals(obj:shouldBeFromClass(), 'From class')

end
--TestMixins:testClassMethodOverrideMixinMethod()

function TestMixins:testMixinMethodOverridesSuperClassMethod()
    function AClass:shouldBeFromMixin()
        return 'From class'
    end

    function AMixin:shouldBeFromMixin()
        return 'From mixin'
    end

    local AnotherClass = AClass:subclass 'AnotherClass'
    AnotherClass:include(AMixin)

    local obj = AnotherClass:new()
    assertEquals(obj:shouldBeFromMixin(), 'From mixin')
end
--TestMixins:testMixinMethodOverridesSuperClassMethod()

function TestMixins:testSuperMixinCall()
	function AMixin:initialize(age)
		self.age = age
	end

	local A = Object:subclass()
	A:include(AMixin)

	function A:initialize(name, age)
		self.name = name
		mixin.initialize(self, age)
		super.initialize(self)
	end
	
	a = A:new("S", 10)
    assertEquals(a.name, 'S')
    assertEquals(a.age, 10)
	print(a.name, a.age)
end

TestMixins:testSuperMixinCall()
