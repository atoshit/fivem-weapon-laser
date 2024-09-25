ESX.RegisterServerCallback('atoshi:hasItem', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        if xPlayer.hasItem(Config.itemName).count > 0 then
            cb(true)
        else
            cb(false)
        end
    end
end)

RegisterNetEvent('atoshi:toggleLaser', function(state)
    local playerId = source
    if state then
        TriggerClientEvent('esx:showNotification', playerId, "Laser activé.")
    else
        TriggerClientEvent('esx:showNotification', playerId, "Laser désactivé.")
        TriggerClientEvent('atoshi:clearLaser', -1, playerId)
    end
end)

RegisterNetEvent('atoshi:updateLaser', function(offset, coords)
    local playerId = source
    TriggerClientEvent('atoshi:syncLaser', -1, playerId, offset, coords)
end)