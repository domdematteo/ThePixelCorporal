--[[
    The Pixel Corporal, or "La Pixel Corporel"

    By Domenick DeMatteo

--TO Dos:
    - ******* need to fix self unit blocking. Units should be able to move to a space a firendly unit is moving out of

    GITHUB TEST


]]

--=============== Libraries =============
local unitsLib = require 'lib/units'

local push = require 'lib/push'

math.randomseed(os.time())

--================Assets ================
local titleFont = love.graphics.newFont('fonts/AustraliaCustom.ttf', 36)
local buttonfont = love.graphics.newFont('fonts/basicscript.otf', 48)

--Units

local unitTestImg = love.graphics.newImage('graphics/testunit.png')
local unitTestImgP2 = love.graphics.newImage('graphics/redtestunit.png')
local blueGeneralImg = love.graphics.newImage('graphics/bluegeneral.png')
local redGeneralImg = love.graphics.newImage('graphics/redgeneral.png')


--Background
local backgroundimg = love.graphics.newImage("graphics/background1.png")

--Arrows
local arrow1 = love.graphics.newImage("graphics/arrow1.png")
local arrow2 = love.graphics.newImage("graphics/arrow2.png")
local arrow3 = love.graphics.newImage("graphics/arrow3.png")

function randdomArrow()
local arrowoptions = {arrow1, arrow2, arrow3}
arrowseed = math.random(3)
return arrowoptions[arrowseed]
end

--Board Tiles
local numforest = 5
local forest1 = love.graphics.newImage('graphics/forest1.png')
local forest2 = love.graphics.newImage('graphics/forest2.png')
local forest3 = love.graphics.newImage('graphics/forest3.png')
local forest4 = love.graphics.newImage('graphics/forest4.png')
local forest5 = love.graphics.newImage('graphics/forest5.png')
local forestoptions = {forest1, forest2, forest3, forest4, forest5}

local numplains = 3
local plains1 = love.graphics.newImage('graphics/plains1.png')
local plains2 = love.graphics.newImage('graphics/plains2.png')
local plains3 = love.graphics.newImage('graphics/plains3.png')
local plainoptions = {plains1, plains2, plains3, forest4}

-- =========== Constants ==============

    --Visual
WINDOW_WIDTH = 1408
WINDOW_HEIGHT = 1408

VIRTUAL_WIDTH = 1280
VIRTUAL_HEIGHT = 1280

BoardTileSize = 70
TileScaleX = 1.3
TileScaleY = 1.3

BoardHeight = 10
BoardWidth = 10

local xMargin = (VIRTUAL_WIDTH - (BoardTileSize * BoardWidth)) / 4
local yMargin = (VIRTUAL_HEIGHT - (BoardTileSize * BoardHeight)) / 8

    --Gameplay

--========= Data Structures ===============

--Generate Board
--Board is data structure that keeps track of all game information
Board = {}

--Generate empty board grid

for x = 1, BoardWidth do
    Board[x] = {}

    for y =1, BoardHeight do
        Board[x][y] = {}
        Board[x][y].terrain = ''
        Board[x][y].unit = nil
        Board[x][y].clicked = false
        --Gives starting x and y pixel coordinates for this square
        Board[x][y].startx = xMargin + ((x - 1)* BoardTileSize)
        Board[x][y].starty = yMargin + ((y - 1)* BoardTileSize)
    end
end

--Test 10x10 map
--Map is a simple data structure to store terrain layout, will be mapped to the board
--Would be cool to auto generate this
mapheight = 10
mapwidth = 10

map = {
    {"f", "f", "p", "p", "p", "f", 'p', 'f', 'p', 'p'},
    {"p", "p", "f", "p", "f", "f", 'p', 'f', 'p', 'p'},
    {"f", "f", "p", "p", "f", "p", 'f', 'p', 'f', 'f'},
    {"p", "p", "p", "f", "p", "f", 'p', 'p', 'f', 'f'},
    {"p", "p", "p", "f", "p", "p", 'f', 'f', 'p', 'p'},
    {"p", "f", "p", "p", "p", "f", 'p', 'p', 'p', 'p'},
    {"f", "f", "p", "p", "f", "p", 'p', 'f', 'p', 'p'},
    {"f", "f", "p", "p", "f", "p", 'f', 'p', 'f', 'p'},
    {"f", "f", "p", "p", "p", "f", 'p', 'f', 'p', 'f'},
    {"f", "f", "p", "p", "p", "f", 'p', 'f', 'p', 'p'}
}

--Players
playerCount = 2
currentPlayer = 1
players = {1, 2}
gameOver = false
loser = false
winner = false


function nextTurn()
    if currentPlayer < playerCount then
        currentPlayer = currentPlayer + 1
    else currentPlayer = currentPlayer - 1
    end
    print("It is player " .. currentPlayer .. " 's turn")
end


--Units
function tablelength(T)
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
end



--Units testing
unitSelected = nil
maxMoveRange = 2

testunit1 = {}
testunit1.isalive = true
--testunit1.iselected = false
testunit1.name='testunit1'
testunit1.player=1
testunit1.type= 'infantry'
testunit1.moveRange = 2
testunit1.class= 1
testunit1.posX= 5
testunit1.posY= 5
testunit1.pixstartX = xMargin + ((testunit1.posX - 1)* BoardTileSize)
testunit1.pixstartY = yMargin + ((testunit1.posY - 1)* BoardTileSize)
testunit1.nextposX= nil
testunit1.nextposY= nil
testunit1.finalposX= nil
testunit1.finalposY= nil
testunit1.icon = unitTestImg
testunit1.arrow = randdomArrow()

testunit2 = {}
testunit2.isalive = true
--testunit2.iselected = false
testunit2.name='testunit2'
testunit2.player=1
testunit2.type= 'infantry'
testunit2.moveRange = 2
testunit2.class= 1
testunit2.posX= 3
testunit2.posY= 3
testunit2.pixstartX = xMargin + ((testunit2.posX - 1)* BoardTileSize)
testunit2.pixstartY = yMargin + ((testunit2.posY - 1)* BoardTileSize)
testunit2.nextposX=  nil
testunit2.nextposY= nil
testunit2.finalposX= nil
testunit2.finalposY= nil
testunit2.icon = unitTestImg
testunit2.arrow = randdomArrow()

testunit3 = {}
testunit3.isalive = true
--testunit3.iselected = false
testunit3.name='testunit3'
testunit3.player=2
testunit3.type='infantry'
testunit3.moveRange = 2
testunit3.class = 2
testunit3.posX= 7
testunit3.posY= 7
testunit3.pixstartX = xMargin + ((testunit3.posX - 1)* BoardTileSize)
testunit3.pixstartY = yMargin + ((testunit3.posY - 1)* BoardTileSize)
testunit3.nextposX=  nil
testunit3.nextposY=  nil
testunit3.finalposX= nil
testunit3.finalposY= nil
testunit3.icon = unitTestImgP2
testunit3.arrow = randdomArrow()

bluegeneral = {}
bluegeneral.isalive = true
--testunit1.iselected = false
bluegeneral.name='bluegeneral'
bluegeneral.player=1
bluegeneral.type= 'general'
bluegeneral.moveRange = 1
bluegeneral.class= 1
bluegeneral.posX= 4
bluegeneral.posY= 4
bluegeneral.pixstartX = xMargin + ((testunit1.posX - 1)* BoardTileSize)
bluegeneral.pixstartY = yMargin + ((testunit1.posY - 1)* BoardTileSize)
bluegeneral.nextposX= nil
bluegeneral.nextposY= nil
bluegeneral.icon = blueGeneralImg
bluegeneral.arrow = randdomArrow()

redgeneral = {}
redgeneral.isalive = true
--testunit1.iselected = false
redgeneral.name='redgeneral'
redgeneral.player=2
redgeneral.type = 'general'
redgeneral.moveRange = 1
redgeneral.class= 1
redgeneral.posX= 8
redgeneral.posY= 8
redgeneral.pixstartX = xMargin + ((testunit1.posX - 1)* BoardTileSize)
redgeneral.pixstartY = yMargin + ((testunit1.posY - 1)* BoardTileSize)
redgeneral.nextposX= nil
redgeneral.nextposY= nil
redgeneral.icon = redGeneralImg
redgeneral.arrow = randdomArrow()

unitlist = {testunit1, testunit2, testunit3, bluegeneral, redgeneral}

unitlistsize = tablelength(unitlist)

--[[
Board[4][4].unit = bluegeneral
Board[5][5].unit = testunit1
Board[3][3].unit = testunit2
Board[7][7].unit = testunit3
Board[8][8].unit = redgeneral ]]


--========== Gameplay Loop ===============

