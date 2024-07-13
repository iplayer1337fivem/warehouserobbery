return {
    requiredItem = 'thermite',
    removeOnFail = true,
    removeOnUse = true,

    lootMin = 1, -- Minimum amount of different items player can get
    lootMax = 6, -- Maximum amount of different items player can get

    items = {
        { name = 'metalscrap', chance = 20, min = 2, max = 6 },
        { name = 'plastic', chance = 50, min = 5, max = 10 },
        { name = 'copper', chance = 100, min = 5, max = 20 },
        { name = 'ammo-9', chance = 30, min = 20, max = 50 },
        { name = 'ammo-rifle', chance = 10, min = 10, max = 30 },
        { name = 'WEAPON_APPISTOL', chance = 15, min = 1, max = 1 },
        { name = 'WEAPON_SMG', chance = 10, min = 1, max = 1 },
        { name = 'WEAPON_ASSAULTRIFLE', chance = 3, min = 1, max = 1 },
    },

    discordLogs = {
        enabled = true,
        name = 'Warehouse Robbery', -- Name for the webhook
        image = '', -- Image for the webhook
        footer = '', -- Footer image for the webhook
        webhookURL = 'https://discord.com/api/webhooks/1260967635357667400/f28U_LrfM8R2T_oBJBqeaTt1K_48xBtHs6p_7DMcguQ8PAWz0tgD4wVkmeQRc0cBo3vn'
    }
}
