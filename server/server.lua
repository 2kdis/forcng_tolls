---@field [string] boolean Table of job names that get free toll access (key = job name)
---@param source number Player ID (source)
---@param price number The cost for using the toll booth
---@return boolean, string|nil Whether the toll charge was successful, and the payment source ("cash" or "bank")
lib.callback.register('forcng:ChargeDemHoesAFee!', function(source, price)
    local src = source

    if GetResourceState('qb-core') == "started" then
        local qbCore = exports['qb-core']:GetCoreObject()
        local _player = qbCore.Functions.GetPlayer(source)
        if not _player then return end

        if _player then
            ---@type string
            local job = _player.PlayerData.job.name

            if table.contains(Jobs, job) then
                lib.notify(source, {
                    title = 'Toll Booth',
                    description = 'Enjoy your free toll pass',
                    type = 'success',
                    icon = "fa-solid fa-car",
                })
                return false
            end

            ---@type number
            local cash = _player.Functions.GetMoney("cash")
            local bank = _player.Functions.GetMoney("bank")

            if cash >= price then
                _player.Functions.RemoveMoney("cash", price)
                return true, "cash"
            elseif bank >= price then
                _player.Functions.RemoveMoney("bank", price)
                return true, "bank"
            else
                lib.notify(source, {
                    title = 'Toll Booth',
                    description = 'You do not have enough funds to pay the toll',
                    type = 'error',
                })
                return false
            end
        end

    elseif GetResourceState('es_extended') == "started" then
        local ESX = exports["es_extended"]:getSharedObject()
        local _ply = ESX.GetPlayerFromId(src)
        if not _ply then return end

        if _ply then
            ---@type string
            local job = _ply.getJob().name

            if table.contains(Jobs, job) then
                lib.notify(source, {
                    title = 'Toll Booth',
                    description = 'Enjoy your free toll pass',
                    type = 'success',
                    icon = "fa-solid fa-car",
                })
                return false
            end

            ---@type number
            local cash = _ply.getMoney()
            local bank = _ply.getAccount('bank').money

            if cash >= price then
                _ply.removeMoney(price)
                return true, "cash"
            elseif bank >= price then
                _ply.removeAccountMoney('bank', price)
                return true, "bank"
            else
                lib.notify(source, {
                    title = 'Toll Booth',
                    description = 'You do not have enough funds to pay the toll',
                    type = 'error',
                })
                return false
            end
        end
    end

    return false
end)

---@param table The table to search through.
---@param value The value to search for in the table.
---@return boolean Returns true if the value is found, false otherwise.
function table.contains(table, value)
    for _, v in ipairs(table) do
        if v == value then
            return true
        end
    end
    return false
end