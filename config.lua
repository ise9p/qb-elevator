Config = {}

Config.EnableElevatorSound = true 

Config.showTextUI = "qb" 


Config.ElevatorWaitTime = 3000

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
    }
}
