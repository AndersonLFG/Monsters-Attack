-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------
local composer = require( "composer")
local widget = require "widget"
local physics = require( "physics" )

display.setStatusBar( display.HiddenStatusBar )
system.activate("multitouch")

physics.start()
--physics.setGravity( 0, 9.8 )

local doLauch = false
local scene = composer.newScene()
local timeCount = 100

local background = display.newImageRect( "castleday.png", 360, 570 )
background.x = display.contentCenterX
background.y = display.contentCenterY

local platform = display.newImageRect( "skullfield.png", 320, 320 )
platform.x = display.contentCenterX
platform.y = display.contentHeight+100
physics.addBody( platform, "static")

local balloon = display.newImageRect( "cannon.png", 109, 129 )
--entre 40 e 280
balloon.x = display.contentCenterX
balloon.y = display.contentCenterY*1.65
balloon.alpha = 1.0
--physics.addBody( balloon, "static", { radius=50, bounce=0.1 } )

local bullet = display.newImageRect( "cannonball.png", 27.6, 27.6 )
bullet.x = display.contentCenterX
bullet.y = display.contentCenterY + 165
physics.addBody( bullet, "dynamic", { radius=50} )

local badMonster = display.newImageRect( "creature orange.png", 110, 110 )
--entre 40 e 280
badMonster.x = display.contentCenterX --+ 100
badMonster.y = display.contentCenterY - 200
badMonster.alpha = 1.0
physics.addBody( badMonster, "static", { radius=0, bounce=0.1 } )

local naveGroup = display.newGroup()
	naveGroup:insert(balloon)
	naveGroup:insert(bullet)

--local function onCollision( event )
--	if(event.phase == "began") then

--end

function moveLeft()
	if balloon.x > 40 then
		transition.to ( balloon, { time=150, x = balloon.x - 25})
	end
end

function moveRight()
	if balloon.x < 280 then
		transition.to ( balloon, { time=150, x = balloon.x + 25})
	end	
end

function shoot()
	bullet:setLinearVelocity( 0, -700)
end

local mLeft = widget.newButton {
	
	--label = "Left",
	--labelColor = { default={0,100,0}, over={255,215,0} },
	defaultFile = "button1.png",
	overFile = "button2.png",
	x = display.contentWidth/7, y = display.contentHeight/1,
	width = 80, height = 80,
	onPress = moveLeft,
}

local mRight = widget.newButton {
	
	--label = "Right",
	--labelColor = { default={0,100,0}, over={255,215,0} },
	defaultFile = "button1.png",
	overFile = "button2.png",
	x = display.contentWidth/1.17, y = display.contentHeight/1,
	width = 80, height = 80,
	onPress = moveRight,
}

local atirar = widget.newButton {
	
	--label = "Right",
	--labelColor = { default={0,100,0}, over={255,215,0} },
	defaultFile = "atirar.png",
	overFile = "atirar2.png",
	x = display.contentWidth/2, y = display.contentHeight/1,
	width = 90, height = 90,
	onPress = shoot,
}
--atirar:addEventListener("touch", shoot)