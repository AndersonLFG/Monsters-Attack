
local composer = require( "composer" )

local scene = composer.newScene()
local button

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local function gotoGame()
	composer.gotoScene( "game", { time=800, effect="crossFade" } )
end

local function gotoHighScores()
	composer.gotoScene( "highscores", { time=800, effect="crossFade" } )
end


-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
local function exitGame()
  print("tapped exit button")
  audio.play( selected )
  timer.performWithDelay( 1000,
    function()
      if( system.getInfo("platformName")=="Android" ) then
        native.requestExit()
      else
        os.exit()
      end
    end )
end

local function musicButton()
	audio.play( button )
end

-- create()
function scene:create( event )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen
	--button = audio.loadSound( "button.wav" )

	local background = display.newImageRect( sceneGroup, "bgmenu.png", 341, 640 )
	background.x = display.contentCenterX
	background.y = display.contentCenterY

	--local title = display.newImageRect( sceneGroup, "title.png", 500, 80 )
	--title.x = display.contentCenterX
	--title.y = 200

	local playButton = display.newImageRect( sceneGroup, "button_jogar.png", 107, 40 )
	playButton.x = display.contentCenterX
	playButton.y = 150
	--musicButton()

	--playButton:setFillColor( 0.82, 0.86, 1 )

	local highScoresButton = display.newImageRect( sceneGroup, "button_recordes.png", 107, 40 )
	highScoresButton.x = display.contentCenterX
	highScoresButton.y = 200
	--musicButton()
	--highScoresButton:setFillColor( 0.75, 0.78, 1 )

	local exitButton = display.newImageRect( sceneGroup, "button_sair.png", 107, 40 )
	exitButton.x = display.contentCenterX
	exitButton.y = 250
	--musicButton

	playButton:addEventListener( "tap", gotoGame )
	highScoresButton:addEventListener( "tap", gotoHighScores )
	exitButton:addEventListener( "tap", exitGame )
	--exitButton:addEventListener( "tap", gotoHighScores )

end

-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen

	end
end


-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)

	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen

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
