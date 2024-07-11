local utils = {}
local config = require 'config.client'
local serverConfig = require 'config.server'

--- @param source integer
--- @param message string
--- @param type string
function utils.notify(source, message, type)
    if config.notify == 'ox_lib' then
        TriggerClientEvent('ox_lib:notify', source, { description = message, type = type, position = 'top' })
    elseif config.notify == 'esx' then
        TriggerClientEvent('esx:showNotification', source, message, type)
    elseif config.notify == 'qb' then
        TriggerClientEvent('QBCore:Notify', source, message, type)
    elseif config.notify == 'qbox' then
        exports.qbx_core:Notify(source, message, type)
    elseif config.notify == 'nd' then
        local player = NDCore:getPlayer(source)
        if not player then return end
        player.notify({ title = message, type = type })
    elseif config.notify == 'custom' then
        -- Add your custom notification system here
    end
end

local function getAmount(item)
    return item.amount or (item.min and item.max and math.random(item.min, item.max)) or 1
end

--- @param items table
--- @param minLoot number
--- @param maxLoot number
function utils.generateLoot(items, minLoot, maxLoot)
    if not items or #items == 0 then
        lib.print.error('Invalid loot configuration: no items provided')
        return {}
    end

    local loot = {}
    local lootAmount = 0
    local attempts = 0
    local maxAttempts = 100

    while lootAmount < minLoot and attempts < maxAttempts do
        for i = 1, #items do
            if lootAmount >= maxLoot then
                break
            end

            local item = items[i]
            local chance = math.random(100)

            if chance <= item.chance then
                local amount = getAmount(item)

                if amount and amount > 0 then
                    if not loot[item.name] then
                        lootAmount = lootAmount + 1
                        loot[item.name] = {
                            amount = amount,
                            metadata = item.metadata or nil
                        }
                    else
                        loot[item.name].amount = math.min(loot[item.name].amount + amount, item.max)
                    end

                    if lootAmount >= maxLoot then
                        break
                    end
                end
            end
        end
        attempts = attempts + 1
    end

    if lootAmount < minLoot then
        return utils.generateLoot(items, minLoot, maxLoot)
    end

    return loot
end

--- @param source integer
function utils.checkPlayerDistance(source)
    if not source then return false end

    local ped = GetPlayerPed(source)
    local plyPos = GetEntityCoords(ped)
    for _, locations in pairs(config.boxLocations) do
        for _, location in pairs(locations) do
            local distance = #(plyPos - location)
            if distance < 5 then
                return true
            end
        end
    end
    return false
end

--- @param source integer
--- @param location vector3
function utils.checkDistance(source, location)
    if not source then return false end

    local ped = GetPlayerPed(source)
    local plyPos = GetEntityCoords(ped)
    print(ped, plyPos)
    local distance = #(plyPos - location)
    
    if distance < 5 then 
        return true 
    end

    return false
end

--- @param source integer
--- @param data table
function utils.discordLogs(source, data)
    local playerName = GetPlayerName(source)
    local identifiers = GetPlayerIdentifiers(source)
    local playerIdentifier = identifiers[1] or 'N/A'
    local playerDiscordId = 'N/A'
    local playerSteamId = 'N/A'
    local playerLicense = 'N/A'
    
    for _, id in ipairs(identifiers) do
        if string.match(id, 'discord:') then
            playerDiscordId = string.gsub(id, 'discord:', '')
        elseif string.match(id, 'steam:') then
            playerSteamId = string.gsub(id, 'steam:', '')
        elseif string.match(id, 'license:') then
            playerLicense = string.gsub(id, 'license:', '')
        end
    end

    local logMessage = string.format(
        "%s\n**Player:** %s\n**Identifier:** ||%s||\n**Discord ID:** ||%s||\n**Steam ID:** ||%s||\n**License:** ||%s||",
        data.message, playerName, playerIdentifier, playerDiscordId, playerSteamId, playerLicense
    )

    local embed = {{
        ["color"] = data.color,
        ["title"] = "**" .. data.title .. "**",
        ["description"] = logMessage,
        ["footer"] = {
            ["text"] = os.date("%a %b %d, %I:%M%p"),
            ["icon_url"] = serverConfig.discordLogs.footer
        }
    }}
    PerformHttpRequest(data.link, function(err, text, headers) end, 'POST', json.encode({
        username = serverConfig.discordLogs.name,
        embeds = embed,
        avatar_url = serverConfig.discordLogs.image
    }), { ['Content-Type'] = 'application/json' })
end


return utils