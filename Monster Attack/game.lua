-----------------------------------------------------------------------------------------
--
-- game.lua
--
-----------------------------------------------------------------------------------------
local composer = require( "composer")
local widget = require "widget"
local physics = require( "physics" )
local scene = composer.newScene()

display.setStatusBar( display.HiddenStatusBar )
system.activate("multitouch")

physics.start()
physics.setGravity( 0, 0 )

local doLauch = false
local scene = composer.newScene()
local timeCount = 60
local lives = 1
local score = 0
local died = false
local livesText
local scoreText

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

local balloon = display.newImageRect(naveGroup, "cannon.png",89, 99 )
--entre 40 e 280
balloon.x = display.contentCenterX
balloon.y = display.contentCenterY*1.65
physics.addBody( balloon, "static", { radius=40 } )
balloon.alpha = 1.0
balloon.myName = "cannon"

-- Display lives and score
livesText = display.newText( "Lives: " .. lives, 75, -20, native.systemFont, 30 )
scoreText = display.newText( "Score: " .. score, 225, -20, native.systemFont, 30 )

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

local function createAsteroid()

  local newEnemy = display.newImageRect( naveGroup, "creature orange.png", 91, 91 )
  table.insert( monstersTable, newEnemy )
  physics.addBody( newEnemy, "dynamic", { radius=25, bounce=0.0 } )
  newEnemy.myName = "monster"

  local spawnPoint = math.random( 3 )

  if ( spawnPoint == 1 ) then
    -- From the top position 1
    local contentWidth = (display.contentWidth/3)/2
    -- print(contentWidth)
    newEnemy.x = ( display.contentWidth/3)/2
    newEnemy.y = -60
    -- newEnemy:setLinearVelocity( math.random( -40,40 ), math.random( 40,120 ) )
    newEnemy:setLinearVelocity( 0, 100 )
  end
  if ( spawnPoint == 2 ) then
    -- From the top position 1
    newEnemy.x = ( display.contentWidth)/2
    newEnemy.y = -60
    -- newEnemy:setLinearVelocity( math.random( -40,40 ), math.random( 40,120 ) )
    newEnemy:setLinearVelocity( 0, 100 )
  end
  if ( spawnPoint == 3 ) then
    -- From the top position 1
    newEnemy.x = ( display.contentWidth/2 ) + ( display.contentWidth/3)
    newEnemy.y = -60
    -- newEnemy:setLinearVelocity( math.random( -40,40 ), math.random( 40,120 ) )
    newEnemy:setLinearVelocity( 0, 100 )
  end
end

local function gameLoop()
 
    -- Create new asteroid
    createAsteroid()
 
        -- Remove asteroids which have drifted off screen
    for i = #monstersTable, 1, -1 do
        local thisMonster = monstersTable[i]
 
        --if ( thisMonster.x < -100 or
        --     thisMonster.x > display.contentWidth + 100 or
        --     thisMonster.y < -100 or
        --     thisMonster.y > display.contentHeight + 100 )
        --then
        --   display.remove( thisMonster )
        --    table.remove( monstersTable, i )
        --end
    end
end

gameLoopTimer = timer.performWithDelay( 500, gameLoop, 0 )
local function endGame()
    --composer.setVariable( "finalScore", score )
    composer.gotoScene( "menu", { time=800, effect="crossFade" } )
end

local function onCollision( event )
 
    if ( event.phase == "began" ) then
 
        local obj1 = event.object1
        local obj2 = event.object2
 		
        if ( obj1.myName == "monster" and obj2.myName == "platform" or obj1.myName == "platform" and obj2.myName == "monster" )
        then
            -- Remove monster
            display.remove( obj2)
            lives = lives - 1
            composer.gotoScene( "menu")
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
            score = score + 10
            scoreText.text = "Score: " .. score

        elseif ( ( obj1.myName == "cannon" and obj2.myName == "monster" ) or
                 ( obj1.myName == "monster" and obj2.myName == "cannon" ) )
        then
            if ( died == false ) then
                died = true
 
                -- Update lives
                lives = lives - 1
                livesText.text = "Lives: " .. lives
 
                if ( lives ~= 1 ) then
                    display.remove( balloon )
                    timer.performWithDelay( 2000, endGame )
                else
                    balloon.alpha = 0
                    timer.performWithDelay( 1000, restoreCannon )
                end
            end
        end
    end
end

local moveLeft = 0
local moveRight = 0

local touchFunction = function(e)
    
    if e.phase == "began"  then
        if e.target.myName == "Right" then
            moveRight = 10
             balloon.x = balloon.x + moveRight
        else
            moveLeft = -10
            balloon.x = balloon.x + moveLeft
        end
    elseif e.phase == "moved"  then
        if e.target.myName == "Right" then     
            moveRight = 10
             balloon.x = balloon.x + moveRight
        else
            moveLeft = -10
            balloon.x = balloon.x + moveLeft
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

function shoot()
	bullet:setLinearVelocity( 0, -700)
end

local mLeft = widget.newButton {
	
	--label = "Left",
	defaultFile = "button1.png",
	overFile = "button2.png",
	x = display.contentWidth/7, y = display.contentHeight/1,
	width = 80, height = 80,
	onPress = moveLeft
}

local mRight = widget.newButton {
	
	--label = "Right",
	defaultFile = "button1.png",
	overFile = "button2.png",
	x = display.contentWidth/1.17, y = display.contentHeight/1,
	width = 80, height = 80,
	onPress = moveRight
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

function scene:create( event )

    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen

    physics.pause()  -- Temporarily pause the physics engine

    -- Set up display groups
    backGroup = display.newGroup()  -- Display group for the background image
    sceneGroup:insert( backGroup )  -- Insert into the scene's view group

    mainGroup = display.newGroup()  -- Display group for the ship, asteroids, lasers, etc.
    sceneGroup:insert( mainGroup )  -- Insert into the scene's view group

    uiGroup = display.newGroup()    -- Display group for UI objects like the score
    sceneGroup:insert( uiGroup )    -- Insert into the scene's view group
    
end


-- show()
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)

    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
        physics.start()
        Runtime:addEventListener( "collision", onCollision )
        gameLoopTimer = timer.performWithDelay( 500, gameLoop, 0 )
    end
end


-- hide()
function scene:hide( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)
        timer.cancel( gameLoopTimer )

    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen
        Runtime:removeEventListener( "collision", onCollision )
        physics.pause()
        composer.removeScene( "game" )
    end
end

-- destroy()
function scene:destroy( event )

  local sceneGroup = self.view
  -- Code here runs prior to the removal of scene's view

end


-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene