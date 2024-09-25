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