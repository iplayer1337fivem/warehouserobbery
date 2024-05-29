lib.versionCheck('KostaZx/warehouserobbery')

local busyStates = {}
local config = require 'config.client'
local serverConfig = require 'config.server'
local hackingCooldown = false

function ResetAllStates()
    for entityId, _ in pairs(busyStates) do
        busyStates[entityId] = false
    end
end

RegisterNetEvent('warehouserobbery:server:setBusyState')
AddEventHandler('warehouserobbery:server:setBusyState', function(entityId, isBusy)
    busyStates[entityId] = isBusy
end)

lib.callback.register('warehouserobbery:server:checkBusyState', function(_, entityId) 
    local state = busyStates[entityId] or false
    return state
end)

RegisterNetEvent('warehouserobbery:server:setCooldown', function()
    local minutes = 60000
    hackingCooldown = true  
    local cooldown = math.random(config.minCooldown, config.maxCooldown) * minutes
    Wait(cooldown)
    hackingCooldown = false
    ResetAllStates()
end)

lib.callback.register('warehouserobbery:server:checkCooldown', function()
    return hackingCooldown
end)

lib.callback.register('warehouserobbery:server:removeItem', function(source)
    local player = GetPlayer(source)
    if not player then return end

    exports.ox_inventory:RemoveItem(source, serverConfig.requiredItem, 1)
    return true
end)

local function checkPlayerDistance(source)
    if not source then return false end

    local ped = GetPlayerPed(source)
    local playerPos = GetEntityCoords(ped)
    for _, locations in pairs(config.boxLocations) do
        for _, location in pairs(locations) do
            local distance = #(playerPos - location)
            if distance < 10 then
                return true
            end
        end
    end
    return false
end

lib.callback.register('warehouserobbery:server:reward', function(source)
    local player = GetPlayer(source)
    if not player then return end

    local distance = checkPlayerDistance(source)
    if not distance then return end

    local totalChance = 0
    for _, item in ipairs(serverConfig.items) do
        totalChance = totalChance + item.chance
    end

    local randomChance = math.random(1, totalChance)
    local selectedItem
    local chance = 0
    for _, item in ipairs(serverConfig.items) do
        chance = chance + item.chance
        if randomChance <= chance then
            selectedItem = item
            break
        end
    end

    local amount = math.random(selectedItem.min, selectedItem.max)
    exports.ox_inventory:AddItem(source, selectedItem.name, amount)

    return true
end)

    
  
lib.callback.register('warehouserobbery:server:getPoliceCount', function()
    local policeCount = PlayersWithJob('police')
    return policeCount or 0
end)


