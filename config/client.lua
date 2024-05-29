return {
    notify = 'qbox', -- 'ox_lib', 'esx', 'qb', 'qbox', 'custom'
    dispatch = 'ps-dispatch', -- 'cd_dispatch', 'ps-dispatch', 'custom'

    minCooldown = 30, -- In mintes
    maxCooldown = 60, -- In minutes

    debugPoly = false,

    electricalBox = vec3(-1067.1680, -2006.2613, 14.7739),
    warehouseEntrance = vec3(-1056.9133, -2003.8285, 14.3616),
    warehouseInterior = vec3(1027.5515, -3101.7664, -38.9999), 
    warehouseExit = vec3(1027.9515, -3101.7664, -38.9999), 

    boxLocations = { 
        [1] = { id = 1, coords = vec3(1018.1041, -3108.5, -40) },
        [2] = { id = 2, coords = vec3(1015.5176, -3108.5, -40) },
        [3] = { id = 3, coords = vec3(1013.2429, -3108.5, -40) },
        [4] = { id = 4, coords = vec3(1010.8519, -3108.5, -40) },
        [5] = { id = 5, coords = vec3(1008.5016, -3108.5, -40) },
        [6] = { id = 6, coords = vec3(1006.1173, -3108.5, -40) },
        [7] = { id = 7, coords = vec3(1003.4443, -3108.5, -40) },
    
        [8] = { id = 8, coords = vec3(1018.1041, -3102.7, -40) },
        [9] = { id = 9, coords = vec3(1015.5176, -3102.7, -40) },
        [10] = { id = 10, coords = vec3(1013.2429, -3102.7, -40) },
        [11] = { id = 11, coords = vec3(1010.8519, -3102.7, -40) },
        [12] = { id = 12, coords = vec3(1008.5016, -3102.7, -40) },
        [13] = { id = 13, coords = vec3(1006.1173, -3102.7, -40) },
        [14] = { id = 14, coords = vec3(1003.4443, -3102.7, -40) },
        
        [15] = { id = 15, coords = vec3(1018.1041, -3097, -40) },
        [16] = { id = 16, coords = vec3(1015.5176, -3097, -40) },
        [17] = { id = 17, coords = vec3(1013.2429, -3097, -40) },
        [18] = { id = 18, coords = vec3(1010.8519, -3097, -40) },
        [19] = { id = 19, coords = vec3(1008.5016, -3097, -40) },
        [20] = { id = 20, coords = vec3(1006.1173, -3097, -40) },
        [21] = { id = 21, coords = vec3(1003.4443, -3097, -40) },
    },
    
    warehouseObjects = { 
        'prop_boxpile_05a',
        'prop_boxpile_04a',
        'prop_boxpile_06b',
        'prop_boxpile_02c',
        'prop_boxpile_02b',
        'prop_boxpile_01a',
        'prop_boxpile_08a',
    },

    npcs = {
        { model = 's_m_m_security_01', coords = vec3(998.8849, -3111.4160, -38.9999), heading = 90.0, weapon = 'WEAPON_CARBINERIFLE', armor = 200, accuracy = 100 },
        { model = 's_m_m_security_01', coords = vec3(999.9012, -3099.2932, -38.9999), heading = 270.0, weapon = 'WEAPON_CARBINERIFLE', armor = 200, accuracy = 100 },
        { model = 's_m_m_security_01', coords = vec3(1001.6360, -3092.2385, -38.9999), heading = 90.0, weapon = 'WEAPON_CARBINERIFLE', armor = 200, accuracy = 100 }, 
        { model = 's_m_m_security_01', coords = vec3(993.8922, -3099.9907, -38.9958), heading = 90.0, weapon = 'WEAPON_CARBINERIFLE', armor = 200, accuracy = 100 },
    }
}