function love.load()

    --Graphics setup
    love.graphics.setDefaultFilter('nearest','nearest')
    love.graphics.setFont(titleFont)

    love.window.setTitle('Le Pixel Corporel')

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT,{
        fullscreen = false,
        vsync = true,
        resizable = true
    })


    --Generate random map graphics so they are rendered statically
    mapgraphics = map
    for x=1, mapwidth do 
        for y=1, mapheight do
            if mapgraphics[x][y] == 'f' then
                mapgraphics[x][y] = randomForest()

            else
                mapgraphics[x][y] = randomPlains()
            end
        end
    end

    --Initialize Board Data
    for i = 1, unitlistsize do
        Board[unitlist[i].posX][unitlist[i].posY].unit = unitlist[i]
    end

end

--easy escape for testing
function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end





function love.update(dt)

    



end


function love.draw()
    
    
    drawBackground()

    drawBoard()

    drawConfirmButton()

    drawCancelButton()

    drawUnits1()

    drawMoveOptions1()

    drawNextMoveOptions()

    drawArrows()

    checkGenerals()

    DrawEndState()

    

    
    
    
end



--=========== Functions =============================

-- Create the "Click Map"
function love.mousepressed(clickx, clicky, button)
    --Click a unit, highlight show its available moves, click unit again to deselect
    --Listen for clicks on all board squares
    for x = 1, BoardWidth do
        for y=1, BoardHeight do
            if button == 1 then
                if clickx >= Board[x][y].startx and clickx <= Board[x][y].startx + BoardTileSize and clicky >= Board[x][y].starty and clicky <= Board[x][y].starty + BoardTileSize then
                        --if left mouse button pressed and the mouse is within the size of the tile 

                        --Check to see if it has a unit
                        if Board[x][y].unit ~= nil and Board[x][y].unit.player == currentPlayer then
                            --If board square does have a unit
                            if unitSelected == nil then
                                --Select that unit, acknowlege board click
                                unitSelected = Board[x][y].unit

                            elseif unitSelected ~= nil and unitSelected.nextposX == nil then
                                --Deselect that unit, acknowlege second board click
                                unitSelected = nil

                           elseif unitSelected ~= nil and unitSelected.nextposX ~= nil then
                                --If you have selected a unit, and it already has a move order, but you click that unit again.....
                                if unitSelected.moveRange > 1 then
                                    --Edge case if you want to move a unit forward and back in one turn.
                                    unitSelected.finalposX = x
                                    unitSelected.finalposY = y
                                    unitSelected = nil
                                else if unitSelected.moveRange == 1 then
                                    --Needs to allow you to deselect general
                                    unitSelected = nil
                                end
                            end

                           elseif unitSelected ~= nil and unitSelected.finalposX ~= nil and unitSelected.moveRange > 1 then
                                --Allow re-casting of second move
                            unitSelected.finalposX = x
                            unitSelected.finalposY = y
                            unitSelected = nil
                            end

                        else
                           --if we click on a space that doesn't have a unit... 
                                if unitSelected ~= nil and unitSelected.nextposX == x and unitSelected.nextposY == y then
                                    --if you click on the space that the unit is planning on moving to, deselect that unit
                                    unitSelected = nil


                                

                                elseif unitSelected ~= nil and inMoveRange(unitSelected, x, y) == true and unitSelected.nextposX == nil then
                                    --but a unit has been selected, and clicked square is in units movement range
                                    --Board[x][y].unit = unitSelected
                                    --Board[unitSelected.posX][unitSelected.posY].unit = nil
                                    --Board[unitSelected.posX][unitSelected.posY].clicked = false
                                    unitSelected.nextposX = x
                                    unitSelected.nextposY = y
                                    unitSelected.pixstartX = calcStartPixX(unitSelected)
                                    unitSelected.pixstartY = calcStartPixY(unitSelected)
                                    --Board[unitSelected.nextposX][unitSelected.nextposY].unit = unitSelected
                            
                                    unitSelected = nil
                               

                                elseif unitSelected ~= nil and inNextMoveRange(unitSelected, x, y) == true and unitSelected.nextposX ~= nil and unitSelected.moveRange > 1 then
                                    --but a unit has been selected, and clicked square is in units movement range
                                    --Board[x][y].unit = unitSelected
                                    --Board[unitSelected.posX][unitSelected.posY].unit = nil
                                    --Board[unitSelected.posX][unitSelected.posY].clicked = false
                                    unitSelected.finalposX = x
                                    unitSelected.finalposY = y
                                    --unitSelected.pixstartX = calcStartPixX(unitSelected)
                                    --unitSelected.pixstartY = calcStartPixY(unitSelected)
                                    --Board[unitSelected.nextposX][unitSelected.nextposY].unit = unitSelected
                            
                                    unitSelected = nil
                                
                                else
                                    unitSelected = nil
                                end
                            
                        end
                end
            end
        end
    end

    --Would to allow 2nd movement by clicking space that unit is moving to

    --If submit orders button is pressed:
    if clickx >= Board[BoardWidth/2][BoardHeight].startx + BoardTileSize/6 and clickx <= Board[BoardWidth/2][BoardHeight].startx + BoardTileSize/6 + 200 and clicky>= Board[BoardWidth/2][BoardHeight].starty + BoardTileSize and clicky <= Board[BoardWidth/2][BoardHeight].starty + BoardTileSize + 200/3 then
        --If it is player one's turn, we simply store those moves, and let player 2 make theirs
        --If it is player 2's turn, then we have to determine outcomes
            unitSelected = nil
        if currentPlayer == 2 then
            calculateMoves()
            nextTurn()
            unitSelected = nil
        else nextTurn()
            unitSelected = nil
        end
    end

    --If cancel orders button is pressed:
    if clickx >= cancelButtonStartX and clickx <= cancelButtonStartX + cancelButtonSizeX and clicky >= cancelButtonStartY and clicky <= cancelButtonStartY + cancelButtonSizeY then
        print("You clicked the cancel button!!!!!!!!")
        if unitSelected ~= nil then
            unitSelected.nextposX  = nil
            unitSelected.nextposY = nil
            unitSelected.finalposX = nil
            unitSelected.finalposY = nil
            unitSelected = nil
        end
    end


