-- THIS PROGRAM DIGS OUT THE AREA IN FRONT OF THE TURTLES STARTING SPOT

-- THE TURTLE STARTS IN THE "BOTTOM LEFT" OF THE DUG OUT AREA

-- DIG X BLOCKS TO THE RIGHT, THEN X UP, THEN X LEFT, THEN X-1 DOWN

-- THEN X - 1 TO THE RIGHT

os.loadAPI("mining")

LOG_FILE = fs.open("log", "w")

function Log(text)
    LOG_FILE.writeLine(text)
end

function Spiral(length, height)
    if length == 2 then
        return
    end

    --- move length - 1 blocks right, up, left, length - 2 down and then recurse! :)

    -- RIGHT
    turtle.turnRight()
    DigLine(length - 1, height)

    -- UP
    turtle.turnLeft()
    DigLine(length - 1, height)

    -- LEFT
    turtle.turnLeft()
    DigLine(length - 1, height)

    -- Down (1 less so next spiral is inside previous)
    turtle.turnLeft()
    DigLine(length - 2, height)

    Spiral(length - 1, height)
end

function DigLine(length, height)
    for i = 1,length do
        local up = (i - 1 % 0) -- first dig goes up, second comes down
        DigSpot(height, up)
    end
end

-- dig out a block to height. If up is true, we dig forward and then height - 1 up if it's down we dig forward and then height - 1 down
function DigSpot(height, up)
    mining.MoveForward()

    local moveFn = up and mining.MoveUp or mining.MoveDown
    for i = 1, height - 1 do
        moveFn()
    end
end

function Run()
    args = {}
    local length = args[1]
    local height = args[2]

    Log("Kicking off quary with length = " .. length .. " and height = " .. height)
    Spiral(length, height)
end

pcall(Run)

LOG_FILE.close()