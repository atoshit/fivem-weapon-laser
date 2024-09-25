local enabled, timer = false, 10000

RegisterCommand("draw:laser", function()
    ESX.TriggerServerCallback("atoshi:hasItem", function(hasItem)
        if hasItem == true then
            drawLaser()
        else
            ESX.ShowNotification("Vous n'avez pas l'objet nécessaire pour activer le laser.")
        end
    end)
end)
RegisterKeyMapping("draw:laser", "Activer/Désactiver le laser", "keyboard", "E")

function drawLaser()
    if not IsPedArmed(PlayerPedId(), 4) then
        return
    end

    if enabled then
        enabled = false
        ESX.ShowNotification("Le laser des armes est désactivé")
        timer = 1000
    else
        FreezeEntityPosition(PlayerPedId(), true)
        RequestAnimDict("anim@mp_player_intmenu@key_fob@")
        repeat Wait(0) until HasAnimDictLoaded("anim@mp_player_intmenu@key_fob@")
        TaskPlayAnim(PlayerPedId(), "anim@mp_player_intmenu@key_fob@", "fob_click", 8.0, -8.0, -1, 50, 0, false, false, false)
        Wait(1000)
        ClearPedTasks(PlayerPedId())
        FreezeEntityPosition(PlayerPedId(), false)
        ESX.ShowNotification("Le laser des armes est activé")
        Citizen.CreateThread(function()
            enabled = true
            while enabled do
                timer = 1000
                if IsPlayerFreeAiming(PlayerId()) then
                    timer = 0
                    local weapon = GetCurrentPedWeaponEntityIndex(PlayerPedId())
                    local offset = GetOffsetFromEntityInWorldCoords(weapon, 0, 0, -0.01)
                    local hit, coords = RayCastPed(offset, 150000, PlayerPedId())
                    if hit ~= 0 then
                        DrawLine(offset.x, offset.y, offset.z, coords.x, coords.y, coords.z, 10, 246, 0, 255)
                        DrawSphere2(coords, 0.01, 10, 246, 0, 255)
                    end
                end
                Citizen.Wait(timer)
            end
        end)
    end
end

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