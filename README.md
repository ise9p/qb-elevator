# qb-elevator  

## Description  
qb-elevator is an advanced and configurable elevator system for QBCore. It supports different interaction methods and targeting systems, allowing players to travel between floors easily.  

## Features  
✅ Choose between **Eye Interaction (ox_target/qb-target)** or **DrawText**  
✅ Configurable **menu system** (`ox` or `qb`)  
✅ Supports **elevator sound effects**  
✅ **Job-restricted floors** for specific roles  
✅ Fully customizable via `config.lua`  

## Configuration  

Edit `config.lua` to customize the script:  

- **Interaction System:**  
  - `Config.showTextUI = "ox"` → `"ox"` or `"qb"` for text display  
  - `Config.menu = "ox"` → `"ox"` or `"qb"` for menu type  
  - `Config.useTarget = true` → Enable/disable target system  
  - `Config.target = "qb"` → `"qb"` or `"ox"` for target system type  

- **Elevator Settings:**  
  - `Config.ElevatorWaitTime = 2000` → Time (in ms) before elevator starts moving  
  - `Config.ElevatorArrivalSound = "elevator_arrival"` → Sound when elevator arrives  
  - `Config.ElevatorStartSound = "elevator_start"` → Sound when elevator starts  

- **Elevators Setup:**  
  - Each elevator has multiple **floors**, defined by their coordinates and labels  
  - Floors can have **job restrictions** (e.g., only police officers can access certain floors)  

## Installation  

1. **Download & Extract** the script into your `resources` folder.  
2. **Add to Server.cfg:**  
   ```cfg
   ensure qb-elevator

## Credits
Developed by Se9p Script
