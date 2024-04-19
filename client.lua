local NPC = {}

local function createPeds()
    if pedSpawned then return end

    for k, v in pairs(Config.Peds) do
        local current = type(v["ped"]) == "number" and v["ped"] or GetHashKey(v["ped"])

        RequestModel(current)
        while not HasModelLoaded(current) do
            Wait(0)
        end

        NPC[k] = CreatePed(0, current, v["coords"].x, v["coords"].y, v["coords"].z-1, v["coords"].w, false, false)
        TaskStartScenarioInPlace(NPC[k], v["scenario"], 0, true)
        FreezeEntityPosition(NPC[k], true)
        SetEntityInvincible(NPC[k], true)
        SetBlockingOfNonTemporaryEvents(NPC[k], true)
    end

    pedSpawned = true
end

local function deletePeds()
    if not pedSpawned then return end

    for _, v in pairs(NPC) do
        DeletePed(v)
    end
    pedSpawned = false
end

AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end

    createPeds()
end)

AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end

    deletePeds()
end)