local Stepper = {
	_NAME        = "MonkeyLove Stepper",
	_VERSION     = 'v1.0',
	_LÖVE        = '11.3',
	_DESCRIPTION = 'Stepper options selector for love2d games & apps',
	_URL         = 'https://github.com/MonkeyBrito/MonkeyLove',
	_LICENSE     = [[
	MIT LICENSE
	
	Copyright (c) 2020 Eduardo Brito Rosas

	Permission is hereby granted, free of charge, to any person obtaining a
	copy of this software and associated documentation files (the
	"Software"), to deal in the Software without restriction, including
	without limitation the rights to use, copy, modify, merge, publish,
	distribute, sublicense, and/or sell copies of the Software, and to
	permit persons to whom the Software is furnished to do so, subject to
	the following conditions:

	The above copyright notice and this permission notice shall be included
	in all copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
	OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
	MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
	IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
	CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
	TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
	SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
	]]
}

--local current_folder = (...):gsub('%.[^%.]+$', '')

local Stepper = class("Stepper")

local __steppers = {}

function Stepper:initialize(x,y,w,h,lLabel,rLabel,max,selections,step,loop,separation,custom,font,normal,pressed)

	self.x = x
	self.y = y
	self.w = w
	self.h = h
	
	self.lLabel = lLabel
	self.rLabel = rLabel
	
	self.min = 1
	self.max = max
	self.selections = selections
	self.step = step or 1
	
	self.loop = loop or false
	
	self.separation = separation or 1
	self.blX = x - h - self.separation
	self.brX = x + w + self.separation
	
	self.counter = custom or 1
	
	self.enabled = true
	
	self.font = font or love.graphics.getFont()
	self.normalColor = normal or colors('CYAN')
	self.pressedColor = pressed or grayscale(0.8)
	self.disabledColor = grayscale(0.2)
	self.fontColor = colors('BLACK')
	self.currentColor = self.normalColor
	
	self.BL = Button:new(nil,self.h,self.h,self.blX,self.y,lLabel,function() self:decreaseCounter() end,normal,pressed,nil,nil,font)
	self.BR = Button:new(nil,self.h,self.h,self.brX,self.y,rLabel,function() self:increaseCounter() end,normal,pressed,nil,nil,font)
	
	table.insert(__steppers,self)
end

function Stepper:toggleEnabled()
	self.enabled = not self.enabled
	if self.enabled then
		self.currentColor = self.normalColor
		self.fontColor = colors('BLACK')
		self.BL:toggleEnabled()
		self.BR:toggleEnabled()
	else
		self.currentColor = self.disabledColor
		self.fontColor = colors('WHITE')
		self.BL:toggleEnabled()
		self.BR:toggleEnabled()
	end
end

function Stepper:decreaseCounter()
	self.counter = self.counter - self.step
	if self.counter < self.min then
		if self.loop then
			self.counter = self.max
		else
			self.counter = self.min
		end
	end
end

function Stepper:increaseCounter()
	self.counter = self.counter + self.step
	if self.counter > self.max then
		if self.loop then
			self.counter = self.min
		else
			self.counter = self.max
		end
	end
end

function Stepper:currentSelection()
	return self.selections[self.counter]
end

function Stepper:draw()
	for i,v in ipairs(__steppers) do
		love.graphics.setColor(v.currentColor)
		love.graphics.rectangle("fill",v.x,v.y,v.w,v.h)
		
		love.graphics.setColor(v.fontColor)
		setLabel(v.selections[v.counter],v.font,v.x,v.y,v.w,v.h,'center')
		love.graphics.setColor(colors('WHITE'))
	end
end

return Stepper
