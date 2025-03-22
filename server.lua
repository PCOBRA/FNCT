ESX = exports['es_extended']:getSharedObject()

-- Cập nhật database
MySQL.ready(function()
    MySQL.Sync.execute('CREATE TABLE IF NOT EXISTS vehicle_upgrades (plate VARCHAR(8) PRIMARY KEY, engine_level INT DEFAULT 0, brake_level INT DEFAULT 0, suspension_level INT DEFAULT 0, primary_color INT DEFAULT 0, secondary_color INT DEFAULT 0, plate_color INT DEFAULT 0, headlight_level INT DEFAULT 0, turbo INT DEFAULT 0, horn INT DEFAULT -1, pearlescent INT DEFAULT -1)', {})
end)

-- Lấy trạng thái xe
ESX.RegisterServerCallback('vehicle:getUpgradeStatus', function(source, cb, plate)
    local result = MySQL.Sync.fetchAll('SELECT * FROM vehicle_upgrades WHERE plate = @plate', { ['@plate'] = plate })
    if result[1] then
        cb(result[1])
    else
        cb({ engine_level = 0, brake_level = 0, suspension_level = 0, primary_color = 0, secondary_color = 0, plate_color = 0, headlight_level = 0, turbo = 0, horn = -1, pearlescent = -1 })
    end
end)

-- Nâng cấp phương tiện
RegisterServerEvent('vehicle:upgrade:server')
AddEventHandler('vehicle:upgrade:server', function(upgradeType, vehicleNetId)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.job.name ~= 'doxe' then TriggerClientEvent('ox_lib:notify', source, { title = 'Lỗi', description = 'Chỉ thợ máy (doxe) mới có thể sử dụng!', type = 'error' }) return end
    if exports.ox_inventory:RemoveItem(source, upgradeType .. '_upgrade', 1) then TriggerClientEvent('vehicle:upgrade:apply', source, upgradeType, vehicleNetId)
    else TriggerClientEvent('ox_lib:notify', source, { title = 'Lỗi', description = 'Bạn không có bộ nâng cấp ' .. upgradeType .. '!', type = 'error' }) end
end)

RegisterServerEvent('vehicle:upgrade:updateStatus')
AddEventHandler('vehicle:upgrade:updateStatus', function(plate, upgradeType, level)
    MySQL.Sync.execute('INSERT INTO vehicle_upgrades (plate, ' .. upgradeType .. '_level) VALUES (@plate, @level) ON DUPLICATE KEY UPDATE ' .. upgradeType .. '_level = @level', {
        ['@plate'] = plate,
        ['@level'] = level
    })
end)

-- Đổi màu xe
RegisterServerEvent('vehicle:paint:server')
AddEventHandler('vehicle:paint:server', function(vehicleNetId)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.job.name ~= 'doxe' then TriggerClientEvent('ox_lib:notify', source, { title = 'Lỗi', description = 'Chỉ thợ máy (doxe) mới có thể sử dụng!', type = 'error' }) return end
    if exports.ox_inventory:RemoveItem(source, 'paint_kit', 1) then TriggerClientEvent('vehicle:paint:apply', source, vehicleNetId)
    else TriggerClientEvent('ox_lib:notify', source, { title = 'Lỗi', description = 'Bạn không có bộ sơn xe!', type = 'error' }) end
end)

RegisterServerEvent('vehicle:paint:updateStatus')
AddEventHandler('vehicle:paint:updateStatus', function(plate, primaryColor, secondaryColor)
    MySQL.Sync.execute('INSERT INTO vehicle_upgrades (plate, primary_color, secondary_color) VALUES (@plate, @primary, @secondary) ON DUPLICATE KEY UPDATE primary_color = @primary, secondary_color = @secondary', {
        ['@plate'] = plate,
        ['@primary'] = primaryColor,
        ['@secondary'] = secondaryColor
    })
end)

-- Đổi màu biển số xe
RegisterServerEvent('vehicle:plate:server')
AddEventHandler('vehicle:plate:server', function(vehicleNetId)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.job.name ~= 'doxe' then TriggerClientEvent('ox_lib:notify', source, { title = 'Lỗi', description = 'Chỉ thợ máy (doxe) mới có thể sử dụng!', type = 'error' }) return end
    if exports.ox_inventory:RemoveItem(source, 'plate_paint', 1) then TriggerClientEvent('vehicle:plate:apply', source, vehicleNetId)
    else TriggerClientEvent('ox_lib:notify', source, { title = 'Lỗi', description = 'Bạn không có sơn biển số!', type = 'error' }) end
end)

RegisterServerEvent('vehicle:plate:updateStatus')
AddEventHandler('vehicle:plate:updateStatus', function(plate, plateColor)
    MySQL.Sync.execute('INSERT INTO vehicle_upgrades (plate, plate_color) VALUES (@plate, @color) ON DUPLICATE KEY UPDATE plate_color = @color', {
        ['@plate'] = plate,
        ['@color'] = plateColor
    })
end)

