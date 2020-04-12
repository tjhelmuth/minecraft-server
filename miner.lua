BatchSize = 20
BatchLimit = 1
running = true

turtle = null;

local function mineBatch()
    turtle.refuel(BatchSize)

end

local function canRunNext(batchNum)
    if (batchNum < BatchLimit) then
        return false
    elseif turtle.getFuelLevel() <= 0 then
        return false
    end
    return true
end

local function run()
    print("Running")

    local running = true
    local batch = 0

    while canRunNext(batch) do
        print("Mining batch " + batch)
        mineBatch()
        batch = batch + 1
    end
end
