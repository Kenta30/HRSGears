local vehicle = nil
local numgears = nil
local topspeedGTA = nil
local topspeedms = nil
local acc = nil
local hash = nil
local selectedgear = 0 
local hbrake = nil
local dragcoeff = nil

local manualon = false

local incar = false

local currspeedlimit = nil
local ready = false
local realistic = false

RegisterCommand("manual", function()
    if vehicle == nil then
        if manualon == false then
            manualon = true
            x()
            xx()
            --xxx()
            xxxx()
            xxxxx()
            xxxxxx()
            xxxxxxx()
            xxxxxxxx()
            xxxxxxxxx()
			--TriggerEvent('chatMessage', '', {255, 255, 255}, '^7' .. 'Manual Mode ON' .. '^7.')
        else
            manualon = false
			--TriggerEvent('chatMessage', '', {255, 255, 255}, '^7' .. 'Manual Mode OFF' .. '^7.')
        end
    end
end)

RegisterCommand("manualmode", function()
    --if vehicle == nil then
        if manualon == false then
        
        else
            if realistic == true then
                realistic = false
				--TriggerEvent('chatMessage', '', {255, 255, 255}, '^7' .. 'Manual Mode SIMPLE' .. '^7.')
            else
                realistic = true
                kenta()
				--TriggerEvent('chatMessage', '', {255, 255, 255}, '^7' .. 'Manual Mode REALISTIC' .. '^7.')
            end
        end
    --end
end)

function kenta()
CreateThread(function()
    while realistic do
       Wait(1500)
       if IsPedInAnyVehicle(PlayerPedId(), false) then
          local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
          local vehicleSpeedSource = GetEntitySpeed(vehicle)
          local speed = math.ceil(vehicleSpeedSource * 3.6)
          local rpm = ESX.Math.Round(GetVehicleCurrentRpm(vehicle), 2)
          local gear = getinfo2(selectedgear)
          if speed > 1 then
             if rpm < 0.61 and gear > 1 then
                selectedgear = selectedgear - 1
                SimulateGears()
             end
          end
       end
    end
end)
end

function x()
Citizen.CreateThread(function()
    while manualon do
        Citizen.Wait(100) 

        local ped = PlayerPedId()
        local newveh = GetVehiclePedIsIn(ped,false)
        local class = GetVehicleClass(newveh)

        if newveh == vehicle then

        elseif newveh == 0 and vehicle ~= nil then
            resetvehicle()
        else
            if GetPedInVehicleSeat(newveh, -1) == ped then
                if class ~= 13 and class ~= 14 and class ~= 15 and class ~= 16 and class ~= 21 then
                    vehicle = newveh
                    hash = GetEntityModel(newveh)
                   
                    
                    if GetVehicleMod(vehicle,13) < 0 then
                        numgears = GetVehicleHandlingInt(newveh, "CHandlingData", "nInitialDriveGears")
                    else
                        numgears = GetVehicleHandlingInt(newveh, "CHandlingData", "nInitialDriveGears") + 1
                    end
                    
                    

                    hbrake = GetVehicleHandlingFloat(newveh, "CHandlingData", "fHandBrakeForce")
                    
                    topspeedGTA = GetVehicleHandlingFloat(newveh, "CHandlingData", "fInitialDriveMaxFlatVel")
                    topspeedms = (topspeedGTA * 1.32)/3.6

                    acc = GetVehicleHandlingFloat(newveh, "CHandlingData", "fInitialDriveForce")
                    --SetVehicleMaxSpeed(newveh,topspeedms)
                    selectedgear = 0
                    Citizen.Wait(50)
                    ready = true
                end
            end
        end

    end
end)
end

function resetvehicle()
    SetVehicleHandlingFloat(vehicle, "CHandlingData", "fInitialDriveForce", acc)
    SetVehicleHandlingFloat(vehicle, "CHandlingData", "fInitialDriveMaxFlatVel",topspeedGTA)
    SetVehicleHandlingFloat(vehicle, "CHandlingData", "fHandBrakeForce", hbrake)
    SetVehicleHighGear(vehicle, numgears)
    ModifyVehicleTopSpeed(vehicle,1)
    --SetVehicleMaxSpeed(vehicle,topspeedms)
    SetVehicleHandbrake(vehicle, false)
    
    vehicle = nil
    numgears = nil
    topspeedGTA = nil
    topspeedms = nil
    acc = nil
    hash = nil
    hbrake = nil
    selectedgear = 0
    currspeedlimit = nil
    ready = false
