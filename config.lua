Config = {}

Config.HasSpawn = true and GetResourceState('qb-spawn') ~= 'missing' or false
Config.HasClothing = true and GetResourceState('qb-clothing') ~= 'missing' or false
Config.StartingApartment = true -- if set to false. Skips appartment choice in the beggining (if true requires qb-spawn)
Config.EnableDeleteButton = true -- Define if the player can delete the character or not
Config.DefaultNumberOfCharacters = 3 -- Define maximum amount of default characters (maximum 3 characters defined by default)
Config.PlayersNumberOfCharacters = { -- Define maximum amount of player characters by rockstar license (you can find this license in your server's database in the player table)
    ['license2:e539d0b049cc56f7a052c89fe1552e0f19d203bf'] = 5,
}

Config.Locations = {
    [1] = {
        PedCoords = vector4(969.25, 72.61, 116.18, 276.55),
        HiddenCoords = vector4(973.55, 77.18, 116.18, 225.01),
        CamCoords = vector4(972.2, 72.9, 116.68, 97.27),
    },
    [2] = {
        PedCoords = vector4(1104.49, 195.9, -49.44, 44.22),
        HiddenCoords = vector4(1096.63, 200.98, -49.44, 238.62),
        CamCoords = vector4(1102.29, 198.14, -48.86, 225.07),
    },
    [3] = {
        PedCoords = vector4(-2163.87, 1134.51, -24.37, 310.05),
        HiddenCoords = vector4(-2162.13, 1146.68, -24.37, 184.39),
        CamCoords = vector4(-2161.7, 1136.4, -23.77, 131.52),
    },
    [4] = {
        PedCoords = vector4(-996.71, -68.07, -99.0, 57.61),
        HiddenCoords = vector4(-1000.02, -60.96, -99.0, 206.67),
        CamCoords = vector4(-999.90, -66.30, -98.45, 241.68),
    },
    [5] = {
        PedCoords = vector4(-1023.45, -418.42, 67.66, 205.69),
        HiddenCoords = vector4(-1025.91, -422.48, 67.66, 296.65),
        CamCoords = vector4(-1021.8, -421.7, 68.14, 27.11),
    },
    [6] = {
        PedCoords = vector4(2265.27, 2925.02, -84.8, 267.77),
        HiddenCoords = vector4(2271.14, 2925.0, -84.8, 119.79),
        CamCoords = vector4(2268.24, 2925.02, -84.36, 90.88),
    }
}
