MAX_RANGE = 256
FUEL_LIMIT = 5
COBBLE_SLOT = 16

VEIN_RANGE = 32

KEEPERS = {["minecraft:iron_ore"] = true, ["minecraft:diamond_ore"] = true, ["minecraft:diamond"] = true, ["minecraft:coal_ore"] = true, ["minecraft:coal"] = true, ["minecraft:gold_ore"] = true, ["minecraft:gold"] = true}

function Run()
    DigLine()

    --turn around at the end and come back the way we came up 1 block

    turtle.digUp()
    turtle.up()

    turtle.turnRight()
    turtle.turnRight()

    DigLine()

end

function DigLine()
    local forward = 0
    while forward < MAX_RANGE do
        if turtle.detect() then
            local isStone = CheckStone()
            print(isStone, forward)
            if not isStone then
                print("START DIGGING VEIN!")
                DigVein()
            else
                turtle.dig()
            end
        end
        
        -- move forward bruv
        turtle.forward()
        forward = forward + 1
    end
end

-- returns true if we dont want time mine it as a vein, and false if we DO want to mine it
function CheckStone()
    local success,block = turtle.inspect()
    if not success then
        return true
    end

    local name = block["name"]
    return KEEPERS[name] == nil or not KEEPERS[name] == true

    -- local prev = turtle.getSelectedSlot()
    -- turtle.select(COBBLE_SLOT)
    -- local isStone = turtle.compare()
    -- turtle.select(prev)
    -- return isStone    
end

function CheckStoneUp()
    local success,block = turtle.inspectUp()
    if not success then
        return true
    end

    local name = block["name"]
    return KEEPERS[name] == nil or not KEEPERS[name] == true
    -- local prev = turtle.getSelectedSlot()
    -- turtle.select(COBBLE_SLOT)
    -- local isStone = turtle.compareUp()
    -- turtle.select(prev)
    -- return isStone
end    

function DigVein(veinCount)
    veinCount = veinCount or 0

    if veinCount > VEIN_RANGE then
        return
    end

    -- DFS FRONT
    DigAndRecurse("FRONT", veinCount)
    -- DFS FRONT END
    
    --DFS RIGHT START
    turtle.turnRight()
    DigAndRecurse("RIGHT", veinCount)
    turtle.turnLeft()

    
    --DFS RIGHT END

    --DFS LEFT START
    turtle.turnLeft()
    DigAndRecurse("LEFT", veinCount)
    turtle.turnRight()
    --DFS LEFT END
    
    --DFS UP START
    DigAndRecurseUp(veinCount)
    --DFS DOWN START
    
    -- AT THIS POINT WE SHOULD BE BACK IN THE ORIGINAL PLACE FACING THE ORIGINAL DIRECTION :)
end

-- We gonna dig upwards and move into it and then check whether the next block is also in the vein
function DigAndRecurseUp(veinCount)
    if turtle.detectUp() and not CheckStoneUp() then
        print("UP", veinCount)
        turtle.digUp()
        turtle.up()
        veinCount = veinCount + 1;
        DigVein(veinCount)
        turtle.down()
    end
end

-- Dig forward and then move forward if still in the vein, or back up
function DigAndRecurse(direction, veinCount)
    if turtle.detect() and not CheckStone() then
        print(direction, veinCount)
        turtle.dig()
        turtle.forward()
        veinCount = veinCount + 1
        DigVein(veinCount)
        BackUp()
    end
end

function BackUp()
    turtle.turnRight()
    turtle.turnRight()
    turtle.forward()
    turtle.turnRight()
    turtle.turnRight()
end

turtle.refuel(FUEL_LIMIT)
Run()