end

function xx()
Citizen.CreateThread(function()
    while manualon do
	local sleep = 500
        if manualon == true and vehicle ~= nil then
		sleep = 0
                DisableControlAction(0, 137, true)
                DisableControlAction(0, 224, true)
        end
	Wait(sleep)
    end
end)
end

local fasz = true

ESX.RegisterInput("fgear", "Felváltás", "keyboard", "CAPITAL", function()
if fasz == true then
fasz = false
if manualon == true and vehicle ~= nil then
if vehicle ~= nil then
if ready == true then
if selectedgear <= numgears - 1 then 
Wait(200)
selectedgear = selectedgear + 1
SimulateGears()
Wait(200)
fasz = true
end
Wait(200)
end
Wait(200)
end
Wait(200)
end
Wait(200)
end
Wait(200)
fasz = true
end)

ESX.RegisterInput("rgear", "Lelváltás", "keyboard", "LCONTROL", function()
if fasz == true then
fasz = false
if manualon == true and vehicle ~= nil then
if vehicle ~= nil then
if ready == true then
if selectedgear > -1 then
Wait(200)
selectedgear = selectedgear - 1
SimulateGears()
Wait(200)
fasz = true
end
end
end
end
end
Wait(200)
fasz = true
end)

function xxx()
Citizen.CreateThread(function()
    while manualon do
        local sleep = 300
        
        if manualon == true and vehicle ~= nil then

            if vehicle ~= nil then
            sleep = 0

            
            -- Shift up and down
                if ready == true then
                    if IsDisabledControlJustPressed(0, 137) then
                        if selectedgear <= numgears - 1 then 
                            DisableControlAction(0, 71, true)
                            Wait(200)
                            selectedgear = selectedgear + 1
                            DisableControlAction(0, 71, false)
                            SimulateGears()
                        end
                    elseif IsDisabledControlJustPressed(0, 224) then
                        if selectedgear > -1 then
                           
                            DisableControlAction(0, 71, true)
                            Wait(200)
                            selectedgear = selectedgear - 1
                            DisableControlAction(0, 71, false)
                            SimulateGears()
                        end
                    end
                end
            end

        end
       Wait(sleep)
    end
end)
end

function SimulateGears()
   --if fasz == false then
    local engineup = GetVehicleMod(vehicle, 11)      

    if selectedgear > 0 then
        
        local ratio 
    --[[if Config.vehicles[hash] ~= nil then
        if selectedgear ~= 0 and selectedgear ~= nil  then
            if numgears ~= nil and selectedgear ~= nil then
                if Config.vehicles[hash][numgears] ~= nil then
                    ratio = Config.vehicles[hash][numgears][selectedgear] * (1/0.9)
                else
                    ratio = Config.gears[numgears][selectedgear] * (1/0.9)
                end
            end
        end
    
    else]]
        if selectedgear ~= 0 and selectedgear ~= nil then
            if numgears ~= nil and selectedgear ~= nil then
                ratio = Config.gears[numgears][selectedgear] * (1/0.9)
            end
        end
    --end

        if ratio ~= nil then
    
            SetVehicleHighGear(vehicle, 1)
            newacc = ratio * acc
            newtopspeedGTA = topspeedGTA / ratio
            newtopspeedms = topspeedms / ratio

            --if GetEntitySpeed(vehicle) > newtopspeedms then
                --selectedgear = selectedgear + 1
            --else
        
            SetVehicleHandbrake(vehicle, false)
            SetVehicleHandlingFloat(vehicle, "CHandlingData", "fInitialDriveForce", newacc)
            SetVehicleHandlingFloat(vehicle, "CHandlingData", "fInitialDriveMaxFlatVel", newtopspeedGTA)
            SetVehicleHandlingFloat(vehicle, "CHandlingData", "fHandBrakeForce", hbrake)
            ModifyVehicleTopSpeed(vehicle,1)
            --SetVehicleMaxSpeed(vehicle,newtopspeedms)
            currspeedlimit = newtopspeedms 
            --end

        end
    elseif selectedgear == 0 then
        --SetVehicleHandlingFloat(vehicle, "CHandlingData", "fInitialDriveMaxFlatVel", 0.0)
    elseif selectedgear == -1 then
        
        --if GetEntitySpeedVector(vehicle,true).y > 0.1 then
            --selectedgear = selectedgear + 1
        --else
            SetVehicleHandbrake(vehicle, false)
            SetVehicleHighGear(vehicle,numgears)    
            SetVehicleHandlingFloat(vehicle, "CHandlingData", "fInitialDriveForce", acc)
            SetVehicleHandlingFloat(vehicle, "CHandlingData", "fInitialDriveMaxFlatVel", topspeedGTA)
            SetVehicleHandlingFloat(vehicle, "CHandlingData", "fHandBrakeForce", hbrake)
            ModifyVehicleTopSpeed(vehicle,1)
            
            --SetVehicleMaxSpeed(vehicle,topspeedms)
        --end
    
    end
    SetVehicleMod(vehicle, 11, engineup, false)
   --end
