local JobBlips                = {}
local Ruote                   = {}

ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()
	refreshBlips()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)

	PlayerData = xPlayer
	refreshBlips()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)

	PlayerData.job = job
	deleteBlips()
	refreshBlips()

	Citizen.Wait(5000)
end)

function deleteBlips()
	if JobBlips[1] ~= nil then
		for i=1, #JobBlips, 1 do
			RemoveBlip(JobBlips[i])
			JobBlips[i] = nil
		end
	end
end

local hasJob = false
local faza1 = false
local faza2 = false
local incarcat = false
local text = false
local text2 = false
local cursaterminata = false

function CreateCar(x,y,z,heading) -- van
	local hash = GetHashKey("mixer2")
    local n = 0
    while not HasModelLoaded(hash) and n < 500 do
        RequestModel(hash)
        Citizen.Wait(10)
        n = n+1
    end
    -- spawn car
    if HasModelLoaded(hash) then
        veh = CreateVehicle(hash,x,y,z,heading,true,false)
        SetEntityHeading(veh,heading)
        SetEntityInvincible(veh,false)
        SetModelAsNoLongerNeeded(hash)
        SetVehicleLights(veh,2)
        SetVehicleColours(veh,147,41)
        SetVehicleNumberPlateTextIndex(veh,2)
		SetVehicleNumberPlateText(veh,"Oil")
		SetPedIntoVehicle(GetPlayerPed(-1),veh,-1)
		SetEntityAsMissionEntity(veh, true, true)
        for i = 0,24 do
            SetVehicleModKit(veh,0)
            RemoveVehicleMod(veh,i)
        end
    end    
end

