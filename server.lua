ESX.RegisterServerCallback('atoshi:hasItem', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        print("Oui")
        print(xPlayer.hasItem(Config.itemName))
        cb(xPlayer.hasItem(Config.itemName))
    end
end)