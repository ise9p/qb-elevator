Config = {}

Config.EnableElevatorSound = true 

Config.showTextUI = "ox"  -- "ox" or "qb"

Config.menu = "ox" -- "ox" or "qb"

Config.useTarget = true   -- Enable/disable target system
Config.target = "qb"      -- "qb" or "ox" for target system type
Config.interactionDistance = 1.5  -- Distance for interaction

Config.ElevatorWaitTime = 2000

Config.ElevatorArrivalSound = "elevator_arrival" 
Config.ElevatorStartSound = "elevator_start"  

Config.Elevators = {
    {
        name = "Maze Bank",
        floors = {
            {label = "Lobby", coords = vector3(-70.66, -801.16, 44.23), icon = "fas fa-building"},
            {label = "VIP Office", coords = vector3(-76.68, -830.31, 243.39), icon = "fas fa-user-tie"}
        },
        buttonCoords = {
            vector3(-70.66, -801.16, 44.23),
            vector3(-76.68, -830.31, 243.39)
        }
    },
    {
        name = "Data Center",
        floors = {
            {label = "Lobby", coords = vector3(660.78, 1282.54, 360.3), icon = "fas fa-building"},
            {label = "Data Center Office", coords = vector3(778.83, 1296.8, 325.76), icon = "fas fa-user-tie", jobRestricted = { {name = "police", minGrade = 1} }}
        },
        buttonCoords = {
            vector3(660.78, 1282.54, 360.3),
            vector3(778.83, 1296.8, 325.76)
        }
    },
}
