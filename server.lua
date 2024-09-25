RegisterCommand("draw:laser", function()
    local player = ESX.GetPlayerFromId(source)

    if player then
        if player.hasItem(Config.itemName) then
            TriggerClientEvent('atoshi:toggleLaser', source)
        else
            player.showNotification("Vous n'avez pas de laser")
        end
    end
end)