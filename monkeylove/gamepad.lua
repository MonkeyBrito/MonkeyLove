local Gamepad = {
	_NAME        = "MonkeyLove Gamepad",
	_VERSION     = 'v1.0',
	_LÖVE        = '11.3',
	_DESCRIPTION = 'Gamepad for Android LÖVE games',
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

local Gamepad = class('Gamepad') --Before CButton.

local __gamepads = {}

local ww, hh = love.graphics.getDimensions()

function Gamepad:initialize(Radius,X,Y,Label,Normal,Pressed,Font,Mode)
	self.radius = Radius or 30
	self.x = X
	self.y = Y
	
	self.label = Label or ''

	self.normalColor = Normal or colors('WHITE',0.1)--colors('CYAN')
	self.pressedColor = Pressed or colors('WHITE',0.2)--grayscale(0.8)
	self.currentColor = self.normalColor
	self.labelColor = colors('WHITE',0.2)
	
	self.font = Font or love.graphics.getFont()
	self.mode = Mode or 'fill'
	
	self.held = false
	self.pressed = false
	self.released = false
	self.enabled = true

	table.insert(__gamepads,self)
end

function Gamepad:isHeld()
	return self.held
end

function Gamepad:isPressed()
	if self.pressed then
		self.pressed = false
		return true
	end
	return false
end

function Gamepad:isReleased()
	if self.released then
		self.released = false
		return true
	end
	return false
end

function Gamepad:setGamepad(Radius, Number, D_pad, Px, Py, Font, Mode)
	local radius = Radius or ww/24 --30
	local number = Number or 1
	local dpad = D_pad or false
	local Px, Py = Px or ww - radius*(3.75-0.625), Py or hh - radius*(3.35-0.525)
	local Font = Font or nil
	local Mode = Mode or nil
	if number == 1 then
		self.B = self:new(
			radius,
			Px,
			Py,
			'',
			nil,
			nil,
			Font,
			Mode
		)
	elseif number == 2 then
		self.A = self:new(
			radius,
			Px + radius*(2.5-0.625),
			Py,
			'A',
			colors('RED',0.1),
			colors('RED',0.2),
			Font,
			Mode
		)
		self.B = self:new(
			radius,
			Px,
			Py + radius,
			'B',
			colors('YELLOW',0.1),
			colors('YELLOW',0.2),
			Font,
			Mode
		)
	elseif number == 3 then
		self.A = self:new(
			radius,
			Px + radius*(2.5-0.625),
			Py,
			'A',
			colors('RED',0.1),
			colors('RED',0.2),
			Font,
			Mode
		)
		self.B = self:new(
			radius,
			Px - radius*0.25,
			Py + radius*1.175,
			'B',
			colors('YELLOW',0.1),
			colors('YELLOW',0.2),
			Font,
			Mode
		)
		self.X = self:new(
			radius,
			Px - radius*0.25,
			Py - radius*1.175,
			'X',
			colors('BLUE',0.1),
			colors('BLUE',0.2),
			Font,
			Mode
		)
	elseif number == 4 then
		self.A = self:new(
			radius,
			Px + radius*(2.5-0.625),
			Py,
			'A',
			colors('RED',0.1),
			colors('RED',0.2),
			Font,
			Mode
		)
		self.B = self:new(
			radius,
			Px,
			Py + radius*(2.1-0.525),
			'B',
			colors('YELLOW',0.1),
			colors('YELLOW',0.2),
			Font,
			Mode
		)
		self.X = self:new(
			radius,
			Px,
			Py - radius*(2.1-0.525),
			'X',
			colors('BLUE',0.1),
			colors('BLUE',0.2),
			Font,
			Mode
		)
		self.Y = self:new(
			radius,
			Px - radius*(2.5-0.625),
			Py,
			'Y',
			colors('GREEN',0.1),
			colors('GREEN',0.2),
			Font,
			Mode
		)
	end
	if dpad then
		self.RIGHT = self:new(
			radius,
			radius*4.25,
			hh - radius*2.75,
			'RIGHT',
			nil,
			nil,
			Font,
			Mode
		)
		self.DOWN = self:new(
			radius,
			radius*2.75,
			hh - radius*1.25,
			'DOWN',
			nil,
			nil,
			Font,
			Mode
		)
		self.UP = self:new(
			radius,
			radius*2.75,
			hh - radius*4.25,
			'UP',
			nil,
			nil,
			Font,
			Mode
		)
		self.LEFT = self:new(
			radius,
			radius*1.25,
			hh - radius*2.75,
			'LEFT',
			nil,
			nil,
			Font,
			Mode
		)
	end
end

function Gamepad:toggleEnabled()
	for i,v in ipairs(__gamepads) do
		v.enabled = not v.enabled
	end
end

function Gamepad:draw()
	for i,v in ipairs(__gamepads) do
		if v.enabled then
			love.graphics.setColor(v.currentColor)
			love.graphics.circle(v.mode, v.x, v.y, v.radius)
			love.graphics.setColor(v.labelColor)
			setLabel(v.label,v.font,v.x-v.radius,v.y-v.radius,v.radius*2,v.radius*2,'center') --CAMBIAR
			love.graphics.setColor(1, 1, 1, 1)
		end
	end
end

function Gamepad:touchpressed(id,tx,ty)
	for i,v in ipairs(__gamepads) do
		if v.enabled then
			if isInsideCircle(v,tx,ty) then
				v.held = true
				v.pressed = true
				v.released = false
				v.currentColor = v.pressedColor
			end
		end
	end
end

function Gamepad:touchreleased(id,tx,ty)
	for i,v in ipairs(__gamepads) do
		if v.enabled then
			if v.held then
				v.held = false
				v.pressed = false
				v.released = true
				v.currentColor = v.normalColor
			end
		end
	end
end

return Gamepad