end


function drawBackground()
    --Draws old-timey map background
    --Get background image size and window size, scale background accordingly
        local backwidth = backgroundimg:getWidth()
        local backheight = backgroundimg:getHeight()
        local width, height = love.window.getMode( )
        local winwidth, winheight = width, height
        local sx = winwidth / backwidth
        local sy = winheight / backheight
        love.graphics.draw(backgroundimg,1, 1, 0, sx, sy)
        love.graphics.setColor(0,0,0)
        love.graphics.print("Le Pixel Corporel")
        love.graphics.setColor(1,1,1)
    
end


function drawBoard(randseed)
    --Draws tiles for the game board

    --Load map graphics info (generated in love.load)
    local currentmap = mapgraphics

    for x = 1, mapwidth do
        for y = 1, mapheight do

         love.graphics.draw(currentmap[x][y], (xMargin + ((x - 1)* BoardTileSize)), (yMargin + ((y - 1)* BoardTileSize)), 0, TileScaleX, TileScaleY) 

        end
    end
end


function randomForest()
    local seed = math.random(numforest)
    
    for i =1, numforest do
        if seed == i then
            return forestoptions[i]
        end
    end
end

function randomPlains()
    local seed = math.random(numplains)
    
    for i =1, numplains do
        if seed == i then
            return plainoptions[i]
        end
    end
end


function drawUnits()
    for x = 1, BoardWidth do
        for y = 1, BoardHeight do
            if Board[x][y].unit ~= nil then
                love.graphics.draw(Board[x][y].unit.icon, (xMargin + ((x - 1)* BoardTileSize)) + (BoardTileSize/10), (yMargin + ((y - 1)* BoardTileSize) + (BoardTileSize/4)), 0, .8, .8) 
            end
        end
    end
end 

--Remade this to be entirely unit based

function drawUnits1()
    for i=1, unitlistsize do
        if unitlist[i].isalive == true and unitlist[i].posX ~= nil and unitlist[i].posY ~= nil then
            love.graphics.draw(unitlist[i].icon, (xMargin + ((unitlist[i].posX - 1)* BoardTileSize)) + (BoardTileSize/10), (yMargin + ((unitlist[i].posY - 1)* BoardTileSize) + (BoardTileSize/4)), 0, .8, .8) 
        end
    end
end

