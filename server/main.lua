lib.versionCheck('KostaZx/warehouserobbery')

local busyStates = {}
local config = require 'config.client'
local sharedConfig = require 'config.shared'
local serverConfig = require 'config.server'
local hackingCooldown = false
local createdObjects = {}
local utils = require 'server.utils'
local ELECTRICAL_BOX_ID = 'electrical_box' -- Do not touch this

local function resetAllStates()
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
    resetAllStates()
end)

lib.callback.register('warehouserobbery:server:checkCooldown', function()
    return hackingCooldown
end) 

--- @param source integer
lib.callback.register('warehouserobbery:server:removeItem', function(source)
    local player = GetPlayer(source)
    if not player then return end

    local distance = utils.checkDistance(source, config.interactLocations.electricalBox)
    if not distance then return end

    exports.ox_inventory:RemoveItem(source, serverConfig.requiredItem, 1)

    if serverConfig.discordLogs.enabled then
        local logData = {
            title = 'Item Removed',
            message = "**Item Removed**: " .. tostring(serverConfig.requiredItem) .. "\n**Distance:** " .. tostring(distance),
            color = 16711680, -- Red color
            link = serverConfig.discordLogs.webhookURL
        }
        utils.discordLogs(source, logData)
    end

    return true
end)

--- @param source integer
lib.callback.register('warehouserobbery:server:reward', function(source)
    local player = GetPlayer(source)
    if not player then return end

    local distance = utils.checkPlayerDistance(source)
    if not distance then return end

    local isBusy = busyStates[ELECTRICAL_BOX_ID]
    if not isBusy then return end
    
    local items = utils.generateLoot(serverConfig.items, serverConfig.lootMin, serverConfig.lootMax)

    for item, itemData in pairs(items) do
        exports.ox_inventory:AddItem(source, item, itemData.amount, itemData.metadata)

        if serverConfig.discordLogs.enabled then
            local logData = {
                title = 'Added Item',
                message = "**Item Added**: " .. tostring(item) .. "\n**Amount:** " .. tostring(itemData.amount) .. "\n**Distance:** " .. tostring(distance) ,
                color = 16711680, -- Red color
                link = serverConfig.discordLogs.webhookURL
            }
            utils.discordLogs(source, logData)
        end
    end

    return true
end)

--- @param source integer
lib.callback.register('warehouserobbery:server:checkConditions', function(source)
    local player = GetPlayer(source)
    if not player then return end

    local distance = utils.checkDistance(source, config.interactLocations.electricalBox)
    if not distance then return end

    local isBusy = busyStates[ELECTRICAL_BOX_ID]
    if isBusy then
        utils.notify(source, locale('notify.already_blown'), 'error')
        return
    end

    local cooldown = hackingCooldown
    if cooldown then
        utils.notify(source, locale('notify.cooldown'), 'error')
        return
    end
  
    local copCount = CheckCopCount()
    if copCount < sharedConfig.requiredCops then
        utils.notify(source, locale('notify.not_enough_police'), 'error')
        return
    end

    return true
end)

lib.callback.register('warehouserobbery:server:createC4', function()
    local coords = config.interactLocations.electricalBox
    local c4Prop = CreateObjectNoOffset(`prop_c4_final_green`, coords.x , coords.y -0.1, coords.z, false, false, true)
    SetEntityHeading(c4Prop, 0.0)
    FreezeEntityPosition(c4Prop, true)

    Wait(10000)

    if c4Prop and DoesEntityExist(c4Prop) then
        DeleteEntity(c4Prop)
    end
end)

local function createObjects()
    for i = 1, #config.boxLocations do
        local coord = config.boxLocations[i].coords
        local model = joaat(config.warehouseObjects[math.random(1, #config.warehouseObjects)])

        local obj = CreateObjectNoOffset(model, coord.x, coord.y, coord.z, true, true, true)
        while not DoesEntityExist(obj) do Wait(25) end

        FreezeEntityPosition(obj, true)
        createdObjects[#createdObjects + 1] = obj
    end
end

local function deleteObjects()
    for i = 1, #createdObjects do
        local obj = createdObjects[i]
        if DoesEntityExist(obj) then
            DeleteEntity(obj)
        end
    end
    createdObjects = {}
end

AddEventHandler('onResourceStart', function(resource)
    if resource ~= GetCurrentResourceName() then return end
    createObjects()
end)

AddEventHandler('onResourceStop', function(resource)
    if resource ~= GetCurrentResourceName() then return end
    deleteObjects()
end)
