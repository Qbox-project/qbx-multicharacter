local QBCore = exports['qb-core']:GetCoreObject()
local hasDonePreloading = {}

local function GiveStarterItems(source)
    local Player = QBCore.Functions.GetPlayer(source)

    for _, v in pairs(QBCore.Shared.StarterItems) do
        if v.item == 'id_card' then
            local metadata = {
                type = string.format('%s %s', Player.PlayerData.charinfo.firstname, Player.PlayerData.charinfo.lastname),
                description = string.format('CID: %s  \nBirth date: %s  \nSex: %s  \nNationality: %s',
                Player.PlayerData.citizenid, Player.PlayerData.charinfo.birthdate, Player.PlayerData.charinfo.birthdate, Player.PlayerData.charinfo.nationality)
            }
            exports.ox_inventory:AddItem(source, v.item, v.amount, metadata)
        elseif v.item == 'driver_license' then
            local metadata = {
                type = 'Class C Driver License',
                description = string.format('First name: %s  \nLast name: %s  \nBirth date: %s',
                Player.PlayerData.charinfo.firstname, Player.PlayerData.charinfo.lastname, Player.PlayerData.charinfo.birthdate)
            }
            exports.ox_inventory:AddItem(source, v.item, v.amount, metadata)
        else
            exports.ox_inventory:AddItem(source, v.item, v.amount)
        end
    end
end

lib.addCommand('logout', {
    help = 'Logs you out of your current character',
    restricted = 'qbcore.admin',
}, function(source)
    QBCore.Player.Logout(source)
    TriggerClientEvent('qb-multicharacter:client:chooseChar', source)
end)

lib.addCommand('deletechar', {
    help = 'Delete a players character',
    restricted = 'qbcore.admin',
    params = {
        { name = 'id', help = 'Player ID', type = 'number' },
    }
}, function(source, args)
    QBCore.Player.ForceDeleteCharacter(args.id)
    TriggerClientEvent("QBCore:Notify", source, Lang:t("notifications.deleted_other_char", {citizenid = tostring(args.id)}))
end)

AddEventHandler('QBCore:Server:PlayerLoaded', function(Player)
    Wait(1000) -- 1 second should be enough to do the preloading in other resources
    hasDonePreloading[Player.PlayerData.source] = true
end)

AddEventHandler('QBCore:Server:OnPlayerUnload', function(src)
    hasDonePreloading[src] = false
end)

RegisterNetEvent('qb-multicharacter:server:loadUserData', function(cData)
    local src = source
    if QBCore.Player.Login(src, cData.citizenid) then
        repeat
            Wait(0)
        until hasDonePreloading[src]
        print('^2[qb-core]^7 '..GetPlayerName(src)..' (Citizen ID: '..cData.citizenid..') has succesfully loaded!')
        TriggerClientEvent('apartments:client:setupSpawnUI', src, cData)
        TriggerEvent("qb-log:server:CreateLog", "joinleave", "Loaded", "green", "**".. GetPlayerName(src) .. "** ("..(QBCore.Functions.GetIdentifier(src, 'discord') or 'undefined') .." |  ||"  ..(QBCore.Functions.GetIdentifier(src, 'ip') or 'undefined') ..  "|| | " ..(QBCore.Functions.GetIdentifier(src, 'license') or 'undefined') .." | " ..cData.citizenid.." | "..src..") loaded..")
        SetPlayerRoutingBucket(src, 0)
    end
end)

RegisterNetEvent('qb-multicharacter:server:createCharacter', function(data)
    local src = source
    local newData = {}
    newData.charinfo = data
    if QBCore.Player.Login(src, false, newData) then
        repeat
            Wait(0)
        until hasDonePreloading[src]
        GiveStarterItems(src)
        if not Config.HasSpawn then
            SetPlayerRoutingBucket(src, 0)
            lib.callback.await('qb-multicharacter:callback:defaultSpawn', src)
            print('^2[qb-core]^7 '..GetPlayerName(src)..' has succesfully loaded!')
            if Config.HasClothing then
                TriggerClientEvent('qb-clothes:client:CreateFirstCharacter', src)
            end
        else
            if Config.StartingApartment then
                print('^2[qb-core]^7 '..GetPlayerName(src)..' has succesfully loaded!')
                TriggerClientEvent('apartments:client:setupSpawnUI', src, newData)
            else
                print('^2[qb-core]^7 '..GetPlayerName(src)..' has succesfully loaded!')
                TriggerClientEvent("qb-multicharacter:client:closeNUIdefault", src)
            end
        end
    end
end)

RegisterNetEvent('qb-multicharacter:server:deleteCharacter', function(citizenid)
    TriggerClientEvent('QBCore:Notify', source, Lang:t("notifications.char_deleted"), "success")
    QBCore.Player.DeleteCharacter(source, citizenid)
end)

lib.callback.register('qb-multicharacter:callback:GetNumberOfCharacters', function(source)
    local License = QBCore.Functions.GetIdentifier(source, 'license2')
    if Config.PlayersNumberOfCharacters[License] then
        return Config.PlayersNumberOfCharacters[License]
    else
        return Config.DefaultNumberOfCharacters
    end
end)

lib.callback.register('qb-multicharacter:callback:GetCurrentCharacters', function(source)
    local Characters = {}
    local Result = MySQL.query.await('SELECT * FROM players WHERE license = ? OR license = ?', {QBCore.Functions.GetIdentifier(source, 'license2'), QBCore.Functions.GetIdentifier(source, 'license')})
    for i = 1, #Result do
        Result[i].charinfo = json.decode(Result[i].charinfo)
        Result[i].money = json.decode(Result[i].money)
        Result[i].job = json.decode(Result[i].job)
        Characters[#Characters+1] = Result[i]
    end
    return Characters
end)

lib.callback.register('qb-multicharacter:callback:UpdatePreviewPed', function(source, CitizenID)
    local Ped = MySQL.single.await('SELECT * FROM playerskins WHERE citizenid = ?', {CitizenID})
    local PlayerData = MySQL.single.await('SELECT * FROM players WHERE citizenid = ?', {CitizenID})
    if not Ped or not PlayerData then return end
    Charinfo = json.decode(PlayerData.charinfo)
    return Ped.skin, Ped.model, Charinfo.gender
end)

AddEventHandler('playerJoining', function()
    SetPlayerRoutingBucket(source, source)
end)

AddEventHandler('onResourceStart', function(resourceName)
    if resourceName ~= GetCurrentResourceName() then return end
    Wait(100)
    for _, playerId in ipairs(GetPlayers()) do
        playerId = tonumber(playerId)
        if not playerId then return end
        SetPlayerRoutingBucket(tostring(playerId), playerId)
    end
end)