-- Nâng cấp đèn pha
RegisterServerEvent('vehicle:headlight:server')
AddEventHandler('vehicle:headlight:server', function(vehicleNetId)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.job.name ~= 'doxe' then TriggerClientEvent('ox_lib:notify', source, { title = 'Lỗi', description = 'Chỉ thợ máy (doxe) mới có thể sử dụng!', type = 'error' }) return end
    if exports.ox_inventory:RemoveItem(source, 'headlight_upgrade', 1) then TriggerClientEvent('vehicle:headlight:apply', source, vehicleNetId)
    else TriggerClientEvent('ox_lib:notify', source, { title = 'Lỗi', description = 'Bạn không có bộ nâng cấp đèn pha!', type = 'error' }) end
end)

RegisterServerEvent('vehicle:headlight:updateStatus')
AddEventHandler('vehicle:headlight:updateStatus', function(plate, headlightLevel)
    MySQL.Sync.execute('INSERT INTO vehicle_upgrades (plate, headlight_level) VALUES (@plate, @level) ON DUPLICATE KEY UPDATE headlight_level = @level', {
        ['@plate'] = plate,
        ['@level'] = headlightLevel
    })
end)

-- Lắp turbo
RegisterServerEvent('vehicle:turbo:server')
AddEventHandler('vehicle:turbo:server', function(vehicleNetId)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.job.name ~= 'doxe' then TriggerClientEvent('ox_lib:notify', source, { title = 'Lỗi', description = 'Chỉ thợ máy (doxe) mới có thể sử dụng!', type = 'error' }) return end
    if exports.ox_inventory:RemoveItem(source, 'turbo_kit', 1) then TriggerClientEvent('vehicle:turbo:apply', source, vehicleNetId)
    else TriggerClientEvent('ox_lib:notify', source, { title = 'Lỗi', description = 'Bạn không có bộ turbo!', type = 'error' }) end
end)

RegisterServerEvent('vehicle:turbo:updateStatus')
AddEventHandler('vehicle:turbo:updateStatus', function(plate, turboStatus)
    MySQL.Sync.execute('INSERT INTO vehicle_upgrades (plate, turbo) VALUES (@plate, @turbo) ON DUPLICATE KEY UPDATE turbo = @turbo', {
        ['@plate'] = plate,
        ['@turbo'] = turboStatus
    })
end)

-- Reset nâng cấp
RegisterServerEvent('vehicle:reset:server')
AddEventHandler('vehicle:reset:server', function(resetType, vehicleNetId)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local itemName = resetType == 'turbo' and 'turbo_remover' or (resetType .. '_reset')
    if xPlayer.job.name ~= 'doxe' then TriggerClientEvent('ox_lib:notify', source, { title = 'Lỗi', description = 'Chỉ thợ máy (doxe) mới có thể sử dụng!', type = 'error' }) return end
    if exports.ox_inventory:RemoveItem(source, itemName, 1) then TriggerClientEvent('vehicle:reset:apply', source, resetType, vehicleNetId)
    else TriggerClientEvent('ox_lib:notify', source, { title = 'Lỗi', description = 'Bạn không có ' .. itemName:gsub('_', ' ') .. '!', type = 'error' }) end
end)

-- Chọn còi xe
RegisterServerEvent('vehicle:horn:server')
AddEventHandler('vehicle:horn:server', function(vehicleNetId)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.job.name ~= 'doxe' then TriggerClientEvent('ox_lib:notify', source, { title = 'Lỗi', description = 'Chỉ thợ máy (doxe) mới có thể sử dụng!', type = 'error' }) return end
    if exports.ox_inventory:RemoveItem(source, 'horn_kit', 1) then TriggerClientEvent('vehicle:horn:apply', source, vehicleNetId)
    else TriggerClientEvent('ox_lib:notify', source, { title = 'Lỗi', description = 'Bạn không có bộ còi xe!', type = 'error' }) end
end)

RegisterServerEvent('vehicle:horn:updateStatus')
AddEventHandler('vehicle:horn:updateStatus', function(plate, hornType)
    MySQL.Sync.execute('INSERT INTO vehicle_upgrades (plate, horn) VALUES (@plate, @horn) ON DUPLICATE KEY UPDATE horn = @horn', {
        ['@plate'] = plate,
        ['@horn'] = hornType
    })
end)

-- Sơn ánh kim
RegisterServerEvent('vehicle:pearlescent:server')
AddEventHandler('vehicle:pearlescent:server', function(vehicleNetId)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.job.name ~= 'doxe' then TriggerClientEvent('ox_lib:notify', source, { title = 'Lỗi', description = 'Chỉ thợ máy (doxe) mới có thể sử dụng!', type = 'error' }) return end
    if exports.ox_inventory:RemoveItem(source, 'pearlescent_paint', 1) then TriggerClientEvent('vehicle:pearlescent:apply', source, vehicleNetId)
    else TriggerClientEvent('ox_lib:notify', source, { title = 'Lỗi', description = 'Bạn không có sơn ánh kim!', type = 'error' }) end
end)

RegisterServerEvent('vehicle:pearlescent:updateStatus')
AddEventHandler('vehicle:pearlescent:updateStatus', function(plate, pearlescentColor)
    MySQL.Sync.execute('INSERT INTO vehicle_upgrades (plate, pearlescent) VALUES (@plate, @pearlescent) ON DUPLICATE KEY UPDATE pearlescent = @pearlescent', {
        ['@plate'] = plate,
        ['@pearlescent'] = pearlescentColor
    })
end)
