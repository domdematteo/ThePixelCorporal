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


--=========== Calculating Moves ==============
-- For each unit that has move orders
-- See if another unit is ordered to move there
--If an enemy unit has chosen to move there, simulate combat
--If no enemy, let unit move there
--[[
function calculateMoves()

    for i =1, unitlistsize do
        if unitlist[i].nextposX ~= nil then
            --for all units, if that movement has a nextpos (ie, it was given a move order)
            for j=1, unitlistsize do
                if unitList[i].nextposX == unitList[j].nextposX and unitList[i].nextposY == unitList[j].nextposY then
                    winner = unitCombat(unitlist[i], unitlist[j])
                    winner.posX = winner.nextposX
                    winner.posY = winner.nextposY
                    winner.nextposX = nil
                    winner.nextposY = nil
                
                else --they are moving to an empty square
                unitlist[i].posX = unitlist[i].nextposX
                unitlist[i].posY = unitlist[i].nextposY
                unitlist[i].nextposX = nil
                unitlist[i].nextposY = nil
                end
            end
        end
    end

end




--========= Calculating Combat ===========
function unitCombat(unit1, unit2)
    --Returns winner of combat, removes losers
    --Infantry vs infantry
    if unit1.type == 'infantry' and unit2.type == 'infantry' then
        --identical units removed
        if unit1.class == unit2.class then
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
            removeCasualties(unit2)
            return unit1
        else 
            removeCasualties(unit1)
            return unit2
        end
    end
end



--======= Remove Casualties =========
function removeCasualties(unit)
    --Remove unit from board
    Board[unit.posX][unit.posY] = nil
    --Remove unit from unit list
    for i=1, unitlistsize do
        if unitlist[i] == unit then
            unitlist[i].isalive = false
            unitlist[i].posX = nil
            unitlist[i].posY = nil
            unitlist[i].nextposX = nil
            unitlist[i].nextposY = nil
            table.remove (unitlist, i)
        end
    end

end

]]
