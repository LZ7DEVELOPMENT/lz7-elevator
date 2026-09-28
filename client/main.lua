local uiOpen = false
local currentElevator
local currentFloor

local function notify(message)
    BeginTextCommandThefeedPost('STRING')
    AddTextComponentSubstringPlayerName(message)
    EndTextCommandThefeedPostTicker(false, false)
end

local function drawText3d(coords, text)
    local onScreen, x, y = World3dToScreen2d(coords.x, coords.y, coords.z)
    if not onScreen then return end

    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(true)
    SetTextColour(255, 255, 255, 215)
    SetTextCentre(true)
    BeginTextCommandDisplayText('STRING')
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayText(x, y)
end

local function buildFloors(elevator)
    local floors = {}

    for number, floor in pairs(elevator.floors) do
        floors[#floors + 1] = {
            number = number,
            label = floor.label or ('Floor ' .. number)
        }
    end

    table.sort(floors, function(a, b)
        return a.number < b.number
    end)

    return floors
end

local function closeElevator()
    uiOpen = false
    currentElevator = nil
    currentFloor = nil
    SetNuiFocus(false, false)
    SendNUIMessage({ action = 'close' })
end

local function openElevator(elevator, floorNumber)
    currentElevator = elevator
    currentFloor = floorNumber
    uiOpen = true

    SetNuiFocus(true, true)
    SendNUIMessage({
        action = 'open',
        title = elevator.name or 'Elevator',
        floors = buildFloors(elevator),
        currentFloor = floorNumber
    })
end

local function teleportToFloor(floorNumber)
    if not currentElevator then return end

    local floor = currentElevator.floors[floorNumber]
    if not floor then
        notify(Config.Text.invalidFloor)
        SendNUIMessage({ action = 'error' })
        return
    end

    if currentFloor == floorNumber then
        notify((Config.Text.alreadyOnFloor):format(floorNumber))
        SendNUIMessage({ action = 'sameFloor', floor = floorNumber })
        return
    end

    DoScreenFadeOut(350)
    while not IsScreenFadedOut() do
        Wait(0)
    end

    local ped = PlayerPedId()
    SetEntityCoords(ped, floor.coords.x, floor.coords.y, floor.coords.z, false, false, false, true)
    SetEntityHeading(ped, floor.coords.w or 0.0)
    Wait(4000)
    DoScreenFadeIn(350)

    notify((Config.Text.arrived):format(floorNumber))
    closeElevator()
end

RegisterNUICallback('close', function(_, cb)
    closeElevator()
    cb({ ok = true })
end)

RegisterNUICallback('selectFloor', function(data, cb)
    local floorNumber = tonumber(data.floor)

    if floorNumber then
        teleportToFloor(floorNumber)
    end

    cb({ ok = true })
end)

CreateThread(function()
    while true do
        local sleep = 1000
        local ped = PlayerPedId()
        local playerCoords = GetEntityCoords(ped)

        for _, elevator in ipairs(Config.Elevators) do
            for floorNumber, floor in pairs(elevator.floors) do
                local floorCoords = vector3(floor.coords.x, floor.coords.y, floor.coords.z)
                local distance = #(playerCoords - floorCoords)

                if distance <= Config.DrawDistance then
                    sleep = 0
                    DrawMarker(
                        Config.MarkerType,
                        floor.coords.x, floor.coords.y, floor.coords.z + 0.15,
                        0.0, 0.0, 0.0,
                        0.0, 0.0, 0.0,
                        0.35, 0.35, 0.35,
                        80, 210, 255, 160,
                        false, true, 2, false, nil, nil, false
                    )
                end

                if distance <= Config.InteractDistance and not uiOpen then
                    sleep = 0
                    drawText3d(floorCoords + vector3(0.0, 0.0, 0.45), Config.Text.open)

                    if IsControlJustReleased(0, Config.OpenKey) then
                        openElevator(elevator, floorNumber)
                    end
                end
            end
        end

        if uiOpen and IsControlJustReleased(0, 177) then
            closeElevator()
        end

        Wait(sleep)
    end
end)
