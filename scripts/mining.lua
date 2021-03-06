FUEL_SLOT = 1

KEEPERS = {
    "dye",
    "ThermalFoundation:Ore", 
    "thermalfoundation:ore",
    "iron", 
    "diamond", 
    "coal", 
    "copper", 
    "silver", 
    "gold", 
    "ruby", 
    "yello", 
    "uranium", 
    "tin",
    "lapis", 
    "Thermal Foundation", 
    "ore", 
    "torch", 
    "uranium", 
    "Silver"
}

function IsKeeper(blockName)
    print("Is keeper ? " .. blockName)

    if blockName == nil then
        return false
    end

    for i, keeperName in pairs(KEEPERS) do
        if blockName:find(keeperName) then
            return true
        end
    end

    return false
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

function MoveForward(count)
    RefuelIfNeeded()
    count = count or 1

    if count == 0 then
        return
    end

    for i = 1,count do
        local moved = false
        while not moved do
            if turtle.detect() then
                turtle.dig()
            end
            moved = turtle.forward()
        end
    end
end

function MoveUp(count)
    RefuelIfNeeded()
    count = count or 1

    if count == 0 then
        return
    end

    for i = 1,count do
        local moved = false
        while not moved do
            if turtle.detectUp() then
                turtle.digUp()
            end
            moved = turtle.up()
        end
    end
end

function MoveDown(count)
    RefuelIfNeeded()
    count = count or 1

    if count == 0 then
        return
    end

    for i = 1,count do
        local moved = false
        while not moved do
            if turtle.detectDown() then
                turtle.digDown()
            end
            moved = turtle.down()
        end
    end 
end

function NeedsFuel()
    return turtle.getFuelLevel() < 80
end

function RefuelIfNeeded()
    if NeedsFuel() then
        Refuel()
    end
end

function Refuel()
    local prevSlot = turtle.getSelectedSlot()
    turtle.select(FUEL_SLOT)
    turtle.refuel(3)
    turtle.select(prevSlot)
end