function DrawText3D(x,y,z, text, scl) 

    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)
 
    local scale = (1/dist)*scl
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov
   
    if onScreen then
        SetTextScale(0.0*scale, 1.1*scale)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
    end
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if not DoesEntityExist(veh) and hasJob then
            hasJob = false
            faza1 = false
            faza2 = false
            faza3 = false
            incarcat = false
            text = false
            text2 = false
            cursaterminata = false
            DeleteEntity(veh)
        end
        local carPos = GetEntityCoords(veh)
        local metri = math.floor(GetDistanceBetweenCoords(3311.3063964844,5176.2182617188,19.614583969116,GetEntityCoords(GetPlayerPed(-1))))
        local metri2 = math.floor(GetDistanceBetweenCoords(2926.9167480469,4301.8979492188,50.434585571289,GetEntityCoords(GetPlayerPed(-1))))
        local metri3 = math.floor(GetDistanceBetweenCoords(1372.0041503906,3623.0671386719,34.87410736084,GetEntityCoords(GetPlayerPed(-1))))
        local pos = GetEntityCoords(GetPlayerPed(-1))
        if faza1 == true then
            if metri2 <=4 then
                if Ruote[1] ~= nil then
                    for i=1, #Ruote, 1 do
                        RemoveBlip(Ruote[i])
                        ClearAllBlipRoutes()
                        Ruote[i] = nil
                    end
                end
                if not text then
                    DrawText3D(2926.9167480469,4301.8979492188,50.434585571289, "Press [~g~E~w~] to load the truck", 1.2)
                    DrawMarker(1, 2926.9167480469,4301.8979492188,50.434585571289 , 0, 0, 0, 0, 0, 0, 0.5001,0.5001,0.5001, 255,0,0, 200, 0, 0, 0, 1, 0, 0, 0)
                    if IsControlJustPressed(1,51) then
                        if (Vdist(pos.x, pos.y, pos.z, carPos.x , carPos.y, carPos.z) <= 50.0) and hasJob and faza1 and DoesEntityExist(veh) then
                            if incarcat == false then   
                                FreezeEntityPosition(veh,true)
                                text = true
                                incarcat = true
                                faza2 = true
                                faza1 = false
                                exports['progressBars']:startUI(20000, "Loading the truck...")
                                Wait(20000) 
                                ESX.ShowNotification('You loaded the truck, go and deliverit')

                                blip = AddBlipForCoord(1373.8408203125,3613.7844238281)

                                SetBlipHighDetail(blip, true)
                                SetBlipSprite (blip, 1)
                                SetBlipScale  (blip, 0.8)
                                SetBlipColour (blip, 5)
                                SetBlipAsShortRange(blip, true)
                                SetBlipRoute(blip, true)
                                SetBlipRouteColour(blip, 5)
            
                                BeginTextCommandSetBlipName("STRING")
                                AddTextComponentString("Fueler - Deliver Oil")
                                EndTextCommandSetBlipName(blip)
                                table.insert(Ruote, blip)

                                FreezeEntityPosition(veh,false)
                            else
                                ESX.ShowNotification('You already have loaded the truck')
                            end
                        else
                            ESX.ShowNotification('Why are you Marlan?')
                            hasJob = false
                            faza1 = false
                            faza2 = false
                            incarcat = false
                            text = false
                            text2 = false
                            cursaterminata = false
                            DeleteEntity(veh)
                        end
                    end
                elseif text == true then
                    DrawText3D(2926.9167480469,4301.8979492188,50.434585571289, "~y~Go and deliver the oil", 1.2)
                end
            end
        end
        if faza2 then
            if metri3 <=4 then
                if Ruote[1] ~= nil then
                    for i=1, #Ruote, 1 do
                        RemoveBlip(Ruote[i])
                        ClearAllBlipRoutes()
                        Ruote[i] = nil
                    end
                end
                DrawText3D(1372.0041503906,3623.0671386719,34.87410736084, "Press [~g~E~w~] ~w~to unload the truck", 1.2)
                DrawMarker(1, 1372.0041503906,3623.0671386719,34.87410736084 , 0, 0, 0, 0, 0, 0, 0.5001,0.5001,0.5001, 255,0,0, 200, 0, 0, 0, 1, 0, 0, 0)
                if IsControlJustPressed(1,51) then         
                    if (Vdist(pos.x, pos.y, pos.z, carPos.x , carPos.y, carPos.z) <= 50.0) and hasJob and faza2 and DoesEntityExist(veh) then 
                        FreezeEntityPosition(veh,true)
                        exports['progressBars']:startUI(20000, "Unloading the truck...")
                        Wait(20000) 
                        cursaterminata = true
                        TriggerServerEvent('esx_petrolier:finish')
                        hasJob = false
                        faza1 = false
                        faza2 = false
                        incarcat = false
                        text = false
                        text2 = false
                        cursaterminata = false
                        DeleteEntity(veh)
                    else
                        ESX.ShowNotification('Why are you Marlan?')
                        hasJob = false
                        faza1 = false
                        faza2 = false
                        incarcat = false
                        text = false
                        text2 = false
                        cursaterminata = false
                        DeleteEntity(veh)
                    end
                end
            end
        end
        if metri <=2 and PlayerData.job ~= nil and (PlayerData.job.name == 'fueler' or PlayerData.org.name == 'fueler') then
            DrawText3D(pos.x,pos.y,pos.z+0.3, "Press [~g~E~w~] for start the job", 1.2)
            if IsControlJustPressed(1,51) then
                if hasJob == false then
                    ESX.ShowNotification('Go to load the oil')
                    hasJob = true
                    CreateCar(3321.9079589844,5149.1767578125,18.262245178223,150.0)
                    faza1 = true
                    blip = AddBlipForCoord(2926.9167480469,4301.8979492188,50.434585571289)

                    SetBlipHighDetail(blip, true)
                    SetBlipSprite (blip, 1)
                    SetBlipScale  (blip, 0.8)
                    SetBlipColour (blip, 5)
                    SetBlipAsShortRange(blip, true)
                    SetBlipRoute(blip, true)
                    SetBlipRouteColour(blip, 5)
            
                    BeginTextCommandSetBlipName("STRING")
                    AddTextComponentString("Fueler - Load Oil")
                    EndTextCommandSetBlipName(blip)
                    table.insert(Ruote, blip)
                else
                    ESX.ShowNotification('You already make this job')
                end
            end
        end
    end
end)

function refreshBlips()
    if PlayerData.job ~= nil and (PlayerData.job.name == 'fueler' or PlayerData.org.name == 'fueler') then
		blip = AddBlipForCoord(3311.3063964844,5176.2182617188,19.614583969116)

		SetBlipHighDetail(blip, true)
		SetBlipSprite (blip, 361)
		SetBlipScale  (blip, 0.8)
		SetBlipColour (blip, 5)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Fueler - Start Job")
		EndTextCommandSetBlipName(blip)
        table.insert(JobBlips, blip)
    end
end