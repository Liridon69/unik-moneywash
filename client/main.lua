local QBCore = exports['qb-core']:GetCoreObject()
local PlayerData = {}
local washingmoney = false


Text3D = function(x, y, z, text)
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

CreateThread(function()
  RequestModel(`a_f_m_ktown_02`)
    while not HasModelLoaded(`a_f_m_ktown_02`) do
    Wait(1)
  end
    moneyboss = CreatePed(2, `a_f_m_ktown_02`, -442.64, 6197.76, 28.55, 279.94, false, false) -- change here the cords for the ped 
    SetPedFleeAttributes(moneyboss, 0, 0)
    SetPedDiesWhenInjured(moneyboss, false)
    TaskStartScenarioInPlace(moneyboss, "WORLD_HUMAN_STAND_IMPATIENT", 0, true)
    SetPedKeepTask(moneyboss, true)
    SetBlockingOfNonTemporaryEvents(moneyboss, true)
    SetEntityInvincible(moneyboss, true)
    FreezeEntityPosition(moneyboss, true)
end)

exports['qb-target']:AddTargetModel('a_f_m_ktown_02', {
        options = {
            { 
                type = "server",
                event = "unik-moneywash:server:checkmoney",
                icon = 'fas fa-dollar-sign',
                label = "Start Washing",
                id = washer,
                canInteract = function()
                        local c = false 
                        QBCore.Functions.TriggerCallback("laundry:isWashing", function(result)
                            c = result
                        end, washer)
                        Wait(200)
                            if not c then return true else return false end 
                        end
            }
        },
        distance = 3.0 
})


RegisterNetEvent('unik-moneywash:client:WashProggress')
AddEventHandler('unik-moneywash:client:WashProggress', function(source)
    QBCore.Functions.Progressbar("wash_money", "Washing Money...", math.random(15000,20000), false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
	animDict = "mp_common",
    anim = "givetake2_a",
    flags = 16,
	}, {}, {}, function() -- Done
    StopAnimTask(PlayerPedId(), "mp_common", "givetake2_a", 1.0)
    TriggerServerEvent("unik-moneywash:server:getmoney")
    end, function() -- Cancel
    StopAnimTask(PlayerPedId(), "mp_common", "givetake2_a", 1.0)
    QBCore.Functions.Notify("Canceled..", "error")
end)
end)
