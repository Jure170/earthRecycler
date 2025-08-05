if Config.Framework == "esx" then
    ESX = exports['es_extended']:getSharedObject()

    local processing = false
    local reciklerEntity = nil
    local reciklerBlip = nil
    local recikletabela = {}

    AddEventHandler("onResourceStop", function(res)
        if res ~= GetCurrentResourceName() then return end
        for i = 1, #recikletabela do
            DeleteObject(recikletabela[i])
        end
    end)

    CreateThread(function()
        if Config.Recikler.blip.enabled then
            recilkerBlip = AddBlipForCoord(Config.Recikler.coords)
            SetBlipSprite(recilkerBlip, Config.Recikler.blip.sprite)
            SetBlipDisplay(recilkerBlip, 4)
            SetBlipScale(recilkerBlip, Config.Recikler.blip.scale)
            SetBlipColour(recilkerBlip, Config.Recikler.blip.color)
            SetBlipAsShortRange(recilkerBlip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(Config.Recikler.blip.label)
            EndTextCommandSetBlipName(recilkerBlip)
        end

        if DoesEntityExist(recilkerEntity) then return end
        local modelHash = GetHashKey(Config.Recikler.model)
        RequestModel(modelHash)
        while not HasModelLoaded(modelHash) do Wait(0) end

        reciklerEntity = CreateObject(modelHash, Config.Recikler.coords.x, Config.Recikler.coords.y, Config.Recikler.coords.z -1, false, false, true)
        SetEntityHeading(recilkerEntity, 13.3)
        PlaceObjectOnGroundProperly(recilkerEntity)
        table.insert(recikletabela, reciklerEntity)
        exports.qtarget:AddBoxZone("recikler_zone", vector3(Config.Recikler.coords.x, Config.Recikler.coords.y, Config.Recikler.coords.z -1), 1.4, 1.4, {
            name = "recikler_zone",
            heading = Config.Recikler.heading,
            debugPoly = false,
            minZ = Config.Recikler.coords.z -2,
            maxZ = Config.Recikler.coords.z +1
        }, {
            options = {
                {
                    label = "Open the recycler",
                    icon = "fa-solid fa-box",
                    canInteract = function()
                        return not processing and IsPedOnFoot(PlayerPedId())
                    end,
                    action = function()
                        exports.ox_inventory:openInventory('stash', { id = Config.Recikler.stashId })
                    end
                },
                {
                    label = "Start recycling",
                    icon = "fa-solid fa-recycle",
                    canInteract = function()
                        return not processing and IsPedOnFoot(PlayerPedId())
                    end,
                    action = function()
                        ESX.TriggerServerCallback('earth:provItemeRecikler', function(hasItems)
                            if not hasItems then
                                ESX.ShowNotification("This item cannot be recycled or the recycler is empty!")
                                return
                            end

                            processing = true
                            TriggerServerEvent('earth:reciklerstart')
                            CreateThread(function()
                                Wait(6000)
                                processing = false
                                ESX.ShowNotification("Material processing completed")
                            end)
                        end)
                    end
                }

            },
            distance = 2.0
        })
    end)
elseif Config.Framework == "qbcore" then
    print("tu sam")
    local QBCore = exports['qb-core']:GetCoreObject()

    local processing = false
    local reciklerEntity = nil
    local reciklerBlip = nil
    local recikletabela = {}

    AddEventHandler("onResourceStop", function(res)
        if res ~= GetCurrentResourceName() then return end
        for i = 1, #recikletabela do
            DeleteObject(recikletabela[i])
        end
    end)

    CreateThread(function()
        if Config.Recikler.blip.enabled then
            reciklerBlip = AddBlipForCoord(Config.Recikler.coords)
            SetBlipSprite(reciklerBlip, Config.Recikler.blip.sprite)
            SetBlipDisplay(reciklerBlip, 4)
            SetBlipScale(reciklerBlip, Config.Recikler.blip.scale)
            SetBlipColour(reciklerBlip, Config.Recikler.blip.color)
            SetBlipAsShortRange(reciklerBlip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(Config.Recikler.blip.label)
            EndTextCommandSetBlipName(reciklerBlip)
        end

        if DoesEntityExist(reciklerEntity) then return end
        local modelHash = GetHashKey(Config.Recikler.model)
        RequestModel(modelHash)
        while not HasModelLoaded(modelHash) do Wait(0) end

        reciklerEntity = CreateObject(modelHash, Config.Recikler.coords.x, Config.Recikler.coords.y, Config.Recikler.coords.z - 1, false, false, true)
        SetEntityHeading(reciklerEntity, Config.Recikler.heading or 13.3)
        PlaceObjectOnGroundProperly(reciklerEntity)
        table.insert(recikletabela, reciklerEntity)

        exports.qtarget:AddBoxZone("recikler_zone", vector3(Config.Recikler.coords.x, Config.Recikler.coords.y, Config.Recikler.coords.z - 1), 1.4, 1.4, {
            name = "recikler_zone",
            heading = Config.Recikler.heading,
            debugPoly = false,
            minZ = Config.Recikler.coords.z - 2,
            maxZ = Config.Recikler.coords.z + 1
        }, {
            options = {
                {
                    label = "Open the recycler",
                    icon = "fa-solid fa-box",
                    canInteract = function()
                        return not processing and IsPedOnFoot(PlayerPedId())
                    end,
                    action = function()
                        exports.ox_inventory:openInventory('stash', { id = Config.Recikler.stashId })
                    end
                },
                {
                    label = "Start recycling",
                    icon = "fa-solid fa-recycle",
                    canInteract = function()
                        return not processing and IsPedOnFoot(PlayerPedId())
                    end,
                    action = function()
                        QBCore.Functions.TriggerCallback('earth:provItemeRecikler', function(hasItems)
                            if not hasItems then
                                QBCore.Functions.Notify("This item cannot be recycled or the recycler is empty!", "error")
                                return
                            end

                            processing = true
                            TriggerServerEvent('earth:reciklerstart')
                            CreateThread(function()
                                Wait(6000)
                                processing = false
                                QBCore.Functions.Notify("Material processing completed", "success")
                            end)
                        end)
                    end
                }

            },
            distance = 2.0
        })
    end)
end