local config = require 'config.client'
local sharedConfig = require 'config.shared'
local serverConfig = require 'config.server'
local electricalBoxId = 'electrical_box' -- Do not touch this

local function spawnBoxes()
    for i = 1, #config.boxLocations do
        local coord = config.boxLocations[i].coords
        local model = joaat(config.warehouseObjects[math.random(1, #config.warehouseObjects)])
        lib.requestModel(model)
        local obj = CreateObject(model, coord.x, coord.y, coord.z, false, true, true)
        PlaceObjectOnGroundProperly(obj)
        FreezeEntityPosition(obj, true)
    end
end

local function spawnNPCs()
    for _, npc in pairs(config.npcs) do
        lib.requestModel(joaat(npc.model))
        local ped = CreatePed(4, joaat(npc.model), npc.coords.x, npc.coords.y, npc.coords.z, npc.heading, true, true)
        GiveWeaponToPed(ped, joaat(npc.weapon), 255, false, true)
        SetPedCombatAttributes(ped, 46, true)
        SetPedFleeAttributes(ped, 0, false)
        SetPedCombatAbility(ped, 100)
        SetPedAsEnemy(ped, true)
        SetPedAsCop(ped, true)
        SetPedCombatAbility(ped, 2)
        SetPedAccuracy(ped, npc.accuracy)
        SetPedArmour(ped, npc.armor)
        TaskCombatPed(ped, cache.ped, 0, 16)
    end
end

local function hackSystem()
    local isBusy = lib.callback.await('warehouserobbery:server:checkBusyState', false, electricalBoxId)
    if isBusy then
      Notify(locale('notify.already_hacked'), 'error')
      return
    end

    local cooldown = lib.callback.await('warehouserobbery:server:checkCooldown', false)
    if cooldown then
      Notify(locale('notify.cooldown'), 'error')
      return
    end
  
    local policeCount = lib.callback.await('warehouserobbery:server:getPoliceCount', false)
    if policeCount < sharedConfig.requiredCops then
      Notify(locale('notify.not_enough_police'), 'error')
      return
    end
  
    local hasItem = exports.ox_inventory:Search('count', serverConfig.requiredItem) > 0
    if not hasItem then
      Notify(locale('notify.dont_have_item'), 'error')
      return
    end
  
    TriggerEvent('ultra-voltlab', 30, function(result, reason)
      if result == 0 or result == 2 then
        Notify(locale('notify.failed'), 'error')
        if serverConfig.removeOnFail then
          lib.callback.await('warehouserobbery:server:removeItem', false)
        end
        PoliceDispatch()
      elseif result == 1 then
        Notify(locale('notify.hacked'), 'success')
        TriggerServerEvent('warehouserobbery:server:setBusyState', electricalBoxId, true)
        TriggerServerEvent('warehouserobbery:server:setCooldown')
        spawnNPCs()
        if serverConfig.removeOnUse then
          lib.callback.await('warehouserobbery:server:removeItem', false)
        end
      else
        print('Error occurred:', reason)
      end
      PoliceDispatch()
    end)
  end
  



local function enterWarehouse()
    local isBusy = lib.callback.await('warehouserobbery:server:checkBusyState', false, electricalBoxId) 
    if isBusy then
        DoScreenFadeOut(500)
        Wait(1000)
        spawnBoxes()
        SetEntityCoords(cache.ped, config.warehouseInterior)
        SetEntityHeading(cache.ped, 266.59)
        DoScreenFadeIn(500)
    else
        Notify(locale('notify.entrance_closed'), 'error')
    end
end

local function exitWarehouse()
    DoScreenFadeOut(500)
    Wait(1000)
    SetEntityCoords(cache.ped, config.warehouseEntrance)
    SetEntityHeading(cache.ped, 267.58)
    DoScreenFadeIn(500)
end

local function searchBox(boxName)
    local isBusy = lib.callback.await('warehouserobbery:server:checkBusyState', false, electricalBoxId) 
    if not isBusy then
        Notify(locale('notify.not_hacked'), 'error') -- Possible exploiter
        TriggerServerEvent('warehouserobbery:server:setBusyState', boxName, false)
        return
    end

    if lib.progressCircle({
        duration = 5000,
        label = locale('progress.searching_box'),
        position = 'bottom',
        useWhileDead = false,
        canCancel = true,
        disable = {
            move = true,
            combat = true,
            sprint = true,
            car = true,
        },
        anim = {
            dict = 'anim_heist@arcade@claw@female@',
            clip = 'press_grab'
        },
    }) then 
        local success = lib.callback.await('warehouserobbery:server:reward', false) 
        if success then
            Notify(locale('notify.successfully_searched'), 'success')
        end
    else 
        TriggerServerEvent('warehouserobbery:server:setBusyState', boxName, false)
    end
end

for i, location in ipairs(config.boxLocations) do
    local coords = location.coords
    local boxName = 'box_' .. i
    exports.ox_target:addBoxZone({
        name = boxName,
        debug = config.debugPoly,
        coords = vec3(coords.x, coords.y, coords.z),
        size = vec3(2, 2, 4),
        distance = 1,
        options = {
            {
                name = 'search',
                icon = 'fas fa-search',
                label = locale('target.search_box'),
                onSelect = function()
                    local isBusy = lib.callback.await('warehouserobbery:server:checkBusyState', false, boxName) 
                    if not isBusy then
                        TriggerServerEvent('warehouserobbery:server:setBusyState', boxName, true)
                        searchBox(boxName)
                    else
                        Notify(locale('notify.already_searched'), 'error')
                    end
                end
            }
        }
    })
end

exports.ox_target:addBoxZone({
    coords = config.warehouseEntrance,
    size = vec3(0.5, 3.5, 3.5),
    rotation = 47,
    debug = config.debugPoly,
    distance = 1,
    options = {
        {
            name = 'enter_warehouse',
            icon = 'fas fa-door-open',
            label = locale('target.enter_warehouse'),
            onSelect = function()
                enterWarehouse()
            end
        }
    }
})

exports.ox_target:addBoxZone({
    coords = config.warehouseExit,
    size = vec3(1, 5, 5),
    rotation = 0,
    debug = config.debugPoly,
    distance = 1,
    options = {
        {
            name = 'exit_warehouse',
            icon = 'fas fa-door-open',
            label = locale('target.exit_warehouse'),
            onSelect = function()
                exitWarehouse()
            end
        }
    }
})

exports.ox_target:addBoxZone({
    coords = config.electricalBox,
    size = vec3(0.4, 1, 1),
    rotation = 47,
    debug = config.debugPoly,
    distance = 1,
    options = {
        {
            name = 'hack_system',
            icon = 'fas fa-door-open',
            label = locale('target.hack_system'),
            onSelect = function()
                hackSystem()
            end
        }
    }
})



