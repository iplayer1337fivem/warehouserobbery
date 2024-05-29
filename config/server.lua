return {

    requiredItem = 'thermite', -- Item required to hack the box
    removeOnFail = true, -- Remove the item from the player's inventory if the hacking fails
    removeOnUse = true, -- Remove the item from the player's inventory when the box is hacked

    items = {
        { name = 'metalscrap', chance = 5, min = 2, max = 6 },
        { name = 'plastic', chance = 50, min = 5, max = 10 },
        { name = 'copper', chance = 100, min = 10, max = 20 },
    },
}