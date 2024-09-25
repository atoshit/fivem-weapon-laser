RegisterCommand("draw:laser", function()
    local player = ESX.GetPlayerFromId(source)
    local hasItem = (player.getInventoryItem(Config.itemName) > 0 and true or false)

    if player then
        if hasItem then
            TriggerClientEvent('atoshi:toggleLaser', source)
        else
            player.showNotification("Vous n'avez pas de laser")
        end
    end
end)

RegisterKeyMapping("draw:laser", "Activer/Désactiver le laser", "keyboard", "E")