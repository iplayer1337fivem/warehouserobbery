local config = require 'config.client'

if GetResourceState('es_extended') == 'started' then
    ESX = exports['es_extended']:getSharedObject()
elseif GetResourceState('qb-core') == 'started' then
    QBCore = exports['qb-core']:GetCoreObject()
else
    return
end


function Notify(message, type)
    if config.notify == 'ox_lib' then
        lib.notify({ description = message, type = type, position = 'top' })
    elseif config.notify == 'esx' then
        ESX.ShowNotification(message)
    elseif config.notify == 'qb' then
        QBCore.Functions.Notify(message, type)
    elseif config.notify == 'qbox' then
        exports.qbx_core:Notify(message, type)
    elseif config.notify == 'custom' then
        -- Add your custom notification system here
    end
end

function PoliceDispatch(data)
    if config.dispatch == 'cd_dispatch' then
        local data = exports.cd_dispatch:GetPlayerInfo()
        TriggerServerEvent('cd_dispatch:AddNotification', {
            job_table = 'police',
            coords = data.coords,
            title = '10-50 - Warehouse Robbery',
            message = 'Warehouse is being robbed, respond code 3!',
            flash = 0,
            unique_id = data.unique_id,
            sound = 1,
            blip = {
                sprite = 51,
                scale = 1.0,
                colour = 1,
                flashes = false,
                text = '10-50 | Warehouse Robbery',
                time = 5,
                radius = 0,
            }
        })
    elseif config.dispatch == 'ps-dispatch' then
        exports['ps-dispatch']:SuspiciousActivity()
    elseif config.dispatch == 'custom' then
        -- Add your custom dispatch system here
    else
        lib.print.error('No dispatch system was found - please update your config')
    end
end