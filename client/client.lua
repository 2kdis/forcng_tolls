---@type table<number, boolean>
local enteredZones = {}

CreateThread(function()
    ---@param zoneId number The unique identifier of the toll booth zone
    ---@param zone table The configuration data for the toll booth zone
    for zoneId, zone in pairs(Booths) do
        if zone.coords then
            ---@type table
            local point = lib.points.new(zone.coords, zone.distance)

            function point:onEnter()
                if IsPedInAnyVehicle(cache.ped, false) and not enteredZones[zoneId] then
                    enteredZones[zoneId] = true

                    -- Shoutout Playboy Carti For The Callback Name - I AM MUSIC!
                    ---@param wasCharged boolean Indicates whether the charge was successful
                    ---@param incomeSource string The source of the deducted money ("cash" or "bank")
                    lib.callback('forcng:ChargeDemHoesAFee!', false, function(wasCharged, incomeSource)
                        if wasCharged then
                            ---@type string
                            local sourceName = (incomeSource == "cash" and "pockets") or "bank"
                            lib.notify({
                                title = 'Toll Booth',
                                description = ('You were charged $%d from your %s.'):format(zone.fee, sourceName),
                                type = 'inform',
                                icon = "fa-solid fa-car",
                            })
                        end
                    end, zone.fee)
                end
            end

            function point:onExit()
                enteredZones[zoneId] = false
            end

            function point:nearby()
                if not IsPedInAnyVehicle(cache.ped, false) then
                    enteredZones[zoneId] = false
                end
            end
        end
    end
end)