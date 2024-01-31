local processedLines = {}
local nuiReady = false

-- The `setNuiFocus` function is a Lua function that takes a boolean parameter `bool`. It calls the
-- `SetNuiFocus` function with two boolean arguments `bool`. The purpose of this function is to set the
-- NUI (Native UI) focus to either enable or disable user interaction with the NUI elements.
local function setNuiFocus(bool)
    SetNuiFocus(bool, bool)
end

-- The `addConsoleTableData` function is responsible for processing the console buffer and generating a
-- table of tracked messages based on certain criteria.
local function addConsoleTableData()
    local consoleBuffer = lib.callback.await('um-admin-tracker:server:getConsoleBuffer', false)
    local trackerTable = {}

    for line in consoleBuffer:gmatch("([^\n]+)") do
        if not processedLines[line] then
            for category, details in pairs(Tracker_list_code) do
                local prefixes = type(details.prefix) == "table" and details.prefix or {details.prefix}

                local colorMatch = string.find(line, "%" .. details.color)
                local prefixMatch = false
                for _, prefix in ipairs(prefixes) do
                    if string.find(line, prefix) then
                        prefixMatch = true
                        break
                    end
                end

                if colorMatch and prefixMatch then
                    trackerTable[category] = trackerTable[category] or {}
                    local messageList = trackerTable[category]

                    messageList[#messageList + 1] = {
                        id = category..'-'..math.random(1, 999999),
                        line = line
                    }
                    processedLines[line] = true
                    break
                end
            end
        end
    end

    Wait(1000)
    SendNUIMessage({type = 'updateTrackerTable', data = trackerTable})
end


-- The `RegisterCommand('errortracker', function() ... end)` function is registering a command in Lua.
-- When the command "errortracker" is executed, the function inside the `RegisterCommand` is called.
RegisterCommand('errortracker', function()
    if not nuiReady then
        return print('NUI is not ready yet')
    end
    setNuiFocus(true)
    SendNUIMessage({type = 'openTracker'})
    addConsoleTableData()
end)

-- The `RegisterNUICallback('updateTrackerTable', function(_, cb) ... end)` function is registering a
-- callback in Lua for the NUI (Native UI) event with the name 'updateTrackerTable'.
RegisterNUICallback('updateTrackerTable', function(_, cb)
    addConsoleTableData()
    cb('ok' or 1)
end)

-- The `RegisterNUICallback('trackerNUIReady', function(_, cb) ... end)` function is registering a
-- callback in Lua for the NUI (Native UI) event with the name 'trackerNUIReady'.
RegisterNUICallback('trackerNUIReady', function(_, cb)
    nuiReady = true
    cb('ok' or 1)
end)

-- The `RegisterNUICallback('closeTracker', function(_, cb) ... end)` function is registering a
-- callback in Lua for the NUI (Native UI) event with the name 'closeTracker'.
RegisterNUICallback('closeTracker', function(_, cb)
    setNuiFocus(false)
    cb('ok' or 1)
end)