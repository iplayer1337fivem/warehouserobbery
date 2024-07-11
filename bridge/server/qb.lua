if GetResourceState('qb-core') ~= 'started' then return end

local QBCore = exports['qb-core']:GetCoreObject()

--- @param source integer
function GetPlayer(source)
    if not source then return end

    return QBCore.Functions.GetPlayer(source)
end

function CheckCopCount()
    local amount = 0
    local players = QBCore.Functions.GetQBPlayers()
    for _, Player in pairs(players) do
        if Player.PlayerData.job.type == 'leo' and Player.PlayerData.job.onduty then
            amount += 1
        end
    end
    return amount
end