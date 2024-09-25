local enabled = false

RegisterNetEvent('atoshi:toggleLaser', function()
    if enabled then
        enabled = false
        ESX.ShowNotification("Le laser des armes est désactivé")
    else
        ESX.ShowNotification("Le laser des armes est activé")
        Citizen.CreateThread(function()
            enabled = true
            while enabled do
                if IsPlayerFreeAiming(PlayerId()) then
                    local weapon = GetCurrentPedWeaponEntityIndex(PlayerPedId())
                    local offset = GetOffsetFromEntityInWorldCoords(weapon, 0, 0, -0.01)
                    local hit, coords = RayCastPed(offset, 150000, PlayerPedId())
                    if hit ~= 0 then
                        DrawLine(offset.x, offset.y, offset.z, coords.x, coords.y, coords.z, 10, 246, 0, 255)
                        DrawSphere2(coords, 0.01, 10, 246, 0, 255)
                    end
                    Citizen.Wait(0)
                else
                    Citizen.Wait(1000)
                end

                if not enabled then
                    break
                end
            end
        end)
    end
end)

--- Convertit une rotation en direction
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

--- Raycast pour obtenir la position frappée
---@param pos table
---@param distance number
---@param ped number
function RayCastPed(pos, distance, ped)
    local cameraRotation = GetGameplayCamRot(2)
    local direction = RotationToDirection(cameraRotation)
    local destination = {
        x = pos.x + direction.x * distance,
        y = pos.y + direction.y * distance,
        z = pos.z + direction.z * distance
    }

    local hit, coords = GetShapeTestResult(StartShapeTestRay(pos.x, pos.y, pos.z, destination.x, destination.y, destination.z, -1, ped, 1))
    return hit, coords
end

--- Dessine une sphère à une position donnée
---@param pos table
---@param radius number
---@param r number
---@param g number
---@param b number
---@param a number
function DrawSphere2(pos, radius, r, g, b, a)
    DrawMarker(28, pos.x, pos.y, pos.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, radius, radius, radius, r, g, b, a, false, false, 2, nil, nil, false)
end