function drawArrows()
    --check if a unit has been given move orders
    for i=1, unitlistsize do
        if unitlist[i].nextposX ~= nil then
            -- Determine movement direction in radians. 
            local movedirection = 0
            --move left
            if unitlist[i].nextposX < unitlist[i].posX then
                movedirection = 3.14159
                love.graphics.draw(unitlist[i].arrow, (xMargin + ((unitlist[i].posX - 1)* BoardTileSize)) + (BoardTileSize/3), (yMargin + ((unitlist[i].posY - 1)* BoardTileSize) + (BoardTileSize/1.3)), movedirection, .8, .8) 
            --move right
            elseif unitlist[i].nextposX > unitlist[i].posX then
                movedirection = 0
                love.graphics.draw(unitlist[i].arrow, (xMargin + ((unitlist[i].posX - 1)* BoardTileSize)) + (BoardTileSize/2), (yMargin + ((unitlist[i].posY - 1)* BoardTileSize) + (BoardTileSize/5.5)), movedirection, .8, .8) 

            --move down
            elseif unitlist[i].nextposY > unitlist[i].posY then
                movedirection = 1.57079
                love.graphics.draw(unitlist[i].arrow, (xMargin + ((unitlist[i].posX - 1)* BoardTileSize)) + (BoardTileSize/1.3), (yMargin + ((unitlist[i].posY - 1)* BoardTileSize) + (BoardTileSize/2.2)), movedirection, .8, .8) 

            else movedirection = 4.71238
                love.graphics.draw(unitlist[i].arrow, (xMargin + ((unitlist[i].posX - 1)* BoardTileSize)) + (BoardTileSize/5), (yMargin + ((unitlist[i].posY - 1)* BoardTileSize) + (BoardTileSize/3.5)), movedirection, .8, .8) 

            end
            
            --if it has, draw and arrow representing that move
            
        end
    end
    --Draw arrows for second moves
    for i=1, unitlistsize do
        if unitlist[i].finalposX ~= nil and unitlist[i].nextposX ~= nil then
            -- Determine movement direction in radians. 
            local movedirection = 0
            --move left
            if unitlist[i].finalposX < unitlist[i].nextposX then
                movedirection = 3.14159
                love.graphics.draw(unitlist[i].arrow, (xMargin + ((unitlist[i].nextposX - 1)* BoardTileSize)) + (BoardTileSize/3), (yMargin + ((unitlist[i].nextposY - 1)* BoardTileSize) + (BoardTileSize/1.3)), movedirection, .8, .8) 
            --move right
            elseif unitlist[i].finalposX > unitlist[i].nextposX then
                movedirection = 0
                love.graphics.draw(unitlist[i].arrow, (xMargin + ((unitlist[i].nextposX - 1)* BoardTileSize)) + (BoardTileSize/2), (yMargin + ((unitlist[i].nextposY - 1)* BoardTileSize) + (BoardTileSize/5.5)), movedirection, .8, .8) 

            --move down
            elseif unitlist[i].finalposY > unitlist[i].nextposY then
                movedirection = 1.57079
                love.graphics.draw(unitlist[i].arrow, (xMargin + ((unitlist[i].nextposX - 1)* BoardTileSize)) + (BoardTileSize/1.3), (yMargin + ((unitlist[i].nextposY - 1)* BoardTileSize) + (BoardTileSize/2.2)), movedirection, .8, .8) 

            else movedirection = 4.71238
                love.graphics.draw(unitlist[i].arrow, (xMargin + ((unitlist[i].nextposX - 1)* BoardTileSize)) + (BoardTileSize/5), (yMargin + ((unitlist[i].nextposY - 1)* BoardTileSize) + (BoardTileSize/3.5)), movedirection, .8, .8) 

            end
            
        end
    end
end

--=========== Calculating moves and combat ===========

