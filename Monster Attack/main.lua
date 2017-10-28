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
physics.setGravity( 0, 0.3 )
--physics.setDrawMode("hybrid")

local doLauch = false
local scene = composer.newScene()
local timeCount = 60
local lives = 3
local score = 0
local died = false
local livesText
local scoreText

-- Display lives and score
livesText = display.newText( "Lives: " .. lives, 200, 80, native.systemFont, 36 )
scoreText = display.newText( "Score: " .. score, 400, 80, native.systemFont, 36 )

local background = display.newImageRect( "castleday.png", 360, 570 )
background.x = display.contentCenterX
background.y = display.contentCenterY

local platform = display.newImageRect( "skullfield.png", 320, 70)
physics.addBody( platform, "static", { bounce=0})
platform.objType = "ground"
platform.myName = "platform"

platform.x = display.contentCenterX
platform.y = display.contentHeight
local naveGroup = display.newGroup()

local balloon = display.newImageRect(naveGroup, "cannon.png", 109, 129 )
--entre 40 e 280
balloon.x = display.contentCenterX
balloon.y = display.contentCenterY*1.65
physics.addBody( balloon, "static", { radius=40 } )
balloon.alpha = 1.0
balloon.myName = "cannon"

function fireLaser()
	local bullet = display.newImageRect(naveGroup, "cannonball.png", 27.6, 27.6 )
	physics.addBody( bullet, "dynamic", { radius=10, { isSensor=true }} )
	bullet.isBullet = true
	bullet.x = balloon.x
	bullet.y = balloon.y
	bullet.myName = "bullet"
	bullet:toBack()

	transition.to(bullet, { y=-40, time=500,
		onComplete = function() display.remove(bullet)
			-- body
		end})
end

local function restoreCannon()
 
    balloon.isBodyActive = false
    balloon.x = display.contentCenterX
    balloon.y = display.contentHeight - 80
 
    -- Fade in the cannon
    transition.to( balloon, { alpha=1, time=4000,
        onComplete = function()
            balloon.isBodyActive = true
            died = false
        end
    } )
end

local monstersTable = {}
local function createMonster()
 
    local newMonster = display.newImageRect( "creature orange.png", 110, 110 )
    table.insert( monstersTable, newMonster )
    physics.addBody( newMonster, "dynamic", { radius=40, bounce=0.1 } )
    newMonster.myName = "monster"
 
    local whereFrom = math.random( 3 )

    if ( whereFrom == 1 ) then
        -- From the left
        newMonster.x = contentCenterX
        newMonster.y = 0
        newMonster:setLinearVelocity( math.random( 40,120 ), math.random( 20,60 ) )
    elseif ( whereFrom == 2 ) then
        -- From the top
        newMonster.x = contentCenterX
        newMonster.y = 0
        newMonster:setLinearVelocity( math.random( -40,40 ), math.random( 40,120 ) )
    elseif ( whereFrom == 3 ) then
        -- From the right
        newMonster.x = math.random( 1, display.contentWidth )
        newMonster.y = 0
        newMonster:setLinearVelocity( math.random( -120,-40 ), math.random( 20,60 ) )
    end
end

local function gameLoop()
 
    -- Create new asteroid
    createMonster()
 
        -- Remove asteroids which have drifted off screen
    for i = #monstersTable, 1, -1 do
        local thisMonster = monstersTable[i]
 
        if ( thisMonster.x < -100 or
             thisMonster.x > display.contentWidth + 100 or
             thisMonster.y < -100 or
             thisMonster.y > display.contentHeight + 100 )
        then
            display.remove( thisMonster )
            table.remove( monstersTable, i )
        end
    end
end

gameLoopTimer = timer.performWithDelay( 500, gameLoop, 0 )

local function onCollision( event )
 
    if ( event.phase == "began" ) then
 
        local obj1 = event.object1
        local obj2 = event.object2
 		
        if ( obj1.myName == "monster" and obj2.myName == "platform" )
        then
            -- Remove monster
            display.remove( obj1 )
        end

        if ( ( obj1.myName == "bullet" and obj2.myName == "monster" ) or
             ( obj1.myName == "monster" and obj2.myName == "bullet" ) )
        then
            -- Remove both the bullet and monster
            display.remove( obj1 )
            display.remove( obj2 )
 
            for i = #monstersTable, 1, -1 do
                if ( monstersTable[i] == obj1 or monstersTable[i] == obj2 ) then
                    table.remove( monstersTable, i )
                    break
                end
            end
 
            -- Increase score
            score = score + 100
            scoreText.text = "Score: " .. score

        elseif ( ( obj1.myName == "cannon" and obj2.myName == "monster" ) or
                 ( obj1.myName == "monster" and obj2.myName == "cannon" ) )
        then
            if ( died == false ) then
                died = true
 
                -- Update lives
                lives = lives - 1
                livesText.text = "Lives: " .. lives
 
                if ( lives == 0 ) then
                    display.remove( balloon )
                else
                    balloon.alpha = 0
                    timer.performWithDelay( 1000, restoreCannon )
                end
            end
        end
    end
end

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

--function shoot()
--	bullet:setLinearVelocity( 0, -700)
--end

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
	onPress = fireLaser,
	
}
Runtime:addEventListener( "collision", onCollision )