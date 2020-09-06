local Button = {
	_NAME        = "MonkeyLove Button",
	_VERSION     = 'v1.0',
	_LÖVE        = '11.3',
	_DESCRIPTION = 'Button multi-purpose for love2d games & apps',
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

local Button = class('Button')

local __buttons = {}

function Button:initialize(image,w,h,x,y,label,onClick,normal,pressed,toggled,onToggle,labelToggled,font,onRelease,update)

	if type(image) ~= "nil" then
		if type(image) == "string" then
			self.img = love.graphics.newImage(image)
		elseif type(image) == "userdata" then
			self.img = image
		else
			print('ERROR cargando imagen')
		end
		
		self.w = self.img:getWidth()
		self.h = self.img:getHeight()
		self.imgButton = true
	else-----------------------------------------------------------------------------
		self.w = w
		self.h = h
		self.imgButton = false
	end
	
	self.x = x
	self.y = y
	
	self.labelNormal = label or ''
	self.labelToggled = labelToggled or self.labelNormal
	self.label = self.labelNormal
	
	self.onClick = onClick or function() end
	
	self.normalColor = normal or colors('CYAN')
	self.pressedColor = pressed or grayscale(0.8)
	self.toggledColor = toggled or grayscale(0.9)
	if normalColor == colors('BLACK') then
		self.labelColor = colors('WHITE')
	else
		self.labelColor = colors('BLACK')
	end
	self.disabledColor = grayscale(0.2)
	self.currentColor = self.normalColor
	
	if type(onToggle) == "function" then
		self.toggle = true
		self.onToggle = onToggle
	else
		self.toggle = false
	end
	
	self.font = font or love.graphics.getFont()
	
	self.onRelease = onRelease or function() end
	self.update = update or function() end
	
	self.enabled = true
	self.value = false
	
	table.insert(__buttons,self)
end

function Button:toggleEnabled()
	self.enabled = not self.enabled
	if self.enabled == false then
		self.currentColor = self.disabledColor
		self.labelColor = colors('WHITE')
	else
		self.currentColor = self.normalColor
		if normalColor == colors('BLACK') then
			self.labelColor = colors('WHITE')
		else
			self.labelColor = colors('BLACK')
		end
	end
end

function Button:update(dt)
	for i,v in ipairs(__buttons) do
		if v.enabled then
			v.update(dt)
		end
	end
end

function Button:draw()
	for i,v in ipairs(__buttons) do
		love.graphics.setColor(v.currentColor)
		if v.imgButton == true then
			love.graphics.draw(v.img, v.x, v.y)
		elseif v.imgButton == false then
			love.graphics.rectangle('fill',v.x,v.y,v.w,v.h)
			love.graphics.rectangle('line',v.x,v.y,v.w,v.h)
		end
		love.graphics.setColor(v.labelColor)
		setLabel(v.label,v.font,v.x,v.y,v.w,v.h,'center')
		love.graphics.setColor(colors('WHITE'))
	end
end

function Button:touchpressed(id,tx,ty)
	for i,v in ipairs(__buttons) do
		if v.enabled then
			if isInsideBoundingBox(v, tx, ty) then
				if v.toggle then
					v.value = not v.value
					if v.value == true then
						v.onClick()
					else
					v.onToggle()
					end
				else
					v.onClick()
				end
				v.currentColor = v.pressedColor
			end
		end
	end
end

function Button:touchreleased(id,tx,ty)
	for i,v in ipairs(__buttons) do
		if v.enabled then
			v.onRelease()
			if v.toggle then 
				if v.value == true then	
					v.currentColor = v.toggledColor
					v.label = v.labelToggled

				else
					v.currentColor = v.normalColor
					v.label = v.labelNormal
				end
			else
				v.currentColor = v.normalColor
			end
		end
	end
end

return Button
