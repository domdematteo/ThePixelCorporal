--[[
    The Pixel Corporal, or "La Pixel Corporel"

    By Domenick DeMatteo

--TO Dos:
    - unit art
    - data structure for units?
    - get units drawn on the screen
    - move a unit
    -make sure only one unit can be selected: should "unitselected" be global?



    - assign all units orders
    - process those orders and move all units when "submit orders" is clicked

    GITHUB TEST


]]

--=============== Libraries =============
local unitsLib = require 'lib/units'

local push = require 'lib/push'

print("HI DOM")

--================Assets ================
local titleFont = love.graphics.newFont('fonts/AustraliaCustom.ttf', 36)

--Units

local unitTestImg = love.graphics.newImage('graphics/testunit.png')


--Background
local backgroundimg = love.graphics.newImage("graphics/background1.png")

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


--Units
function tablelength(T)
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
end

--Units testing
testunit1 = {}
testunit1.isalive = 'yes'
testunit1.iselected = false
testunit1.name=''
testunit1.player=''
testunit1.type=''
testunit1.class=''
testunit1.lastposX= 5
testunit1.lastposY= 5
testunit1.nextposX= ''
testunit1.nextposY= ''
testunit1.icon = unitTestImg

testunit2 = {}
testunit2.isalive = 'yes'
testunit2.iselected = false
testunit2.name=''
testunit2.player=''
testunit2.type=''
testunit2.class=''
testunit2.lastposX= 3
testunit2.lastposY= 3
testunit2.nextposX= ''
testunit2.nextposY= ''
testunit2.icon = unitTestImg

testunit3 = {}
testunit3.isalive = 'yes'
testunit3.iselected = false
testunit3.name=''
testunit3.player=''
testunit3.type=''
testunit3.class=''
testunit3.lastposX= 7
testunit3.lastposY= 7
testunit3.nextposX= ''
testunit3.nextposY= ''
testunit3.icon = unitTestImg

unitlist = {testunit1, testunit2, testunit3}

unitlistsize = tablelength(unitlist)

Board[5][5].unit = testunit1
Board[3][3].unit = testunit2
Board[7][7].unit = testunit3


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

    math.randomseed(os.time())

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


    
end

--easy escape for testing
function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end





function love.update(dt)

    --unitsLib.createClickmap()
    



end


function love.draw()
    
    
    drawBackground()

    drawBoard()

    drawUnits()

    drawMoveOptions()
    
    
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
                        if Board[x][y].unit ~= nil then
                            --If board square does have a unit
                            if Board[x][y].clicked == false then
                                --Select that unit, acknowlege board click
                                Board[x][y].clicked = true
                                Board[x][y].unit.iselected = true
                            else 
                                --Deselect that unit, acknowlege second board click
                                Board[x][y].clicked = false
                                Board[x][y].unit.iselected = false
                            end

                        else
                            for i=1,unitlistsize do
                                if unitlist[i].iselected == true and inMoveRange(unitlist[i], x, y) == true then
                                    --if a unit has been selected, and clicked square is in units movement range
                                    Board[x][y].unit = unitlist[i]
                                    Board[unitlist[i].lastposX][unitlist[i].lastposY].unit = nil
                                    Board[unitlist[i].lastposX][unitlist[i].lastposY].clicked = false
                                    unitlist[i].lastposX = x
                                    unitlist[i].lastposY = y
                                    unitlist[i].iselected = false
                                    
                                end
                            end
                        end
                end
            end
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


function drawBoard()
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

function drawMoveOptions()
    --Check to see if square has been clicked to draw movement options
        for x = 1, BoardWidth do
            for y=1, BoardHeight do
                if Board[x][y].clicked == true then
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

function inMoveRange(unit, x, y)
--Given a unit and a coordinate, see if that coordinate is in the units movemnt range
    if x ~= unit.lastposX + 1 and x ~= unit.lastposX -1 and x ~= unit.lastposX then
        return false
    elseif y ~= unit.lastposY + 1 and y ~= unit.lastposY -1 and y~= unit.lastposY then
        return false
    elseif x == unit.lastposX and y == unit.lastposY then
        return false
    else return true
    end
end
