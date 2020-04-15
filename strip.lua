MAX_RANGE = 128
COBBLE_SLOT = 16

FUEL_SLOT = 1
TORCH_SLOT = 2

VEIN_RANGE = 32

KEEPERS = {"iron", "diamond", "coal", "copper", "silver", "gold", "ruby", "yello", "uranium", "tin", "Thermal Foundation", "ore", "torch"}

LOG_FILE = fs.open("log", "w")


function Log(text)
    LOG_FILE.writeLine(text)
end


function Run()
    DigLine()

    --turn around at the end and come back the way we came up 1 block

    DropNonKeepers()

    turtle.digUp()
    MoveUp()

    turtle.turnRight()
    turtle.turnRight()

    DigLine(true)

    DropNonKeepers()

    LOG_FILE.close()
end

function DigLine(placeTorches)
    placeTorches = placeTorches or false

    local forward = 0
    while forward < MAX_RANGE do
        Log("I: " .. forward)
        
        RefuelIfNeeded()

        if turtle.detect() then
            local isStone = CheckStone()
            if not isStone then
                DigVein()
            else
                turtle.dig()
            end
        end
        
        if placeTorches and forward % 5 == 0 then
            PlaceTorch()
        end

        MoveForward()
        forward = forward + 1
    end
end

function NeedsFuel()
    Log("Need Fuel? Have " .. turtle.getFuelLevel())
    return turtle.getFuelLevel() < 80
end

function RefuelIfNeeded()
    if NeedsFuel() then
        Refuel()
    end
end

function Refuel()
    Log("Refueling")
    local prevSlot = turtle.getSelectedSlot()
    turtle.select(FUEL_SLOT)
    turtle.refuel(3)
    turtle.select(prevSlot)
end

function PlaceTorch()
    local prevSlot = turtle.getSelectedSlot()
    turtle.select(TORCH_SLOT)
    turtle.placeDown()
    turtle.select(prevSlot)
end

function IsKeeper(blockName)
    print("Is keeper ? " .. blockName)

    if blockName == nil then
        return false
    end

    for i, keeperName in pairs(KEEPERS) do
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
    return not IsKeeper(name)
end

function CheckStoneDown()
    local success,block = turtle.inspectDown()
    if not success then
        return true
    end

    local name = block["name"]
    return not IsKeeper(name)
end

function DigVein(veinCount)
    RefuelIfNeeded()
    
    veinCount = veinCount or 0

    Log(GetSpacing(veinCount) .. "VEIN {")

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
    
    DigAndRecurseUp(veinCount)
    DigAndRecurseDown(veinCount)
    
    Log(GetSpacing(veinCount) .. "}")
    -- AT THIS POINT WE SHOULD BE BACK IN THE ORIGINAL PLACE FACING THE ORIGINAL DIRECTION :)
end

-- We gonna dig upwards and move into it and then check whether the next block is also in the vein
function DigAndRecurseUp(veinCount)
    if turtle.detectUp() and not CheckStoneUp() then
        Log(GetSpacing(veinCount) .. "Up")
        turtle.digUp()
        MoveUp()
        veinCount = veinCount + 1;
        DigVein(veinCount)
        MoveDown()
    end
end

function DigAndRecurseDown(veinCount)
    if turtle.detectDown() and not CheckStoneDown() then
        Log(GetSpacing(veinCount) .. "Down")
        turtle.digDown()
        MoveDown()
        veinCount = veinCount + 1;
        DigVein(veinCount)
        MoveUp()
    end
end

-- Dig forward and then move forward if still in the vein, or back up
function DigAndRecurse(direction, veinCount)
    if turtle.detect() and not CheckStone() then
        Log(GetSpacing(veinCount) .. direction)
        turtle.dig()
        MoveForward()
        veinCount = veinCount + 1
        DigVein(veinCount)
        BackUp()
    end
end

function GetSpacing(veinCount)
    if veinCount == nil then
        return ""
    end

    local indent = veinCount * 2
    local spacing = ""
    for i = 1,indent do
        spacing = spacing .. " "
    end
    return spacing;
end

function DropNonKeepers()
    local originalSelection = turtle.getSelectedSlot()

    for i = 1,16 do
        turtle.select(i)
        local details = turtle.getItemDetail() or {["name"] = ""}
            
        local blockName = details["name"]
        if not IsKeeper(blockName) then
            turtle.drop()
        end
    end
    turtle.select(originalSelection)
end

function BackUp()
    turtle.turnRight()
    turtle.turnRight()
    MoveForward()
    turtle.turnRight()
    turtle.turnRight()
end

function MoveForward()
    local moved = false
    while not moved do
        if turtle.detect() then
            turtle.dig()
        end
        moved = turtle.forward()
    end
end

function MoveUp()
    local moved = false
    while not moved do
        if turtle.detectUp() then
            turtle.digUp()
        end
        moved = turtle.up()
    end
end

function MoveDown()
    local moved = false
    while not moved do
        if turtle.detectDown() then
            turtle.digDown()
        end
        moved = turtle.down()
    end
end


Run()
