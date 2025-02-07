Config = {}

Config.EnableElevatorSound = true 

Config.showTextUI = "qb" 


Config.ElevatorWaitTime = 3000

Config.ElevatorArrivalSound = "elevator_arrival" 
Config.ElevatorStartSound = "elevator_start"  

Config.Elevators = {
    {
        name = "Police Department",
        floors = {
            {label = "Ground Floor", coords = vector3(473.27, -983.74, 30.71), icon = "fas fa-building", jobRestricted = { {name = "police", minGrade = 0} }},  
            {label = "First Floor", coords = vector3(150.0, -1040.0, 35.0), icon = "fas fa-level-up-alt", jobRestricted = { {name = "police", minGrade = 2} }},
            {label = "Roof", coords = vector3(473.23, -983.69, 43.69), icon = "fas fa-warehouse", jobRestricted = { {name = "police", minGrade = 1} }},
        },
        buttonCoords = {
            vector3(473.27, -983.74, 30.71),
            vector3(149.8, -1040.0, 35.0),
            vector3(480.0, -1000.0, 45.0),
            vector3(473.23, -983.69, 43.69)
        }
    },
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
