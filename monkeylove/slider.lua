local Slider = {
	_NAME        = "MonkeyLove Slider",
	_VERSION     = 'v1.0',
	_LÖVE        = '11.3',
	_DESCRIPTION = 'Slider multi-purpose for love2d games & apps',
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

local Slider = class('Slider')

local lineWidth = defaultLineWidth() * 2
local __sliders = {}

function Slider:initialize(x,y,w,max,cursor,radius,normal,alpha)
	self.xo = x            -- Line start position X
	self.xf = x + w        -- Line end position X
	self.yl = y            -- Line position Y
	self.wl = w            -- Line Width
	
	self.max = max or 1
	
	self.cursor = cursor or self.xo
	self.radius = radius or 6
	self.diam = self.radius * 1.5
	self.diam2 = self.diam * 2
	
	self.x = x - self.diam * 1.5   -- Bounding Box position X
	self.y = y - self.diam * 1.5   -- Bounding Box position Y
	self.w = w + self.diam * 3     -- Bounding Box Width
	self.h = self.diam * 3         -- Bounding Box Height
	
	self.value = ((self.cursor - self.xo) * self.max)/self.wl
	
	self.normalColor = normal or colors('CYAN')
	self.normAlphaColor = alpha or colors('CYAN',0.25)
	self.normalUnColored = grayscale(100/255)
	self.disabledColor = grayscale(0.2)
	
	self.held = false
	self.enabled = true
	
	table.insert(__sliders,self)
end

function Slider:cursorValue()
	return self.value
end

function Slider:toggleEnabled()
	self.enabled = not self.enabled
end

function Slider:update(dt)
	for i,v in ipairs(__sliders) do
		v.value = ((v.cursor - v.xo) * v.max)/v.wl
	end
end

function Slider:draw()
	for i,v in ipairs(__sliders) do
		if v.enabled then
			love.graphics.setLineWidth(lineWidth)
			love.graphics.setColor(v.normalUnColored)
			love.graphics.line(v.cursor,v.yl,v.xf,v.yl)
		
			love.graphics.setColor(v.normalColor)
			love.graphics.line(v.xo,v.yl,v.cursor,v.yl)
			love.graphics.setLineWidth(defaultLineWidth())
		
			if  not v.held then
				love.graphics.circle("fill",v.cursor,v.yl,v.radius)
				love.graphics.circle("line",v.cursor,v.yl,v.radius)
			else
				love.graphics.circle("fill",v.cursor,v.yl,v.diam)
				love.graphics.circle("line",v.cursor,v.yl,v.diam)
				love.graphics.setColor(grayscale(66/255,0.25))
				love.graphics.circle("fill",v.cursor,v.yl,v.diam2)
				love.graphics.setColor(v.normAlphaColor)
				love.graphics.rectangle("line",v.x,v.y,v.w,v.h)
			end
		else
			love.graphics.setColor(v.disabledColor)
			love.graphics.setLineWidth(lineWidth)
			love.graphics.line(v.xo,v.yl,v.xf,v.yl)
			love.graphics.setLineWidth(defaultLineWidth())
			love.graphics.circle("fill",v.cursor,v.yl,v.radius)
			love.graphics.circle("line",v.cursor,v.yl,v.radius)
		end
		love.graphics.setColor(colors('WHITE'))
	end
end

function Slider:touchpressed(id,tx,ty)
	for i,v in ipairs(__sliders) do
		if v.enabled then
			if isInsideBoundingBox(v,tx,ty) then
				v.held = true
				v.cursor = tx
				if v.cursor < v.xo then
					v.cursor = v.xo
				elseif v.cursor > v.xf then
					v.cursor = v.xf
				end
			else
				v.held = false
			end
		end
	end
end

function Slider:touchmoved(id,tx,ty)
	for i,v in ipairs(__sliders) do
		if v.held then
			v.cursor = tx
			if v.cursor < v.xo then
				v.cursor = v.xo
			elseif v.cursor > v.xf then
				v.cursor = v.xf
			end
		end
	end
end

function Slider:touchreleased(id,tx,ty)
	for i,v in ipairs(__sliders) do
		if v.held then
			v.held = false
		end
	end
end

return Slider
