
if Config.Framework == "esx" then
    ESX = exports['es_extended']:getSharedObject()

    AddEventHandler('onServerResourceStart', function(resourceName)
        if resourceName ~= GetCurrentResourceName() then return end
        local stashID = Config.Recikler.stashId
        local label = "Recycler"

        exports.ox_inventory:RegisterStash(stashID, label, 100, 1000000, false)
    end)

    ESX.RegisterServerCallback('earth:provItemeRecikler', function(source, cb)
        local src = source
        local stashId = Config.Recikler.stashId
        local itemDefs = Config.Recikler.items
        local playerPed = GetPlayerPed(src)
        local playerCoords = GetEntityCoords(playerPed)

        local coords = vector3(Config.Recikler.coords.x, Config.Recikler.coords.y, Config.Recikler.coords.z)
        local dist = #(vector3(playerCoords.x, playerCoords.y, playerCoords.z) - coords)

        if dist > 5.0 then
            DropPlayer(src, "Kurcina")
            return
        end

        local stash = exports.ox_inventory:GetInventory(stashId)
        if not stash or not stash.items then
            cb(false)
            return
        end

        for _, item in pairs(stash.items) do
            if itemDefs[item.name] then
                cb(true)
                return
            end
        end

        cb(false)
    end)


    RegisterNetEvent('earth:reciklerstart', function()
        local src = source
        local xPlayer = ESX.GetPlayerFromId(src)
        local stashId = Config.Recikler.stashId
        local itemDefs = Config.Recikler.items
        local playerPed = GetPlayerPed(src)
        local playerCoords = GetEntityCoords(playerPed)

        local coords = vector3(Config.Recikler.coords.x, Config.Recikler.coords.y, Config.Recikler.coords.z)
        local dist = #(vector3(playerCoords.x, playerCoords.y, playerCoords.z) - coords)

        if dist > 5.0 then
            DropPlayer(src, "Kurcina")
            return
        end

        local stash = exports.ox_inventory:GetInventory(stashId)
        if not stash or not stash.items then 
            xPlayer.showNotification("No items available for recycling")
            return 
        end

        local toRemove = {}
        local toAdd = {}
        local hasValidItem = false

        for _, item in pairs(stash.items) do
            local recipe = itemDefs[item.name]
            if recipe then
                hasValidItem = true
                table.insert(toRemove, { name = item.name, count = item.count })

                for _, reward in ipairs(recipe.gives) do
                    table.insert(toAdd, {
                        name = reward.item,
                        count = reward.amount * item.count
                    })
                end
            end
        end

        if not hasValidItem then
            xPlayer.showNotification("This item cannot be recycled or the recycler is empty!")
            return
        end

        for _, i in ipairs(toRemove) do
            exports.ox_inventory:RemoveItem(stashId, i.name, i.count)
        end

        for _, i in ipairs(toAdd) do
            exports.ox_inventory:AddItem(stashId, i.name, i.count)
        end
    end)
elseif Config.Framework == "qbcore" then
    local QBCore = exports['qb-core']:GetCoreObject()

    AddEventHandler('onServerResourceStart', function(resourceName)
        if resourceName ~= GetCurrentResourceName() then return end

        local stashID = Config.Recikler.stashId
        local label = "Recycler"

        exports.ox_inventory:RegisterStash(stashID, label, 100, 1000000, false)
    end)

    QBCore.Functions.CreateCallback('earth:provItemeRecikler', function(source, cb)
        local stashId = Config.Recikler.stashId
        local itemDefs = Config.Recikler.items

        local playerPed = GetPlayerPed(source)
        local playerCoords = GetEntityCoords(playerPed)
        local coords = vector3(Config.Recikler.coords.x, Config.Recikler.coords.y, Config.Recikler.coords.z)

        if #(playerCoords - coords) > 5.0 then
            DropPlayer(source, "Kurcina")
            return
        end

        local stash = exports.ox_inventory:GetInventory(stashId)
        if not stash or not stash.items then
            cb(false)
            return
        end

        for _, item in pairs(stash.items) do
            if itemDefs[item.name] then
                cb(true)
                return
            end
        end

        cb(false)
    end)

    RegisterNetEvent('earth:reciklerstart', function()
        local src = source
        local stashId = Config.Recikler.stashId
        local itemDefs = Config.Recikler.items

        local playerPed = GetPlayerPed(src)
        local playerCoords = GetEntityCoords(playerPed)
        local coords = vector3(Config.Recikler.coords.x, Config.Recikler.coords.y, Config.Recikler.coords.z)

        if #(playerCoords - coords) > 5.0 then
            DropPlayer(src, "Kurcina")
            return
        end

        local stash = exports.ox_inventory:GetInventory(stashId)
        if not stash or not stash.items then 
            TriggerClientEvent('QBCore:Notify', src, "No items available for recycling", "error")
            return 
        end

        local toRemove = {}
        local toAdd = {}
        local hasValidItem = false

        for _, item in pairs(stash.items) do
            local recipe = itemDefs[item.name]
            if recipe then
                hasValidItem = true
                table.insert(toRemove, { name = item.name, count = item.count })

                for _, reward in ipairs(recipe.gives) do
                    table.insert(toAdd, {
                        name = reward.item,
                        count = reward.amount * item.count
                    })
                end
            end
        end

        if not hasValidItem then
            TriggerClientEvent('QBCore:Notify', src, "This item cannot be recycled or the recycler is empty!", "error")
            return
        end

        for _, i in ipairs(toRemove) do
            exports.ox_inventory:RemoveItem(stashId, i.name, i.count)
        end

        for _, i in ipairs(toAdd) do
            exports.ox_inventory:AddItem(stashId, i.name, i.count)
        end

        TriggerClientEvent('QBCore:Notify', src, "Material processing completed", "success")
    end)

end