function calculateMoves()

    for h = 1, maxMoveRange do
        for i =1, unitlistsize do
            if (unitlist[i].nextposX ~= nil and unitlist[i].nextposX ~= nil) and unitlist[i].isalive == true then
                --for all units, if that movement has a nextpos (ie, it was given a move order)
                for j=1, unitlistsize do
                    --check for moveconflicts, and execute combat to resolve
                    if unitlist[i] ~= unitlist[j] and unitlist[j].isalive == true then
                        if (unitlist[i].nextposX == unitlist[j].nextposX and unitlist[i].nextposY == unitlist[j].nextposY) or (unitlist[i].nextposX == unitlist[j].posX and unitlist[i].nextposY == unitlist[j].posY) then
                            if unitlist[i].player == unitlist[j].player then
                                --If units are on the same side, don't allow move to go through 
                                unitlist[i].nextposX = unitlist[i].posX
                                unitlist[i].nextposY = unitlist[i].posY

                            else 
                                winner = unitCombat(unitlist[i], unitlist[j])
                                Board[winner.nextposX][winner.nextposY].unit = winner
                                print("ANd the winner isssss......")
                                print(winner.name)
                            
                            end
                            --[[if winner ~= nil then
                                Board[winner.posX][winner.posY].unit = nil
                                Board[winner.posX][winner.posY].unit = nil
                                Board[winner.nextposX][winner.nextposY].unit = winner
                                Board[winner.nextposX][winner.nextposY].unit = winner
                                winner.posX = winner.nextposX
                                winner.posY = winner.nextposY
                                winner.nextposX = nil
                                winner.nextposY = nil
                            end]]
                        end
                        
                    end
                end

                if unitlist[i].isalive == true then
                    print("moving this unit now........")
                    print(unitlist[i].name)
                    print(unitlist[i].posX)
                    print(unitlist[i].posY)
                    Board[unitlist[i].posX][unitlist[i].posY].unit = nil
                    Board[unitlist[i].nextposX][unitlist[i].nextposY].unit = unitlist[i]
                    unitlist[i].posX = unitlist[i].nextposX
                    unitlist[i].posY = unitlist[i].nextposY

                    --If unit has no other moves, set nextpos to zero
                    if unitlist[i].finalposX == nil then
                        unitlist[i].nextposX = nil
                        unitlist[i].nextposY = nil

                    --otherwise, queue up final moves to next moves
                    else
                        unitlist[i].nextposX = unitlist[i].finalposX
                        unitlist[i].nextposY = unitlist[i].finalposY

                        unitlist[i].finalposX = nil
                        unitlist[i].finalposY = nil
                    end
                end
            end
        end
    end
--For debugging.....
    for x = 1, BoardWidth do
        for y =1, BoardHeight do
            if Board[x][y].unit ~= nil then
                print("There is a unit stored at" .. x .. ', ' ..y.. ')')
                print("It is called " ..Board[x][y].unit.name)
            end
        end
    end

    for i =1, unitlistsize do
        local isalive = ''
        if unitlist[i].isalive == true then
            isalive = 'alive'
        else
            isalive = 'destroyed'
        end
        print("Unit:" ..unitlist[i].name.. " and it is " ..isalive)
    end

end




--========= Calculating Combat ===========
function unitCombat(unit1, unit2)

    print('combat underway')

    --Returns winner of combat, removes losers

    --Check if units are friendlies, if so, there is no combat
    if unit1.player == unit2.player then
        return unit1, unit2
    end
    --Anything vs general
    if unit1.type == 'general' or unit2.type == 'general' then
        if unit1.type == 'general' then
            removeCasualties(unit1)
            return unit2
        else 
            removeCasualties(unit2)
            return unit1
        end

    end
    

    --Infantry vs infantry
    if unit1.type == 'infantry' and unit2.type == 'infantry' then
        --identical units removed
        if unit1.class == unit2.class then
            print("Combat is a draw")
            removeCasualties(unit1)
            removeCasualties(unit2)
            return nil
        elseif unit1.class == 3 and unit2.class == 1 then
            removeCasualties(unit2)
            return unit1
        elseif unit1.class == 1 and unit2.class == 3 then
            removeCasualties(unit1)
            return unit2    
        elseif unit1.class < unit2.class then
            print("unit 1 wins")
            removeCasualties(unit2)
            return unit1
        else 
            print("unit 2 wins")
            removeCasualties(unit1)
            return unit2
        end
    end
end



--======= Remove Casualties =========
function removeCasualties(unit)
    --Remove unit from board
    Board[unit.posX][unit.posY].unit = nil
    --Remove unit from unit list
    for i=1, unitlistsize do
        if unitlist[i] == unit then
            unitlist[i].isalive = false
            unitlist[i].posX = nil
            unitlist[i].posY = nil
            unitlist[i].nextposX = nil
            unitlist[i].nextposY = nil
        end
    end

end

--=== Check if any generals have been taken ========
function checkGenerals()
    for i=1, unitlistsize do
        if unitlist[i].type == 'general' and unitlist[i].isalive == false then
            gameOver = true
            loser = unitlist[i].player
            table.remove(players, loser)
            winner = players[1]
        end
    end
end

