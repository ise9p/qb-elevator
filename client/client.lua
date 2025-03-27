local QBCore = exports['qb-core']:GetCoreObject()
local lastTeleportTime = 0  
local isTeleporting = false 

-- Function to create targets for elevator buttons
local function CreateElevatorTargets()
    for _, elevator in pairs(Config.Elevators or {}) do
        for i, buttonCoord in ipairs(elevator.buttonCoords or {}) do
            local floor = elevator.floors and elevator.floors[i] or nil
            
            if Config.target == "qb" then
                exports['qb-target']:AddBoxZone(
                    "elevator_" .. elevator.name .. "_" .. i,
                    buttonCoord,
                    1.0, 1.0,
                    {
                        name = "elevator_" .. elevator.name .. "_" .. i,
                        heading = 0.0,
                        debugPoly = false,
                        minZ = buttonCoord.z - 1.0,
                        maxZ = buttonCoord.z + 1.0
                    },
                    {
                        options = {
                            {
                                icon = "fas fa-elevator",
                                label = "Use Elevator",
                                action = function()
                                    TriggerEvent("elevator:openMenu", { elevator = elevator })
                                end,
                                canInteract = function()
                                    if not floor or not floor.jobRestricted then return true end
                                    local playerData = QBCore.Functions.GetPlayerData()
                                    local playerJob = playerData.job and playerData.job.name or "unknown"
                                    local playerGrade = playerData.job and playerData.job.grade.level or 0
                                    for _, jobData in ipairs(floor.jobRestricted) do
                                        if playerJob == jobData.name and playerGrade >= (jobData.minGrade or 0) then
                                            return true
                                        end
                                    end
                                    return false
                                end
                            }
                        },
                        distance = Config.interactionDistance
                    }
                )
            elseif Config.target == "ox" then
                exports.ox_target:addBoxZone({
                    coords = buttonCoord,
                    size = vec3(1.0, 1.0, 2.0),
                    rotation = 0.0,
                    debug = false,
                    options = {
                        {
                            icon = "fas fa-elevator",
                            label = "Use Elevator",
                            onSelect = function()
                                TriggerEvent("elevator:openMenu", { elevator = elevator })
                            end,
                            canInteract = function()
                                if not floor or not floor.jobRestricted then return true end
                                local playerData = QBCore.Functions.GetPlayerData()
                                local playerJob = playerData.job and playerData.job.name or "unknown"
                                local playerGrade = playerData.job and playerData.job.grade.level or 0
                                for _, jobData in ipairs(floor.jobRestricted) do
                                    if playerJob == jobData.name and playerGrade >= (jobData.minGrade or 0) then
                                        return true
                                    end
                                end
                                return false
                            end
                        }
                    }
                })
            end
        end
    end
end

CreateThread(function()
    if Config.useTarget then
        CreateElevatorTargets()
        return  -- Exit the thread if using target system
    end

    while true do
        local sleep = 1000
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local textDisplayed = false
        local playerData = QBCore.Functions.GetPlayerData()
        local playerJob = playerData.job and playerData.job.name or "unknown"
        local playerGrade = playerData.job and playerData.job.grade.level or 0 

        if not isTeleporting then
            for _, elevator in pairs(Config.Elevators or {}) do
                for i, buttonCoord in ipairs(elevator.buttonCoords or {}) do
                    local dist = #(playerCoords - buttonCoord)
                    local floor = elevator.floors and elevator.floors[i] or nil
                    local hasAccess = true

                    if floor and floor.jobRestricted then
                        hasAccess = false
                        for _, jobData in ipairs(floor.jobRestricted) do
                            if playerJob == jobData.name and playerGrade >= (jobData.minGrade or 0) then
                                hasAccess = true
                                break
                            end
                        end
                    end

                    if dist < 1.5 and hasAccess then
                        sleep = 0
                        if not textDisplayed then
                            if Config.showTextUI == "qb" then
                                exports["qb-core"]:DrawText("[E] Use Elevator", "left")
                            elseif Config.showTextUI == "ox" and lib and lib.showTextUI then
                                lib.showTextUI("[E] Use Elevator", { position = "left-center" })
                            end                            
                            textDisplayed = true
                        end
                        if IsControlJustPressed(0, 38) then 
                            TriggerEvent("elevator:openMenu", { elevator = elevator })
                        end
                    end
                end
            end
        end
        
        if not textDisplayed then
            if Config.showTextUI == "qb" then
                exports["qb-core"]:HideText()
            elseif Config.showTextUI == "ox" then
                lib.hideTextUI()
            end
        end
        
        Wait(sleep)
    end
end)

