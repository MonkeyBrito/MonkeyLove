local Analog = {
	_NAME        = "MonkeyLove Analog",
	_VERSION     = 'v1.0',
	_LÖVE        = '11.3',
	_DESCRIPTION = 'Analog stick for Android LÖVE games',
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
	]],
	_CREDITS     = [[
	Credits to "HugoBDesigner" for his awasome "Andralog - Analog control for
	android" on which this module was based.
	]]
}

local Analog = class('Analog')

local __analogs = {}

local ww, hh = love.graphics.getDimensions() --love.window.getMode() Replace ?

function Analog:initialize(Ar, Right, Ax, Ay, Br, Bd, BBy, Spring, Reclick, Limited, Range, Release, Hitbox)
	self.size = Ar or 50
	self.button =  Br or self.size/2
	self.deadzone = Bd or 0 --Range from 0 to 1
	self.bby = BBy or self.button --OffSet of Bunding Box Y. Range 0 to ScreenHeight/2(positive) or 0 to self.size(negative).
	
	self.right = Right or false
	
	self.ax, self.ay = Ax, Ay
	if Ax and Ay ~= nil then
		self.static = true
		self.xo, self.yo = Ax, Ay
	else
		self.static = false
		if self.right then
			self.xo = ww
			self.yo = hh - self.button
			
			self.x = ww/2 + self.size*3
			self.y = hh/2 - self.bby
			self.w = ww/2 - self.size*2
			self.h = hh - self.y + self.bby
		else
			self.xo = self.size
			self.yo = hh - self.button
			
			self.x = 0
			self.y = hh/2 - self.bby
			self.w = ww/2 - self.size*2
			self.h = hh - self.y + self.bby
		end
	end
	
	--Configurable settings
	self.spring =  Spring or true
	self.reclick = Reclick or true
	self.limitedRange = Limited or false
	self.rangeRelease = Range or false
	self.releaseSpeed = Release or .2
	self.hitbox = Hitbox or self.button * 2
	
	--No Configurable settings
	self.angle = 0
	self.d = 0 --Range from 0 to 1 --Modulo del vector(dx,dy)?
	self.dx = 0 --Range from 0 to 1
	self.dy = 0 --Range from 0 to 1
	self.releasePos = 0
	self.releaseTimer = 0
	self.held = false
	self.inside = false
	self.enabled = true
	
	table.insert(__analogs,self)
end

function Analog:getX()
	return self.dx
end

function Analog:getY()
	return self.dy
end

function Analog:isHeld()
	return self.held
end

function Analog:toggleEnabled()
	for i,v in ipairs(__analogs) do
		v.enabled = not v.enabled
	end
end

function Analog:update(dt)
	for i,v in ipairs(__analogs) do
		if v.enabled then
			--Update stick position.
			if v.static then
				v.ax, v.ay = v.xo + math.cos(v.angle)*v.d*(v.button*1.2), v.yo - math.sin(v.angle)*v.d*(v.button*1.2)
			else
				if v.inside then
					if v.xo < v.size then
						v.xo = v.size
					elseif v.xo > (ww - v.button) then
						v.xo = ww
					end
					if v.yo > (hh - v.button/2) then
						v.yo = hh - v.button
					elseif v.yo < v.size then
						v.yo = v.size
					end
					v.ax, v.ay = v.xo + math.cos(v.angle)*v.d*(v.button*1.2), v.yo - math.sin(v.angle)*v.d*(v.button*1.2)
				end
			end
			--Restore stick position to center if not being held.
			if v.releaseTimer > 0 then
				v.releaseTimer = math.max(0, v.releaseTimer-dt)
			end
			if v.held == false and v.spring == true then
				v.d = math.max(0, v.releasePos*(v.releaseTimer/v.releaseSpeed) )
			end
			if v.spring and v.held == false and v.releaseTimer == 0 and not (v.dx == 0 and v.dy == 0) then
				v.releaseTimer = v.releaseSpeed
				v.releasePos = v.d
				v.dx = 0
				v.dy = 0
			end
		end
	end
end

function Analog:draw()
	for i,v in ipairs(__analogs) do
		if v.enabled then
			--if v.static == false then
				--love.graphics.setColor(1,0,0)
				--love.graphics.print(v.h,100,300)
				--love.graphics.rectangle('line',v.x,v.y,v.w,v.h)
			--end
			if v.static then
				love.graphics.setColor(1,1,1,0.2) --Analog Range.
				love.graphics.circle("fill", v.xo, v.yo, v.size, 32)
				--love.graphics.circle("line", v.xo, v.yo, v.size, 32)
				
				love.graphics.setColor(1,1,1,0.3) --Analog Stick.
				love.graphics.circle("fill", v.ax, v.ay, v.button, 32)
				--love.graphics.circle("line", v.ax, v.ay, v.button, 32)
			else
				if v.inside then
					love.graphics.setColor(1,1,1,0.2) --Analog Range.
					love.graphics.circle("fill", v.xo, v.yo, v.size, 32)
					--love.graphics.circle("line", v.xo, v.yo, v.size, 32)
					
					love.graphics.setColor(1,1,1,0.3) --Analog Stick.
					love.graphics.circle("fill", v.ax, v.ay, v.button, 32)
					--love.graphics.circle("line", v.ax, v.ay, v.button, 32)
				else
					love.graphics.setColor(1,1,1,0.1) --Analog Range.
					love.graphics.circle("fill", v.xo, v.yo, v.size, 32)
					--love.graphics.circle("line", v.xo, v.yo, v.size, 32)
				end
			end
			love.graphics.setColor(1,1,1,1)
		end
	end
end

function Analog:touchpressed(id, x, y, dx, dy, pressure)
	for i,v in ipairs(__analogs) do
		if v.enabled then
			if v.static == false then
				if isInsideBoundingBox(v, x, y) then
					v.xo, v.yo = x, y
					v.inside = true
				end
			end
			local distance = getDistance(x, y, v.xo, v.yo)
			if not (v.reclick == false and v.d > 0 and v.spring == true) then
				if distance <= v.hitbox then     --Before 'distance <= v.button'...
					v.held = id
				end
			end
		end
	end
end

function Analog:touchmoved(id, x, y, dx, dy, pressure)
	for i,v in ipairs(__analogs) do
		if v.enabled then
			if v.held == id then
				local distance = getDistance(x, y, v.xo, v.yo)
				v.d = math.min(1, distance/v.size)
				if not (v.limitedRange and distance > v.size) then
					v.angle = getAngle(x, y, v.xo, v.yo)
				end
				if v.d >= v.deadzone then
					if not (v.limitedRange and distance > v.size) then
						v.dx = math.cos(v.angle) * (v.d-v.deadzone)/(1-v.deadzone)
						v.dy = -math.sin(v.angle) * (v.d-v.deadzone)/(1-v.deadzone)
					end
					if v.rangeRelease and distance > v.size then
						v:touchReleased(id, x, y, dx, dy, pressure)
					end
				else
					v.dx = 0
					v.dy = 0
				end
			end
		end
	end
end

function Analog:touchreleased(id, x, y, dx, dy, pressure)
	for i,v in ipairs(__analogs) do
		if v.enabled then
			if v.held == id then
				v.held = false
				v.inside = false
				if not (v.spring == false and v.d > v.deadzone) then
					v.releaseTimer = v.releaseSpeed
					v.releasePos = v.d
					v.dx = 0
					v.dy = 0
				end
			end
		end
	end
end

return Analog
