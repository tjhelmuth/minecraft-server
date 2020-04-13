MAX_RANGE = 128
COBBLE_SLOT = 16

FUEL_SLOT = 1
TORCH_SLOT = 2

VEIN_RANGE = 32

KEEPERS = {"iron", "diamond", "coal", "copper", "silver", "gold", "ruby", "yello", "uranium", "tin"}

-- KEEPERS = {["minecraft:iron_ore"] = true, ["minecraft:diamond_ore"] = true, ["minecraft:diamond"] = true, ["minecraft:coal_ore"] = true, ["minecraft:coal"] = true, ["minecraft:gold_ore"] = true, ["minecraft:gold"] = true}

function Run()
    DigLine()

    --turn around at the end and come back the way we came up 1 block

    DropNonKeepers()

    turtle.digUp()
    turtle.up()

    turtle.turnRight()
    turtle.turnRight()

    DigLine(true)

    DropNonKeepers()

end

function DigLine(placeTorches)
    placeTorches = placeTorches or false

    local forward = 0
    while forward < MAX_RANGE do
        if NeedsFuel() == true then
            Refuel()
        end

        if turtle.detect() then
            local isStone = CheckStone()
            if not isStone then
                DigVein()
            else
                turtle.dig()
            end
        end
        
        if placeTorches and forward % 5 == 0 then
            turtle.turnLeft()
            PlaceTorch()
            turtle.turnRight()
        end

        -- move forward bruv
        turtle.forward()
        forward = forward + 1
    end
end

function NeedsFuel()
    return turtle.getFuelLevel() == 0
end

function Refuel()
    local prevSlot = turtle.getSelectedSlot()
    turtle.select(FUEL_SLOT)
    turtle.refuel(1)
    turtle.select(prevSlot)
end

function PlaceTorch()
    local prevSlot = turtle.getSelectedSlot()
    turtle.select(TORCH_SLOT)
    turtle.place()
    turtle.select(prevSlot)
end

function IsKeeper(blockName)
    print("Is keeper ? " .. blockName)

    if blockName == nil then
        return false
    end

    for keeperName, nothing in pairs(KEEPERS) do
        if blockName:find(keeperName) then
            print("Y -- " .. keeperName)
            return true
        end
    end

    print("N")
    return false
end

-- returns true if we dont want time mine it as a vein, and false if we DO want to mine it
function CheckStone()
    local success,block = turtle.inspect()
    if not success then
        return true
    end

    local name = block["name"]
    return not IsKeeper(name)
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
        turtle.dig()
        turtle.forward()
        veinCount = veinCount + 1
        DigVein(veinCount)
        BackUp()
    end
end

function DropNonKeepers()
    local originalSelection = turtle.getSelectedSlot()

    for i = 1,16 do
        turtle.select(i)
        local details = turtle.getItemDetail()

        for k,v in pairs(details) do
            print(k .. ": " .. v)
        end

        -- if not IsKeeper(blockName) then
        --     turtle.drop()
        -- end
    end
    turtle.select(originalSelection)
end

function BackUp()
    turtle.turnRight()
    turtle.turnRight()
    turtle.forward()
    turtle.turnRight()
    turtle.turnRight()
end

Run()