RegisterNetEvent('elevator:openMenu', function(data)
    if isTeleporting or not data or not data.elevator then return end 

    local elevator = data.elevator
    local menu = {}
    
    if Config.menu == "qb" then
        table.insert(menu, {
            header = "Elevator - " .. (elevator.name or "Unknown"),  
            isMenuHeader = true,  
            icon = "fas fa-building", 
            text = "Select a floor to go to",  
        })
    elseif Config.menu == "ox" then
        menu = {
            id = "elevator_menu",
            title = "Elevator - " .. (elevator.name or "Unknown"),
            options = {}
        }
    end
    
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local playerData = QBCore.Functions.GetPlayerData()
    local playerJob = playerData.job and playerData.job.name or "unknown"
    local playerGrade = playerData.job and playerData.job.grade.level or 0  

    for index, floor in ipairs(elevator.floors or {}) do
        local isDisabled = #(playerCoords - floor.coords) <= 1.5  
        local hasAccess = true
        local floorIcon = floor.icon or "fas fa-building"  
        
        if floor.jobRestricted then
            hasAccess = false
            for _, jobData in ipairs(floor.jobRestricted) do
                if playerJob == jobData.name and playerGrade >= (jobData.minGrade or 0) then
                    hasAccess = true
                    break
                end
            end
        end
        
        if not hasAccess then
            floorIcon = "fas fa-lock" 
        end
        
        if Config.menu == "qb" then
            table.insert(menu, {
                header = string.format("%d. %s", index, floor.label),  
                icon = floorIcon,  
                disabled = isDisabled,  
                params = hasAccess and { event = "elevator:teleport", args = floor.coords } or nil
            })
        elseif Config.menu == "ox" then
            table.insert(menu.options, {
                title = string.format("%d. %s", index, floor.label),
                description = hasAccess and "Click" or "Denied",  
                icon = floorIcon,
                disabled = isDisabled,
                event = hasAccess and "elevator:teleport" or nil,
                args = hasAccess and floor.coords or nil
            })
        end
    end
    
    if Config.menu == "qb" then
        table.insert(menu, {
            header = "Exit",
            icon = "fas fa-times",
            params = { event = "qb-menu:closeMenu" }
        })
        exports['qb-menu']:openMenu(menu)
    elseif Config.menu == "ox" then
        table.insert(menu.options, {
            title = "Exit",
            icon = "fas fa-times",
            event = "ox_lib:closeMenu"
        })
        lib.registerContext(menu)
        lib.showContext("elevator_menu")
    end
end)



RegisterNetEvent('elevator:teleport', function(coords)
    if not coords then return end

    local playerPed = PlayerPedId()
    local currentTime = GetGameTimer()
    local timeRemaining = math.max(0, Config.ElevatorWaitTime - (currentTime - lastTeleportTime)) / 1000 

    if currentTime - lastTeleportTime < Config.ElevatorWaitTime then  
        QBCore.Functions.Notify(string.format("You must wait %.1f seconds before using the elevator again.", timeRemaining), "error")
        return  
    end

    lastTeleportTime = currentTime  
    isTeleporting = true 

    FreezeEntityPosition(playerPed, true)

    if Config.EnableElevatorSound then
        TriggerServerEvent("InteractSound_SV:PlayOnSource", Config.ElevatorArrivalSound or "elevator_arrival", 0.5)
    end

    DoScreenFadeOut(2500)  
    Wait(4000) 

    SetEntityCoords(playerPed, coords.x, coords.y, coords.z - 1.0, false, false, false, true)

    if Config.EnableElevatorSound then
        TriggerServerEvent("InteractSound_SV:PlayOnSource", Config.ElevatorStartSound or "elevator_start", 0.5)
    end

    Wait(1500)  
    DoScreenFadeIn(2000)  

    FreezeEntityPosition(playerPed, false)
    isTeleporting = false 
    Wait(1500)  
end)
