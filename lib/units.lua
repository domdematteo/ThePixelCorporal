--[[
    Data Structures for Units and Board
]]



--======= Units ====================

--Unit data structure

--[[
unit = {
    isalive = 'yes',
    name = '',
    player = '',
    type = '',
    class = '',
    lastpos = '',
    nextpos = '',
    icon = ''
}
]]

--List of all units on the board for easy searching

--unitList = {}






--============== Board Section ================================

--for each square of the board, or unit on the board???? create a mousepressed function that listens for that square to be pressed, and executes
--the "onclick" function for that unit
--iterate through all squares of board looking for units?
--have a list of units and iterate through that
--remember, the clickable area for the units is not limited to the size of the unit icon!!!



--==== Board Data Structure Inital Generation
--[[
for x = 1, BoardWidth do
    Board[x] = {}

    for y =1, BoardHeight do
        Board[x][y] = {}
        Board[x][y].terrain = ''
        Board[x][y].unit = ''
        Board[x][y].clicked = false
        board[x][y].startx = xMargin + ((x - 1)* BoardTileSize)
        board[x][y].starty = yMargin + ((y - 1)* BoardTileSize)
    end
end
]]



--====== Function to execute something if clickable area is clicked
-- Will need to fix clickable box area calculation

--[[
onclick = function love.mousepressed(clickx, clicky, button)
    if button == 1 then
        if clickx >= (clickx + BoardTileSize ) and if clicky >= (clicky + BoardTileSize) then
            --if left mouse button pressed and the mouse is within the size of the tile 
            --do something!
        end
    end
end
]]

--return { = }