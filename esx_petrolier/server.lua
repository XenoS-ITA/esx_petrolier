ESX = nil

TriggerEvent("esx:getSharedObject", function(obj) 
    ESX = obj 
end)

RegisterServerEvent('esx_petrolier:finish')
AddEventHandler('esx_petrolier:finish', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local _source = source
    local random = math.random(250, 500)

        xPlayer.addMoney(random)
        TriggerClientEvent('esx:showNotification', _source, "Ai primit "..random)
end)