end

function xxxx()
Citizen.CreateThread(function()
    while manualon do
        Citizen.Wait(0)
        if manualon == true and vehicle ~= nil then
            if selectedgear == -1 then
                if GetVehicleCurrentGear(vehicle) == 1 then
                    DisableControlAction(0, 71, true)
                end
            elseif selectedgear > 0 then
                if GetEntitySpeedVector(vehicle,true).y < 0.0 then   
                    DisableControlAction(0, 72, true)
                end
            elseif selectedgear == 0 then
                SetVehicleHandbrake(vehicle, true)
                if IsControlPressed(0, 76) == false then
                    SetVehicleHandlingFloat(vehicle, "CHandlingData", "fHandBrakeForce", 0.0)
                else
                    SetVehicleHandlingFloat(vehicle, "CHandlingData", "fHandBrakeForce", hbrake)
                end
            end
        else
            Citizen.Wait(100) 
        end
    end
end)
end

local disable = false

function xxxxx()
Citizen.CreateThread(function()
    while manualon do
        Citizen.Wait(0)
        if realistic == true then
            if manualon == true and vehicle ~= nil then
                if selectedgear > 1 then
                    if IsControlPressed(0,71) then
                        local speed = GetEntitySpeed(vehicle) 
                        local minspeed = currspeedlimit / 7 

                        if speed < minspeed then
                            if GetVehicleCurrentRpm(vehicle) < 0.4 then
                                disable = true
                            end
                        end
                    end
                end
            else
                Citizen.Wait(100) 
            end  
        else
            Citizen.Wait(100) 
        end
    end
end)
end

function xxxxxx()
Citizen.CreateThread(function()
    while manualon do
            
        Citizen.Wait(500)
        if disable == true then
            SetVehicleEngineOn(vehicle,false,true,false)
            Citizen.Wait(1000)
                
            disable = false
        end   

    end
end)
end

function xxxxxxx()
Citizen.CreateThread(function()
    while manualon do
            
        Citizen.Wait(0)
        if vehicle ~= nil and selectedgear ~= 0 then 
            local speed = GetEntitySpeed(vehicle) 
            
            if currspeedlimit ~= nil then
                
                if speed >= currspeedlimit then
                    
                    if Config.enginebrake == true then
                        if speed / currspeedlimit > 1.1 then
                        --print('dead')
                        local hhhh = speed / currspeedlimit
                        SetVehicleCurrentRpm(vehicle,hhhh)
                        SetVehicleCheatPowerIncrease(vehicle,-100.0)
                        --SetVehicleBurnout(vehicle,true)
                        else
                        --SetVehicleBurnout(vehicle,false)
                        SetVehicleCheatPowerIncrease(vehicle,0.0)
                        end
                    else
                        SetVehicleCheatPowerIncrease(vehicle,0.0)
                    end
                    
                    
                    --SetVehicleHandbrake(vehicle, true)
                    --if IsControlPressed(0, 76) == false then
                        --SetVehicleHandlingFloat(vehicle, "CHandlingData", "fHandBrakeForce", 0.0)
                   -- else
                        --SetVehicleHandlingFloat(vehicle, "CHandlingData", "fHandBrakeForce", hbrake)
                    --end


                else  
                    --SetVehicleHandbrake(vehicle, false)
                    --if IsControlPressed(0, 76) == false then
                    
                    --else
                        --SetVehicleHandbrake(vehicle, true)
                        --SetVehicleHandlingFloat(vehicle, "CHandlingData", "fHandBrakeForce", hbrake)
                    --end  
            
                end
            
            else
                
                if speed >= topspeedms then
                    SetVehicleCheatPowerIncrease(vehicle,0.0)
                    --SetVehicleHandbrake(vehicle, true)
                    --if IsControlPressed(0, 76) == false then
                        --SetVehicleHandlingFloat(vehicle, "CHandlingData", "fHandBrakeForce", 0.0)
                    --else
                        --SetVehicleHandlingFloat(vehicle, "CHandlingData", "fHandBrakeForce", hbrake)
                    --end
    
    
                else  
                    --SetVehicleHandbrake(vehicle, false)
                    --if IsControlPressed(0, 76) == false then
                        
                    --else
                        --SetVehicleHandbrake(vehicle, true)
                        --SetVehicleHandlingFloat(vehicle, "CHandlingData", "fHandBrakeForce", hbrake)
                    --end
                end
            end
        end
    end
end)
end

