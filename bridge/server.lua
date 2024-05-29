if GetResourceState('qbx_core') == 'started' then
    framework = 'qbox'
elseif GetResourceState('es_extended') == 'started' then
    ESX = exports.es_extended:getSharedObject()
    framework = 'esx'
elseif GetResourceState('qb-core') == 'started' then
    QBCore = exports['qb-core']:GetCoreObject()
    framework = 'qb'
else
    lib.print.error('No supported framework was found')
    return
end


function GetPlayer(source)
    if not source then return end

    if framework == 'esx' then
        return ESX.GetPlayerFromId(source)
    elseif framework == 'qb' then
        return QBCore.Functions.GetPlayer(source)
    elseif framework == 'qbox' then
        return exports.qbx_core:GetPlayer(source)
    else
        return
    end
end

function PlayersWithJob(jobName)
    if not jobName then return end
    local jobCount = 0
    
    if framework == 'esx' then
        for _, player in pairs(ESX.GetExtendedPlayers()) do
            local job = player.getJob()
            for _, jobNames in pairs(jobName) do
                if job.name == jobNames then
                    jobCount = jobCount + 1
                end
            end
        end
    elseif framework == 'qb' then
        for _, playerId in pairs(QBCore.Functions.GetPlayers()) do
            local player = QBCore.Functions.GetPlayer(playerId)
            local job = player.PlayerData.job
            for _, jobNames in pairs(jobName) do
                if job.name == jobNames then
                    jobCount = jobCount + 1
                end
            end
        end
    elseif framework == 'qbox' then
        jobCount = exports.qbx_core:GetDutyCountJob(jobName)
    else
        return
    end

    return jobCount
end
