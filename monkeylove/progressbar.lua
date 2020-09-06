local ProgressBar = {
	_NAME        = "MonkeyLove ProgressBar",
	_VERSION     = 'v1.0',
	_LÖVE        = '11.3',
	_DESCRIPTION = 'ProgressBar multi-purpose for love2d games & apps',
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

local ProgressBar = class('ProgressBar')

local __progressbars = {}

function ProgressBar:initialize(x,y,maxw,h,maxv,minv,text1,text2,font,barColor,fontColor,notFilled,minw)
	self.x = x
	self.y = y
	self.maxW = maxw or love.graphics.getWidth()/2
	self.h = h or love.graphics.getHeight()/8
	self.incW = minw or 0
	self.maxValue = maxv or 100
	self.minValue = minv or 0
	self.value = self.minValue
	self.text1 = text1 or ''
	self.text2 = text2 or ''
	self.text = self.text1 .. self.value .. self.text2
	
	self.font = font or love.graphics.getFont()
	self.barColor = barColor or colors('CYAN')
	self.fontColor = fontColor or colors('BLACK')
	self.notFilledColor = notFilled or colors('LIGHT GRAY',0.5)
	self.disabledColor = grayscale(0.2)
	self.currentColor = self.barColor
	self.currentfontC = self.fontColor
	self.currentNotFilledC = self.notFilledColor
	
	self.paused = false
	
	table.insert(__progressbars,self)
end

function ProgressBar:IncreaseProgress(inc)      
	--Integer greater than 0, between self.minValue and self.maxValue.
	--Only works from a lower value to a higher one.
	--'inc' cant be a negative number.
	if not self.paused then
		local inc = math.floor(inc)
		if inc ~= 0 and inc >= self.minValue and inc <= self.maxValue then
			if self.value < self.maxValue then
				self.value = self.value + inc
				self.incW = self.incW + inc*self.maxW/self.maxValue
				self.text = self.text1 .. self.value .. self.text2
			elseif self.value >= self.maxValue then
				self.value = self.maxValue
				self.incW = self.maxW
				self.text = self.text1 .. self.value .. self.text2
			end
		end
	end
end

function ProgressBar:togglePaused()
	self.paused = not self.paused
	if self.paused then
		self.currentColor = self.disabledColor
		self.currentfontC = colors('WHITE')
		self.currentNotFilledC = self.disabledColor
	else
		self.currentColor = self.barColor
		self.currentfontC = self.fontColor
		self.currentNotFilledC = self.notFilledColor
	end
end

function ProgressBar:draw()
	for i,v in ipairs(__progressbars) do
		love.graphics.setColor(v.currentNotFilledC)
		love.graphics.rectangle("fill",v.x,v.y,v.maxW,v.h)
		love.graphics.setColor(v.currentColor)
		love.graphics.rectangle("fill",v.x,v.y,v.incW,v.h)
		love.graphics.rectangle("line",v.x,v.y,v.maxW,v.h)
		love.graphics.setColor(v.currentfontC)
		setLabel(v.text,v.font,v.x,v.y,v.maxW,v.h,'center')
		love.graphics.setColor(colors('WHITE'))
	end
end

return ProgressBar
