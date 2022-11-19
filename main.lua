--[[
    The Pixel Corporal, or "La Pixel Corporel"

    By Domenick DeMatteo

--TO Dos:
    - unit art
    - data structure for units?
    - get units drawn on the screen
    - move a unit
    - assign all units orders
    - process those orders and move all units when "submit orders" is clicked

    GITHUB TEST


]]

--=============== Libraries =============
require 'lepixel.units'

local push = require 'lib/push'

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
local Board = {}

--Generate empty board grid

for x = 1, BoardWidth do
    Board[x] = {}

    for y =1, BoardHeight do
        Board[x][y] = {}
        Board[x][y].terrain = ''
        Board[x][y].unit = ''
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


--========== Gameplay Loop ===============

function love.load()
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


    local testunit = {}
    testunit.isalive = 'yes'
    testunit.name=''
    testunit.player=''
    testunit.type=''
    testunit.class=''
    testunit.lastpos=''
    testunit.nextpos=''
    testunit.icon = unitTestImg

    Board[1][1].unit = testunit
    Board[2][4].unit = testunit
    Board[1][1].unit = testunit
    Board[5][5].unit = testunit
    Board[3][2].unit = testunit




end




function love.draw()
    
    
    drawBackground()

    drawBoard()

    drawUnits()
    





    
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
            if Board[x][y].unit ~= '' then
                love.graphics.draw(Board[x][y].unit.icon, (xMargin + ((x - 1)* BoardTileSize)) + (BoardTileSize/10), (yMargin + ((y - 1)* BoardTileSize) + (BoardTileSize/4)), 0, .8, .8) 
            end
        end
    end
end