function drawMoveOptions()
    --Check to see if square has been clicked to draw movement options
        for x = 1, BoardWidth do
            for y=1, BoardHeight do
                if Board[x][y].unit ~= nil and unitSelected ~= nil then
                    --Highlight unit as yellow
                    love.graphics.setColor(0.98,0.854, 0.368, 0.5)
                    love.graphics.rectangle('fill',Board[x][y].startx, Board[x][y].starty, BoardTileSize, BoardTileSize)
                    --Set potential moves as green
                    love.graphics.setColor(0,1,0, 0.5)
                    --Move Up
                    if y > 1 then
                        love.graphics.rectangle('fill',Board[x][y - 1].startx, Board[x][y - 1].starty, BoardTileSize, BoardTileSize)
                    end
                    --Move Down
                    if y < BoardHeight then
                        love.graphics.rectangle('fill',Board[x][y + 1].startx, Board[x][y + 1].starty, BoardTileSize, BoardTileSize)
                    end
                    --Move Left
                    if x > 1 then
                        love.graphics.rectangle('fill',Board[x - 1][y].startx, Board[x - 1][y].starty, BoardTileSize, BoardTileSize)
                    end
                    --Move Right
                    if x < BoardWidth then
                        love.graphics.rectangle('fill',Board[x + 1][y].startx, Board[x + 1][y].starty, BoardTileSize, BoardTileSize)
                    end

                    love.graphics.setColor(1, 1, 1)
                end

            end
        end
end

function  drawNextMoveOptions()
    if unitSelected ~= nil and unitSelected.nextposX ~= nil and unitSelected.moveRange > 1 then
        --Highlight space unit's first move is as yellow
        love.graphics.setColor(0.98,0.854, 0.368, 0.5)
        love.graphics.rectangle('fill', Board[unitSelected.nextposX][unitSelected.nextposY].startx, Board[unitSelected.nextposX][unitSelected.nextposY].starty, BoardTileSize, BoardTileSize)
        --Set potential moves as green
        love.graphics.setColor(0,1,0, 0.5)
        --Move Up
        if unitSelected.posY > 1 then
            love.graphics.rectangle('fill', Board[unitSelected.nextposX][unitSelected.nextposY - 1].startx, Board[unitSelected.nextposX][unitSelected.nextposY - 1].starty, BoardTileSize, BoardTileSize)
        end
        --Move Down
        if unitSelected.posY < BoardHeight then
            love.graphics.rectangle('fill',Board[unitSelected.nextposX][unitSelected.nextposY + 1].startx, Board[unitSelected.nextposX][unitSelected.nextposY + 1].starty, BoardTileSize, BoardTileSize)
        end
        --Move Left
        if unitSelected.posX > 1 then
            love.graphics.rectangle('fill',Board[unitSelected.nextposX - 1][unitSelected.nextposY].startx, Board[unitSelected.nextposX - 1][unitSelected.nextposY].starty, BoardTileSize, BoardTileSize)
        end
        --Move Right
        if unitSelected.posX < BoardWidth then
            love.graphics.rectangle('fill', Board[unitSelected.nextposX + 1][unitSelected.nextposY].startx, Board[unitSelected.nextposX + 1][unitSelected.nextposY].starty, BoardTileSize, BoardTileSize)
        end

        love.graphics.setColor(1, 1, 1)
   end

end


function drawMoveOptions1()
    if unitSelected ~= nil and (unitSelected.nextposX == nil or unitSelected.moveRange == 1) then
         --Highlight unit as yellow
         love.graphics.setColor(0.98,0.854, 0.368, 0.5)
         love.graphics.rectangle('fill', Board[unitSelected.posX][unitSelected.posY].startx, Board[unitSelected.posX][unitSelected.posY].starty, BoardTileSize, BoardTileSize)
         --Set potential moves as green
         love.graphics.setColor(0,1,0, 0.5)
         --Move Up
         if unitSelected.posY > 1 then
             love.graphics.rectangle('fill', Board[unitSelected.posX][unitSelected.posY - 1].startx, Board[unitSelected.posX][unitSelected.posY - 1].starty, BoardTileSize, BoardTileSize)
         end
         --Move Down
         if unitSelected.posY < BoardHeight then
             love.graphics.rectangle('fill',Board[unitSelected.posX][unitSelected.posY + 1].startx, Board[unitSelected.posX][unitSelected.posY + 1].starty, BoardTileSize, BoardTileSize)
         end
         --Move Left
         if unitSelected.posX > 1 then
             love.graphics.rectangle('fill',Board[unitSelected.posX - 1][unitSelected.posY].startx, Board[unitSelected.posX - 1][unitSelected.posY].starty, BoardTileSize, BoardTileSize)
         end
         --Move Right
         if unitSelected.posX < BoardWidth then
             love.graphics.rectangle('fill', Board[unitSelected.posX + 1][unitSelected.posY].startx, Board[unitSelected.posX + 1][unitSelected.posY].starty, BoardTileSize, BoardTileSize)
         end

         love.graphics.setColor(1, 1, 1)
    end
