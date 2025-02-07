local QBCore = exports['qb-core']:GetCoreObject()
local lastTeleportTime = 0  
local isTeleporting = false 

CreateThread(function()
    while true do
        local sleep = 1000
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local textDisplayed = false
        local playerData = QBCore.Functions.GetPlayerData()
        local playerJob = playerData.job.name
        local playerGrade = playerData.job.grade.level  

        if not isTeleporting then
            for _, elevator in pairs(Config.Elevators) do
                for i, buttonCoord in ipairs(elevator.buttonCoords) do
                    local dist = #(playerCoords - buttonCoord)

                    local floor = elevator.floors[i]
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
                            elseif Config.showTextUI == "ox" then
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
    if isTeleporting then return end 

    local elevator = data.elevator
    local menu = {
        {
            header = "Elevator - " .. elevator.name,  
            isMenuHeader = true,  
            icon = "fas fa-building", 
            text = "Select a floor to go to",  
        }
    }    
    
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local playerData = QBCore.Functions.GetPlayerData()
    local playerJob = playerData.job.name
    local playerGrade = playerData.job.grade.level  

    for index, floor in ipairs(elevator.floors) do
        local isDisabled = #(playerCoords - floor.coords) <= 1.5  
        local hasAccess = true
    
        if floor.jobRestricted then
            hasAccess = false
            for _, jobData in ipairs(floor.jobRestricted) do
                if playerJob == jobData.name and playerGrade >= (jobData.minGrade or 0) then
                    hasAccess = true
                    break
                end
            end
        end
    
        if hasAccess then
            table.insert(menu, {
                header = string.format("%d. %s", index, floor.label),  
                icon = floor.icon,
                disabled = isDisabled,  
                params = isDisabled and nil or {  
                    event = "elevator:teleport",
                    args = floor.coords
                }
            })
        end
    end
    
    table.insert(menu, {
        header = "Exit",
        icon = "fas fa-times",
        params = {
            event = "qb-menu:closeMenu"
        }
    })

    exports['qb-menu']:openMenu(menu)
end)

RegisterNetEvent('elevator:teleport', function(coords)
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
        local arrivalSound = Config.ElevatorArrivalSound or "elevator_arrival"
        TriggerServerEvent("InteractSound_SV:PlayOnSource", arrivalSound, 0.5)
    end

    DoScreenFadeOut(2500)  
    Wait(4000) 

    SetEntityCoords(playerPed, coords.x, coords.y, coords.z - 1.0, false, false, false, true)

    if Config.EnableElevatorSound then
        local startSound = Config.ElevatorStartSound or "elevator_start"
        TriggerServerEvent("InteractSound_SV:PlayOnSource", startSound, 0.5)
    end

    Wait(1500)  
    DoScreenFadeIn(2000)  

    FreezeEntityPosition(playerPed, false)
    isTeleporting = false 
    Wait(1500)  
end)
