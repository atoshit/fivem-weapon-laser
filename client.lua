local enabled, timer = false, 10000

RegisterEvent('atoshi:toggleLaser', function()
    toggleLaser()
end)

function toggleLaser()
    local ped = PlayerPedId()
    if enabled then
        enabled = false
        print("Laser has been disabled")
        timer = 1000
    else
        print("Laser has been enabled")
        Citizen.CreateThread(function()
            enabled = true
            while enabled do
                timer = 1000
                if IsPlayerFreeAiming(PlayerId()) then
                    timer = 0
                    local weapon = GetCurrentPedWeaponEntityIndex(ped)
                    local offset = GetOffsetFromEntityInWorldCoords(weapon, 0, 0, -0.01)
                    local hit, coords = RayCastPed(offset, 150000, ped)
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
    local cameraRotation = GetGameplayCamRot()
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