end

function drawConfirmButton()
    local buttonsize = 200
    love.graphics.setColor(0.98,0.854, 0.368)
    love.graphics.rectangle('fill', Board[BoardWidth/2][BoardHeight].startx + BoardTileSize/6, Board[BoardWidth/2][BoardHeight].starty + BoardTileSize, buttonsize, buttonsize/3)
    love.graphics.setColor(0,0,0)
    love.graphics.setLineWidth(3)
    love.graphics.rectangle('line', Board[BoardWidth/2][BoardHeight].startx + BoardTileSize/6, Board[BoardWidth/2][BoardHeight].starty + BoardTileSize, buttonsize, buttonsize/3)
    
    love.graphics.setColor(0,0,0)
    love.graphics.setFont(buttonfont)
    love.graphics.print("Submit Orders",  Board[BoardWidth/2][BoardHeight].startx + BoardTileSize/4.5 , Board[BoardWidth/2][BoardHeight].starty + BoardTileSize + 5)
    love.graphics.setFont(titleFont)
    love.graphics.setColor(1,1,1)
end

function drawCancelButton()
    cancelButtonSizeX = 400
    cancelButtonSizeY = (400/6)
    cancelButtonStartX =  Board[3][BoardHeight].startx + BoardTileSize
    cancelButtonStartY = Board[BoardWidth/2][BoardHeight].starty + BoardTileSize * 2

    love.graphics.setColor(1,0, 0)
    love.graphics.rectangle('fill', cancelButtonStartX, cancelButtonStartY,cancelButtonSizeX, cancelButtonSizeY)
    love.graphics.setColor(0,0,0)
    love.graphics.setLineWidth(3)
    love.graphics.rectangle('line',cancelButtonStartX, cancelButtonStartY, cancelButtonSizeX, cancelButtonSizeY)
    
    love.graphics.setColor(0,0,0)
    love.graphics.setFont(buttonfont)
    love.graphics.print("Cancel This Unit's Orders",  Board[4][BoardHeight].startx + BoardTileSize/8 , Board[BoardWidth/2][BoardHeight].starty + BoardTileSize * 2 + 5)
    love.graphics.setFont(titleFont)
    love.graphics.setColor(1,1,1)
end

function calcStartPixX(unit)
    return (xMargin + ((unit.posX - 1)* BoardTileSize))
end

function calcStartPixY(unit)
    return (yMargin + ((unit.posY - 1)* BoardTileSize))
end

--needs fixing for diagonals
function inMoveRange(unit, x, y)
--Given a unit and a coordinate, see if that coordinate is in the units movemnt range
    if x == unit.posX then
       if y== unit.posY + 1 or y == unit.posY - 1 then
       return true
       end
    
    elseif y == unit.posY then
        if x == unit.posX + 1 or x == unit.posX - 1 then
        return true
        end
    else return false
    end
end

function inNextMoveRange(unit, x, y)
    --Given a unit and a coordinate, see if that coordinate is in the units movemnt range
        if x == unit.nextposX then
           if y== unit.nextposY + 1 or y == unit.nextposY - 1 then
           return true
           end
        
        elseif y == unit.nextposY then
            if x == unit.nextposX + 1 or x == unit.nextposX - 1 then
            return true
            end
        else return false
        end
    end




function DrawEndState()
    if gameOver == true then
        local buttonsize = 600
        love.graphics.setColor(0.98,0.854, 0.368)
        love.graphics.rectangle('fill', WINDOW_WIDTH/4 ,WINDOW_HEIGHT/4, buttonsize, buttonsize/3)
        love.graphics.setColor(0,0,0)
        love.graphics.setLineWidth(3)
        love.graphics.rectangle('line', WINDOW_WIDTH/4, WINDOW_HEIGHT/4, buttonsize, buttonsize/3)
        
        love.graphics.setColor(0,0,0)
        love.graphics.setFont(buttonfont)
        love.graphics.print("Player " .. winner .." is victorious!", WINDOW_WIDTH/3, WINDOW_HEIGHT/3)
        love.graphics.setFont(titleFont)
        love.graphics.setColor(1,1,1)
    end
end