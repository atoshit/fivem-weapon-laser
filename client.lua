local enabled = false
local lasers = {}

RegisterCommand("draw:laser", function()
    ESX.TriggerServerCallback("atoshi:hasItem", function(hasItem)
        if hasItem == true then
            toggleLaser()
        else
            ESX.ShowNotification("Vous n'avez pas l'objet nécessaire pour activer le laser.")
        end
    end)
end)

RegisterKeyMapping("draw:laser", "Activer/Désactiver le laser", "keyboard", "E")

function toggleLaser()
    if not IsPedArmed(PlayerPedId(), 4) then
        ESX.ShowNotification("Vous devez avoir une arme équipée pour activer le laser.")
        return
    end

    if enabled then
        enabled = false
        ESX.ShowNotification("Le laser des armes est désactivé")
        TriggerServerEvent('atoshi:toggleLaser', false)
    else
        enabled = true
        ESX.ShowNotification("Le laser des armes est activé")
        Citizen.CreateThread(function()
            while enabled do
                if IsPlayerFreeAiming(PlayerId()) then
                    local weapon = GetCurrentPedWeaponEntityIndex(PlayerPedId())
                    local offset = GetOffsetFromEntityInWorldCoords(weapon, 0, 0, -0.01)
                    local hit, coords = RayCastPed(offset, 150000, PlayerPedId())
                    if hit ~= 0 then
                        TriggerServerEvent('atoshi:updateLaser', offset, coords)
                    end
                else
                    TriggerServerEvent('atoshi:removeLaser')
                end
                Citizen.Wait(0)
            end
        end)
    end
end

RegisterNetEvent('atoshi:syncLaser', function(playerId, offset, coords)
    lasers[playerId] = { offset = offset, coords = coords }
end)

RegisterNetEvent('atoshi:clearLaser', function(playerId)
    lasers[playerId] = nil
end)

Citizen.CreateThread(function()
    while true do
        for _, laserData in pairs(lasers) do
            if laserData then
                DrawLine(laserData.offset.x, laserData.offset.y, laserData.offset.z, laserData.coords.x, laserData.coords.y, laserData.coords.z, 10, 246, 0, 255)
                DrawSphere2(laserData.coords, 0.01, 10, 246, 0, 255)
            end
        end
        Citizen.Wait(0)
    end
end)

--- Get the direction of a rotation
---@param rotation table
local function RotationToDirection(rotation)
    local adjustedRotation = {
        x = (math.pi / 180) * rotation.x,
        y = (math.pi / 180) * rotation.y,
        z = (math.pi / 180) * rotation.z
    }
    local direction = {
        x = -math.sin(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
        y = math.cos(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
        z = math.sin(adjustedRotation.x)
    }
    return direction
end

--- RayCastPed
---@param pos table
---@param distance number
---@param ped number
function RayCastPed(pos,distance,ped)
    local cameraRotation = GetGameplayCamRot(2)
    local direction = RotationToDirection(cameraRotation)
    local destination = {
        x = pos.x + direction.x * distance,
        y = pos.y + direction.y * distance,
        z = pos.z + direction.z * distance
    }

    local a, b, c, d, e = GetShapeTestResult(StartShapeTestRay(pos.x, pos.y, pos.z, destination.x, destination.y, destination.z, -1, ped, 1))
    return b, c
end

--- Draw a line between two points
---@param pos table
---@param radius number
---@param r number
---@param g number
---@param b number
---@param a number
function DrawSphere2(pos, radius, r, g, b, a)
    DrawMarker(28, pos.x, pos.y, pos.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, radius, radius, radius, r, g, b, a, false, false, 2, nil, nil, false)
end
