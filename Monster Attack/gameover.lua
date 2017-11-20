
local composer = require( "composer" )

local scene = composer.newScene()
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local function gotoGame()
	composer.gotoScene( "game", { time=800, effect="crossFade" } )
end

local function gotoMenu()
	composer.gotoScene( "menu", { time=800, effect="crossFade" } )
end
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen
	local scoreD = composer.getVariable( "finalScore" )    

	local background = display.newImageRect( sceneGroup, "testefund2.png", 335, 600 )
	background.x = display.contentCenterX
	background.y = display.contentCenterY

	--[[local playButton = display.newImageRect( sceneGroup, "butagain.png", 246, 40 )
	playButton.x = display.contentCenterX
	playButton.y = 150]]

	local menuButton = display.newImageRect( sceneGroup, "button_menu.png", 103, 40 )
	menuButton.x = display.contentCenterX
	menuButton.y = 240

	--playButton:addEventListener( "tap", gotoGame )
	menuButton:addEventListener( "tap", gotoMenu )

	local pontuacao = display.newImageRect( sceneGroup, "buttonp.png", 200, 40 )
	pontuacao.x = display.contentCenterX
	pontuacao.y = 100

	local scoreT = display.newText(sceneGroup, "Pontos:" .. scoreD, 140, 100, "Calibri.ttf", 35 )
	scoreT:setFillColor( 1 )
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
		--scoreT:removeSelf()
        --scoreText = nil
	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen
		composer.removeScene( "gameover" )
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