---------------debug

function xxxxxxxxx()
    if Config.gearhud == 1 then
    Citizen.CreateThread(function()
        while manualon do
            Citizen.Wait(0)
            if manualon == true and vehicle ~= nil then
    
            SetTextFont(0)
            SetTextProportional(1)
            SetTextScale(0.0, 0.4)
            SetTextColour(128, 128, 128, 255)
            SetTextDropshadow(0, 0, 0, 0, 255)
            SetTextEdge(1, 0, 0, 0, 255)
            SetTextDropShadow()
            SetTextOutline()
            SetTextEntry("STRING")
        
            AddTextComponentString("~r~Sebességfokozat: ~w~"..getinfo(selectedgear))
        
            EndTextCommandDisplayText(0.015, 0.78)
            else
                Citizen.Wait(100)
            end
        end
    end)
    end
end
--[[elseif Config.gearhud == 2 then  
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(0)
            if manualon == true and vehicle ~= nil then
    
            SetTextFont(0)
            SetTextProportional(1)
            SetTextScale(0.0, 0.3)
            SetTextColour(128, 128, 128, 255)
            SetTextDropshadow(0, 0, 0, 0, 255)
            SetTextEdge(1, 0, 0, 0, 255)
            SetTextDropShadow()
            SetTextOutline()
            SetTextEntry("STRING")
        
            AddTextComponentString("~r~Gear: ~w~"..getinfo(selectedgear).." ~r~Km/h: ~w~"..round((GetEntitySpeed(vehicle)*3.6),0).." ~r~RPM: ~w~"..round(GetVehicleCurrentRpm(vehicle),2))
        
            EndTextCommandDisplayText(0.015, 0.78)
            else
                Citizen.Wait(100)
            end
        end
    end)
end
end)]]

function getinfo2(gea)
        return gea
end

function getinfo(gea)
    if gea == 0 then
        return "N"
    elseif gea == -1 then
        return "R"
    else
        return gea
    end
end

function round(value, numDecimalPlaces)
	if numDecimalPlaces then
		local power = 10^numDecimalPlaces
		return math.floor((value * power) + 0.5) / (power)
	else
		return math.floor(value + 0.5)
	end
end

function xxxxxxxx()
Citizen.CreateThread(function()
    while manualon do
        Citizen.Wait(0)
        --if manualon == true and vehicle ~= nil then
    
        

        SetTextFont(0)
        SetTextProportional(1)
        SetTextScale(0.0, 0.2)
        SetTextColour(128, 128, 128, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(1, 0, 0, 0, 255)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        if manualon == true then
            if realistic == false then
                AddTextComponentString("~r~HRSGears: ~g~On ~r~Mode: ~g~Realistic")
            else
                AddTextComponentString("~r~HRSGears: ~g~On ~r~Mode: ~g~Realistic comfort")
            end
        else
            AddTextComponentString("~r~HRSGears: ~w~Off")
        end
        
        EndTextCommandDisplayText(0.95, 0.005)
    end
end)
end
