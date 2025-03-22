-- Nâng cấp phương tiện
RegisterNetEvent('vehicle:upgrade')
AddEventHandler('vehicle:upgrade', function(data)
    local playerPed = PlayerPedId()
    local vehicle = GetClosestVehicle(GetEntityCoords(playerPed), 5.0, 0, 70)
    if not DoesEntityExist(vehicle) then lib.notify({ title = 'Lỗi', description = 'Không có xe nào gần bạn!', type = 'error' }) return end
    TriggerServerEvent('vehicle:upgrade:server', data.type, VehToNet(vehicle))
end)

RegisterNetEvent('vehicle:upgrade:apply')
AddEventHandler('vehicle:upgrade:apply', function(upgradeType, vehicleNetId)
    local vehicle = NetToVeh(vehicleNetId)
    if DoesEntityExist(vehicle) then
        local playerPed = PlayerPedId()
        local plate = GetVehicleNumberPlateText(vehicle)
        SetVehicleModKit(vehicle, 0)
        local currentStatus = lib.callback.await('vehicle:getUpgradeStatus', false, plate)
        local currentLevel, maxLevel, modIndex, upgradeName
        if upgradeType == 'engine' then modIndex = 11 upgradeName = 'động cơ' currentLevel = currentStatus.engine_level maxLevel = GetNumVehicleMods(vehicle, modIndex) - 1
        elseif upgradeType == 'brakes' then modIndex = 12 upgradeName = 'phanh' currentLevel = currentStatus.brake_level maxLevel = GetNumVehicleMods(vehicle, modIndex) - 1
        elseif upgradeType == 'suspension' then modIndex = 15 upgradeName = 'giảm xóc' currentLevel = currentStatus.suspension_level maxLevel = GetNumVehicleMods(vehicle, modIndex) - 1 end
        SetVehicleMod(vehicle, modIndex, currentLevel - 1, false)
        lib.notify({ title = 'Thông báo', description = 'Trạng thái xe ' .. plate .. ': ' .. upgradeName .. ' cấp ' .. currentLevel, type = 'inform' })
        if currentLevel < maxLevel then
            RequestAnimDict('mini@repair') while not HasAnimDictLoaded('mini@repair') do Citizen.Wait(100) end
            TaskPlayAnim(playerPed, 'mini@repair', 'fixing_a_ped', 8.0, -8.0, 5000, 0, 0, false, false, false)
            PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
            Citizen.Wait(5000)
            SetVehicleMod(vehicle, modIndex, currentLevel, false)
            TriggerServerEvent('vehicle:upgrade:updateStatus', plate, upgradeType, currentLevel + 1)
            lib.notify({ title = 'Thành công', description = 'Xe ' .. plate .. ' đã nâng cấp ' .. upgradeName .. ' lên cấp ' .. (currentLevel + 1), type = 'success' })
        else
            lib.notify({ title = 'Lỗi', description = 'Phương tiện đã đạt cấp tối đa cho ' .. upgradeName .. '!', type = 'error' })
        end
    end
end)

-- Đổi màu xe
RegisterNetEvent('vehicle:paint')
AddEventHandler('vehicle:paint', function()
    local playerPed = PlayerPedId()
    local vehicle = GetClosestVehicle(GetEntityCoords(playerPed), 5.0, 0, 70)
    if not DoesEntityExist(vehicle) then lib.notify({ title = 'Lỗi', description = 'Không có xe nào gần bạn!', type = 'error' }) return end
    TriggerServerEvent('vehicle:paint:server', VehToNet(vehicle))
end)

RegisterNetEvent('vehicle:paint:apply')
AddEventHandler('vehicle:paint:apply', function(vehicleNetId)
    local vehicle = NetToVeh(vehicleNetId)
    if DoesEntityExist(vehicle) then
        local playerPed = PlayerPedId()
        local plate = GetVehicleNumberPlateText(vehicle)
        SetVehicleModKit(vehicle, 0)
        local colorOptions = {
            { label = 'Đen', args = 0 },
            { label = 'Đen ánh kim', args = 1 },
            { label = 'Đen mờ', args = 147 },
            { label = 'Trắng', args = 111 },
            { label = 'Trắng ánh kim', args = 112 },
            { label = 'Trắng mờ', args = 132 },
            { label = 'Đỏ', args = 27 },
            { label = 'Đỏ ánh kim', args = 28 },
            { label = 'Đỏ mờ', args = 150 },
            { label = 'Xanh dương', args = 64 },
            { label = 'Xanh dương ánh kim', args = 65 },
            { label = 'Xanh dương mờ', args = 148 },
            { label = 'Xanh lá', args = 50 },
            { label = 'Xanh lá ánh kim', args = 51 },
            { label = 'Xanh lá mờ', args = 151 },
            { label = 'Vàng', args = 89 },
            { label = 'Vàng ánh kim', args = 88 },
            { label = 'Vàng mờ', args = 158 },
            { label = 'Cam', args = 36 },
            { label = 'Cam ánh kim', args = 38 },
            { label = 'Cam mờ', args = 153 },
            { label = 'Tím', args = 142 },
            { label = 'Tím ánh kim', args = 145 },
            { label = 'Tím mờ', args = 149 },
            { label = 'Hồng', args = 137 },
            { label = 'Hồng ánh kim', args = 135 },
            { label = 'Nâu', args = 102 },
            { label = 'Nâu ánh kim', args = 103 },
            { label = 'Nâu mờ', args = 152 },
            { label = 'Xám', args = 4 },
            { label = 'Xám ánh kim', args = 5 },
            { label = 'Xám mờ', args = 156 },
            { label = 'Bạc', args = 3 },
            { label = 'Bạc ánh kim', args = 2 },
            { label = 'Xanh ngọc', args = 83 },
            { label = 'Xanh ngọc ánh kim', args = 84 },
            { label = 'Đồng', args = 94 },
            { label = 'Đồng ánh kim', args = 95 },
            { label = 'Xanh nước biển', args = 70 },
            { label = 'Xanh nước biển ánh kim', args = 71 },
            { label = 'Xanh oliu', args = 53 },
            { label = 'Xanh oliu mờ', args = 154 },
            { label = 'Vàng chanh', args = 91 },
            { label = 'Vàng chanh ánh kim', args = 92 },
            { label = 'Xanh nhạt', args = 74 },
            { label = 'Xanh nhạt ánh kim', args = 75 },
            { label = 'Hồng phấn', args = 136 },
            { label = 'Beige', args = 107 },
            { label = 'Beige ánh kim', args = 108 },
        }
        local currentStatus = lib.callback.await('vehicle:getUpgradeStatus', false, plate)
        local originalPrimary = currentStatus.primary_color
        local originalSecondary = currentStatus.secondary_color
        local originalHeading = GetEntityHeading(vehicle)
        
        local itemsPerPage = 10
        local totalPages = math.ceil(#colorOptions / itemsPerPage)

        -- Hàm hiển thị menu phân trang cho màu chính
        local function showPrimaryPaintMenu(page)
            local startIndex = (page - 1) * itemsPerPage + 1
            local endIndex = math.min(startIndex + itemsPerPage - 1, #colorOptions)
            local pageOptions = {}
            for i = startIndex, endIndex do table.insert(pageOptions, colorOptions[i]) end
            if page > 1 then table.insert(pageOptions, { label = 'Trang trước', args = 'prev' }) end
            if page < totalPages then table.insert(pageOptions, { label = 'Trang sau', args = 'next' }) end
            
            lib.registerContext({
                id = 'primary_paint_menu_page_' .. page,
                title = 'Chọn màu chính (Trang ' .. page .. '/' .. totalPages .. ')',
                options = pageOptions,
                onSelect = function(selectedPrimary)
                    if selectedPrimary.args == 'prev' then showPrimaryPaintMenu(page - 1)
                    elseif selectedPrimary.args == 'next' then showPrimaryPaintMenu(page + 1)
                    else
                        local primaryColor = selectedPrimary.args
                        local primaryName = selectedPrimary.label
                        SetVehicleColours(vehicle, primaryColor, originalSecondary)
                        SetVehicleLights(vehicle, 2) -- Bật đèn pha
                        SetEntityHeading(vehicle, originalHeading + 45.0) -- Xoay xe 45 độ để xem màu rõ hơn

                        -- Menu màu phụ với phân trang
                        local function showSecondaryPaintMenu(pageSec)
                            local startIndexSec = (pageSec - 1) * itemsPerPage + 1
                            local endIndexSec = math.min(startIndexSec + itemsPerPage - 1, #colorOptions)
                            local pageOptionsSec = {}
                            for i = startIndexSec, endIndexSec do table.insert(pageOptionsSec, colorOptions[i]) end
                            if pageSec > 1 then table.insert(pageOptionsSec, { label = 'Trang trước', args = 'prev' }) end
                            if pageSec < totalPages then table.insert(pageOptionsSec, { label = 'Trang sau', args = 'next' }) end

                            lib.registerContext({
                                id = 'secondary_paint_menu_page_' .. pageSec,
                                title = 'Chọn màu phụ (Trang ' .. pageSec .. '/' .. totalPages .. ')',
                                options = pageOptionsSec,
                                onSelect = function(selectedSecondary)
                                    if selectedSecondary.args == 'prev' then showSecondaryPaintMenu(pageSec - 1)
                                    elseif selectedSecondary.args == 'next' then showSecondaryPaintMenu(pageSec + 1)
                                    else
                                        local secondaryColor = selectedSecondary.args
                                        local secondaryName = selectedSecondary.label
                                        SetVehicleColours(vehicle, primaryColor, secondaryColor)
                                        SetVehicleLights(vehicle, 2) -- Bật đèn pha
                                        SetEntityHeading(vehicle, originalHeading + 90.0) -- Xoay thêm để xem màu phụ

                                        lib.registerContext({
                                            id = 'confirm_paint_menu',
                                            title = 'Xác nhận màu xe',
                                            options = {
                                                { label = 'Xác nhận', args = 'confirm' },
                                                { label = 'Hủy', args = 'cancel' },
                                            },
                                            onSelect = function(choice)
                                                if choice.args == 'confirm' then
                                                    RequestAnimDict('amb@world_human_maid_clean@') while not HasAnimDictLoaded('amb@world_human_maid_clean@') do Citizen.Wait(100) end
                                                    TaskPlayAnim(playerPed, 'amb@world_human_maid_clean@', 'base', 8.0, -8.0, 5000, 0, 0, false, false, false)
                                                    PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
                                                    Citizen.Wait(5000)
                                                    SetVehicleLights(vehicle, 0) -- Tắt đèn pha sau khi xác nhận
                                                    SetEntityHeading(vehicle, originalHeading) -- Trả xe về góc ban đầu
                                                    TriggerServerEvent('vehicle:paint:updateStatus', plate, primaryColor, secondaryColor)
                                                    lib.notify({ title = 'Thông báo', description = 'Xe ' .. plate .. ' đã được sơn màu chính ' .. primaryName .. ', màu phụ ' .. secondaryName, type = 'inform' })
                                                    lib.notify({ title = 'Thành công', description = 'Xe đã được sơn màu mới!', type = 'success' })
                                                else
                                                    SetVehicleColours(vehicle, originalPrimary, originalSecondary)
                                                    SetVehicleLights(vehicle, 0) -- Tắt đèn pha nếu hủy
                                                    SetEntityHeading(vehicle, originalHeading) -- Trả xe về góc ban đầu
                                                    lib.notify({ title = 'Đã hủy', description = 'Không thay đổi màu xe.', type = 'inform' })
                                                end
                                            end
                                        })
                                        lib.showContext('confirm_paint_menu')
                                    end
                                end
                            })
                            lib.showContext('secondary_paint_menu_page_' .. pageSec)
                        end
                        showSecondaryPaintMenu(1)
                    end
                end
            })
            lib.showContext('primary_paint_menu_page_' .. page)
        end
        showPrimaryPaintMenu(1)
    end
end)

-- Đổi màu biển số xe
RegisterNetEvent('vehicle:plate')
AddEventHandler('vehicle:plate', function()
    local playerPed = PlayerPedId()
    local vehicle = GetClosestVehicle(GetEntityCoords(playerPed), 5.0, 0, 70)
    if not DoesEntityExist(vehicle) then lib.notify({ title = 'Lỗi', description = 'Không có xe nào gần bạn!', type = 'error' }) return end
    TriggerServerEvent('vehicle:plate:server', VehToNet(vehicle))
end)

RegisterNetEvent('vehicle:plate:apply')
AddEventHandler('vehicle:plate:apply', function(vehicleNetId)
    local vehicle = NetToVeh(vehicleNetId)
    if DoesEntityExist(vehicle) then
        local playerPed = PlayerPedId()
        local plate = GetVehicleNumberPlateText(vehicle)
        SetVehicleModKit(vehicle, 0)
        local plateOptions = {
            { label = 'Trắng', args = 0 },
            { label = 'Đen', args = 1 },
            { label = 'Xanh dương', args = 2 },
            { label = 'Vàng', args = 3 },
        }
        local currentStatus = lib.callback.await('vehicle:getUpgradeStatus', false, plate)
        local originalPlateColor = currentStatus.plate_color
        lib.registerContext({
            id = 'plate_menu',
            title = 'Chọn màu biển số',
            options = plateOptions,
            onSelect = function(selected)
                local plateColor = selected.args
                local plateColorName = selected.label
                SetVehicleNumberPlateTextIndex(vehicle, plateColor)
                lib.registerContext({
                    id = 'confirm_plate_menu',
                    title = 'Xác nhận màu biển số',
                    options = {
                        { label = 'Xác nhận', args = 'confirm' },
                        { label = 'Hủy', args = 'cancel' },
                    },
                    onSelect = function(choice)
                        if choice.args == 'confirm' then
                            RequestAnimDict('mini@repair') while not HasAnimDictLoaded('mini@repair') do Citizen.Wait(100) end
                            TaskPlayAnim(playerPed, 'mini@repair', 'fixing_a_ped', 8.0, -8.0, 5000, 0, 0, false, false, false)
                            PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
                            Citizen.Wait(5000)
                            TriggerServerEvent('vehicle:plate:updateStatus', plate, plateColor)
                            lib.notify({ title = 'Thành công', description = 'Biển số xe ' .. plate .. ' đã được đổi thành màu ' .. plateColorName, type = 'success' })
                        else
                            SetVehicleNumberPlateTextIndex(vehicle, originalPlateColor)
                            lib.notify({ title = 'Đã hủy', description = 'Không thay đổi màu biển số.', type = 'inform' })
                        end
                    end
                })
                lib.showContext('confirm_plate_menu')
            end
        })
        lib.showContext('plate_menu')
    end
end)

-- Nâng cấp đèn pha
RegisterNetEvent('vehicle:headlight')
AddEventHandler('vehicle:headlight', function()
    local playerPed = PlayerPedId()
    local vehicle = GetClosestVehicle(GetEntityCoords(playerPed), 5.0, 0, 70)
    if not DoesEntityExist(vehicle) then lib.notify({ title = 'Lỗi', description = 'Không có xe nào gần bạn!', type = 'error' }) return end
    TriggerServerEvent('vehicle:headlight:server', VehToNet(vehicle))
end)

RegisterNetEvent('vehicle:headlight:apply')
AddEventHandler('vehicle:headlight:apply', function(vehicleNetId)
    local vehicle = NetToVeh(vehicleNetId)
    if DoesEntityExist(vehicle) then
        local playerPed = PlayerPedId()
        local plate = GetVehicleNumberPlateText(vehicle)
        SetVehicleModKit(vehicle, 0)
        local headlightOptions = {
            { label = 'Thường', args = 0 },
            { label = 'Trắng', args = 1 },
            { label = 'Xanh dương', args = 2 },
            { label = 'Đỏ', args = 3 },
            { label = 'Vàng', args = 4 },
            { label = 'Tím', args = 5 },
            { label = 'Hồng', args = 6 },
            { label = 'Cam', args = 7 },
            { label = 'Xanh lá', args = 8 },
            { label = 'Xanh nhạt', args = 9 },
            { label = 'Xanh ngọc', args = 10 },
            { label = 'Xanh nước biển', args = 11 },
            { label = 'Vàng nhạt', args = 12 },
        }
        local currentStatus = lib.callback.await('vehicle:getUpgradeStatus', false, plate)
        local originalHeadlight = currentStatus.headlight_level
        lib.registerContext({
            id = 'headlight_menu',
            title = 'Chọn màu đèn pha',
            options = headlightOptions,
            onSelect = function(selected)
                local headlightColor = selected.args
                local headlightName = selected.label
                if headlightColor == 0 then SetVehicleMod(vehicle, 22, -1, false)
                else SetVehicleMod(vehicle, 22, 0, false) SetVehicleHeadlightsColour(vehicle, headlightColor - 1) end
                lib.registerContext({
                    id = 'confirm_headlight_menu',
                    title = 'Xác nhận màu đèn pha',
                    options = {
                        { label = 'Xác nhận', args = 'confirm' },
                        { label = 'Hủy', args = 'cancel' },
                    },
                    onSelect = function(choice)
                        if choice.args == 'confirm' then
                            RequestAnimDict('mini@repair') while not HasAnimDictLoaded('mini@repair') do Citizen.Wait(100) end
                            TaskPlayAnim(playerPed, 'mini@repair', 'fixing_a_ped', 8.0, -8.0, 5000, 0, 0, false, false, false)
                            PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
                            Citizen.Wait(5000)
                            TriggerServerEvent('vehicle:headlight:updateStatus', plate, headlightColor)
                            lib.notify({ title = 'Thông báo', description = 'Đèn pha xe ' .. plate .. ' đã được đổi thành màu ' .. headlightName, type = 'inform' })
                            lib.notify({ title = 'Thành công', description = 'Đèn pha xe đã được nâng cấp!', type = 'success' })
                        else
                            if originalHeadlight == 0 then SetVehicleMod(vehicle, 22, -1, false)
                            else SetVehicleMod(vehicle, 22, 0, false) SetVehicleHeadlightsColour(vehicle, originalHeadlight - 1) end
                            lib.notify({ title = 'Đã hủy', description = 'Không thay đổi đèn pha.', type = 'inform' })
                        end
                    end
                })
                lib.showContext('confirm_headlight_menu')
            end
        })
        lib.showContext('headlight_menu')
    end
end)

-- Lắp turbo
RegisterNetEvent('vehicle:turbo')
AddEventHandler('vehicle:turbo', function()
    local playerPed = PlayerPedId()
    local vehicle = GetClosestVehicle(GetEntityCoords(playerPed), 5.0, 0, 70)
    if not DoesEntityExist(vehicle) then lib.notify({ title = 'Lỗi', description = 'Không có xe nào gần bạn!', type = 'error' }) return end
    TriggerServerEvent('vehicle:turbo:server', VehToNet(vehicle))
end)

RegisterNetEvent('vehicle:turbo:apply')
AddEventHandler('vehicle:turbo:apply', function(vehicleNetId)
    local vehicle = NetToVeh(vehicleNetId)
    if DoesEntityExist(vehicle) then
        local playerPed = PlayerPedId()
        local plate = GetVehicleNumberPlateText(vehicle)
        SetVehicleModKit(vehicle, 0)
        local currentStatus = lib.callback.await('vehicle:getUpgradeStatus', false, plate)
        if currentStatus.turbo == 1 then lib.notify({ title = 'Lỗi', description = 'Xe ' .. plate .. ' đã có turbo!', type = 'error' }) return end
        RequestAnimDict('mini@repair') while not HasAnimDictLoaded('mini@repair') do Citizen.Wait(100) end
        TaskPlayAnim(playerPed, 'mini@repair', 'fixing_a_ped', 8.0, -8.0, 5000, 0, 0, false, false, false)
        PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
        Citizen.Wait(5000)
        ToggleVehicleMod(vehicle, 18, true)
        TriggerServerEvent('vehicle:turbo:updateStatus', plate, 1)
        lib.notify({ title = 'Thành công', description = 'Xe ' .. plate .. ' đã được lắp turbo!', type = 'success' })
    end
end)

-- Reset nâng cấp
RegisterNetEvent('vehicle:reset')
AddEventHandler('vehicle:reset', function(data)
    local playerPed = PlayerPedId()
    local vehicle = GetClosestVehicle(GetEntityCoords(playerPed), 5.0, 0, 70)
    if not DoesEntityExist(vehicle) then lib.notify({ title = 'Lỗi', description = 'Không có xe nào gần bạn!', type = 'error' }) return end
    TriggerServerEvent('vehicle:reset:server', data.type, VehToNet(vehicle))
end)

RegisterNetEvent('vehicle:reset:apply')
AddEventHandler('vehicle:reset:apply', function(resetType, vehicleNetId)
    local vehicle = NetToVeh(vehicleNetId)
    if DoesEntityExist(vehicle) then
        local playerPed = PlayerPedId()
        local plate = GetVehicleNumberPlateText(vehicle)
        SetVehicleModKit(vehicle, 0)
        local currentStatus = lib.callback.await('vehicle:getUpgradeStatus', false, plate)
        local resetName, modIndex, currentLevel
        if resetType == 'engine' then modIndex = 11 resetName = 'động cơ' currentLevel = currentStatus.engine_level
        elseif resetType == 'brakes' then modIndex = 12 resetName = 'phanh' currentLevel = currentStatus.brake_level
        elseif resetType == 'suspension' then modIndex = 15 resetName = 'giảm xóc' currentLevel = currentStatus.suspension_level
        elseif resetType == 'headlights' then modIndex = 22 resetName = 'đèn pha' currentLevel = currentStatus.headlight_level
        elseif resetType == 'turbo' then resetName = 'turbo' currentLevel = currentStatus.turbo
        elseif resetType == 'horn' then modIndex = 14 resetName = 'còi' currentLevel = currentStatus.horn or -1
        elseif resetType == 'pearlescent' then resetName = 'sơn ánh kim' currentLevel = currentStatus.pearlescent or -1 end
        if currentLevel == 0 or (resetType == 'horn' and currentLevel == -1) or (resetType == 'pearlescent' and currentLevel == -1) then
            lib.notify({ title = 'Lỗi', description = resetName .. ' của xe ' .. plate .. ' đã ở trạng thái mặc định!', type = 'error' }) return
        end
        lib.registerContext({
            id = 'confirm_reset_menu',
            title = 'Xác nhận reset ' .. resetName,
            options = {
                { label = 'Xác nhận', args = 'confirm' },
                { label = 'Hủy', args = 'cancel' },
            },
            onSelect = function(choice)
                if choice.args == 'confirm' then
                    RequestAnimDict('mini@repair') while not HasAnimDictLoaded('mini@repair') do Citizen.Wait(100) end
                    TaskPlayAnim(playerPed, 'mini@repair', 'fixing_a_ped', 8.0, -8.0, 5000, 0, 0, false, false, false)
                    PlaySoundFrontend(-1, "CANCEL", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
                    Citizen.Wait(5000)
                    if resetType == 'headlights' then SetVehicleMod(vehicle, modIndex, -1, false) TriggerServerEvent('vehicle:headlight:updateStatus', plate, 0)
                    elseif resetType == 'turbo' then ToggleVehicleMod(vehicle, 18, false) TriggerServerEvent('vehicle:turbo:updateStatus', plate, 0)
                    elseif resetType == 'horn' then SetVehicleMod(vehicle, modIndex, -1, false) TriggerServerEvent('vehicle:horn:updateStatus', plate, -1)
                    elseif resetType == 'pearlescent' then SetVehicleExtraColours(vehicle, -1, 0) TriggerServerEvent('vehicle:pearlescent:updateStatus', plate, -1)
                    else SetVehicleMod(vehicle, modIndex, -1, false) TriggerServerEvent('vehicle:upgrade:updateStatus', plate, resetType, 0) end
                    lib.notify({ title = 'Thành công', description = resetName .. ' của xe ' .. plate .. ' đã được reset về mặc định!', type = 'success' })
                else
                    lib.notify({ title = 'Đã hủy', description = 'Không reset ' .. resetName .. '.', type = 'inform' })
                end
            end
        })
        lib.showContext('confirm_reset_menu')
    end
end)

-- Chọn còi xe (phân trang)
RegisterNetEvent('vehicle:horn')
AddEventHandler('vehicle:horn', function()
    local playerPed = PlayerPedId()
    local vehicle = GetClosestVehicle(GetEntityCoords(playerPed), 5.0, 0, 70)
    if not DoesEntityExist(vehicle) then lib.notify({ title = 'Lỗi', description = 'Không có xe nào gần bạn!', type = 'error' }) return end
    TriggerServerEvent('vehicle:horn:server', VehToNet(vehicle))
end)

RegisterNetEvent('vehicle:horn:apply')
AddEventHandler('vehicle:horn:apply', function(vehicleNetId)
    local vehicle = NetToVeh(vehicleNetId)
    if DoesEntityExist(vehicle) then
        local playerPed = PlayerPedId()
        local plate = GetVehicleNumberPlateText(vehicle)
        SetVehicleModKit(vehicle, 0)
        local hornOptions = {
            { label = 'Còi mặc định', args = -1 }, { label = 'Còi xe tải', args = 0 }, { label = 'Còi cảnh sát', args = 1 }, { label = 'Còi hề', args = 2 },
            { label = 'Còi nhạc 1', args = 3 }, { label = 'Còi nhạc 2', args = 4 }, { label = 'Còi nhạc 3', args = 5 }, { label = 'Còi nhạc 4', args = 6 },
            { label = 'Còi nhạc 5', args = 7 }, { label = 'Còi buồn 1', args = 8 }, { label = 'Còi buồn 2', args = 9 }, { label = 'Còi buồn 3', args = 10 },
            { label = 'Còi buồn 4', args = 11 }, { label = 'Còi buồn 5', args = 12 }, { label = 'Còi nhạc Jazz 1', args = 13 }, { label = 'Còi nhạc Jazz 2', args = 14 },
            { label = 'Còi nhạc Jazz 3', args = 15 }, { label = 'Còi nhạc cổ điển 1', args = 16 }, { label = 'Còi nhạc cổ điển 2', args = 17 }, { label = 'Còi nhạc cổ điển 3', args = 18 },
            { label = 'Còi nhạc cổ điển 4', args = 19 }, { label = 'Còi nhạc cổ điển 5', args = 20 }, { label = 'Còi nhạc cổ điển 6', args = 21 }, { label = 'Còi nhạc cổ điển 7', args = 22 },
            { label = 'Còi thang âm 1', args = 23 }, { label = 'Còi thang âm 2', args = 24 }, { label = 'Còi thang âm 3', args = 25 }, { label = 'Còi thang âm 4', args = 26 },
            { label = 'Còi thang âm 5', args = 27 }, { label = 'Còi thang âm 6', args = 28 }, { label = 'Còi thang âm 7', args = 29 }, { label = 'Còi thang âm 8', args = 30 },
            { label = 'Còi nhạc vui 1', args = 31 }, { label = 'Còi nhạc vui 2', args = 32 }, { label = 'Còi nhạc vui 3', args = 33 }, { label = 'Còi nhạc vui 4', args = 34 },
            { label = 'Còi nhạc vui 5', args = 35 }, { label = 'Còi nhạc vui 6', args = 36 }, { label = 'Còi nhạc vui 7', args = 37 }, { label = 'Còi nhạc vui 8', args = 38 },
            { label = 'Còi nhạc vui 9', args = 39 }, { label = 'Còi nhạc vui 10', args = 40 }, { label = 'Còi nhạc vui 11', args = 41 }, { label = 'Còi nhạc vui 12', args = 42 },
            { label = 'Còi nhạc vui 13', args = 43 }, { label = 'Còi nhạc vui 14', args = 44 }, { label = 'Còi nhạc vui 15', args = 45 }, { label = 'Còi nhạc vui 16', args = 46 },
            { label = 'Còi nhạc vui 17', args = 47 }, { label = 'Còi nhạc vui 18', args = 48 }, { label = 'Còi nhạc vui 19', args = 49 }, { label = 'Còi nhạc vui 20', args = 50 },
            { label = 'Còi nhạc vui 21', args = 51 },
        }
        local currentStatus = lib.callback.await('vehicle:getUpgradeStatus', false, plate)
        local originalHorn = currentStatus.horn or -1
        local itemsPerPage = 10
        local totalPages = math.ceil(#hornOptions / itemsPerPage)
        local function showHornMenu(page)
            local startIndex = (page - 1) * itemsPerPage + 1
            local endIndex = math.min(startIndex + itemsPerPage - 1, #hornOptions)
            local pageOptions = {}
            for i = startIndex, endIndex do table.insert(pageOptions, hornOptions[i]) end
            if page > 1 then table.insert(pageOptions, { label = 'Trang trước', args = 'prev' }) end
            if page < totalPages then table.insert(pageOptions, { label = 'Trang sau', args = 'next' }) end
            lib.registerContext({
                id = 'horn_menu_page_' .. page,
                title = 'Chọn loại còi xe (Trang ' .. page .. '/' .. totalPages .. ')',
                options = pageOptions,
                onSelect = function(selected)
                    if selected.args == 'prev' then showHornMenu(page - 1)
                    elseif selected.args == 'next' then showHornMenu(page + 1)
                    else
                        local hornType = selected.args
                        local hornName = selected.label
                        SetVehicleMod(vehicle, 14, hornType, false)
                        StartVehicleHorn(vehicle, 1000, "HELDDOWN", false)
                        lib.registerContext({
                            id = 'confirm_horn_menu',
                            title = 'Xác nhận còi xe',
                            options = {
                                { label = 'Xác nhận', args = 'confirm' },
                                { label = 'Hủy', args = 'cancel' },
                            },
                            onSelect = function(choice)
                                if choice.args == 'confirm' then
                                    RequestAnimDict('mini@repair') while not HasAnimDictLoaded('mini@repair') do Citizen.Wait(100) end
                                    TaskPlayAnim(playerPed, 'mini@repair', 'fixing_a_ped', 8.0, -8.0, 5000, 0, 0, false, false, false)
                                    PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
                                    Citizen.Wait(5000)
                                    TriggerServerEvent('vehicle:horn:updateStatus', plate, hornType)
                                    lib.notify({ title = 'Thông báo', description = 'Còi xe ' .. plate .. ' đã được đổi thành ' .. hornName, type = 'inform' })
                                    lib.notify({ title = 'Thành công', description = 'Còi xe đã được thay đổi!', type = 'success' })
                                else
                                    SetVehicleMod(vehicle, 14, originalHorn, false)
                                    lib.notify({ title = 'Đã hủy', description = 'Không thay đổi còi xe.', type = 'inform' })
                                end
                            end
                        })
                        lib.showContext('confirm_horn_menu')
                    end
                end
            })
            lib.showContext('horn_menu_page_' .. page)
        end
        showHornMenu(1)
    end
end)

-- Sơn ánh kim
RegisterNetEvent('vehicle:pearlescent')
AddEventHandler('vehicle:pearlescent', function()
    local playerPed = PlayerPedId()
    local vehicle = GetClosestVehicle(GetEntityCoords(playerPed), 5.0, 0, 70)
    if not DoesEntityExist(vehicle) then lib.notify({ title = 'Lỗi', description = 'Không có xe nào gần bạn!', type = 'error' }) return end
    TriggerServerEvent('vehicle:pearlescent:server', VehToNet(vehicle))
end)

RegisterNetEvent('vehicle:pearlescent:apply')
AddEventHandler('vehicle:pearlescent:apply', function(vehicleNetId)
    local vehicle = NetToVeh(vehicleNetId)
    if DoesEntityExist(vehicle) then
        local playerPed = PlayerPedId()
        local plate = GetVehicleNumberPlateText(vehicle)
        SetVehicleModKit(vehicle, 0)
        local pearlescentOptions = {
            { label = 'Không ánh kim', args = -1 },
            { label = 'Đỏ ánh kim', args = 3 },
            { label = 'Xanh dương ánh kim', args = 61 },
            { label = 'Xanh lá ánh kim', args = 49 },
            { label = 'Vàng ánh kim', args = 89 },
            { label = 'Tím ánh kim', args = 142 },
            { label = 'Hồng ánh kim', args = 137 },
            { label = 'Cam ánh kim', args = 36 },
            { label = 'Trắng ánh kim', args = 111 },
            { label = 'Đen ánh kim', args = 0 },
        }
        local currentStatus = lib.callback.await('vehicle:getUpgradeStatus', false, plate)
        local originalPearlescent = currentStatus.pearlescent or -1
        local originalPrimary, originalSecondary = GetVehicleColours(vehicle)
        lib.registerContext({
            id = 'pearlescent_menu',
            title = 'Chọn sơn ánh kim',
            options = pearlescentOptions,
            onSelect = function(selected)
                local pearlescentColor = selected.args
                local pearlescentName = selected.label
                if pearlescentColor == -1 then SetVehicleExtraColours(vehicle, 0, 0) else SetVehicleExtraColours(vehicle, pearlescentColor, 0) end
                lib.registerContext({
                    id = 'confirm_pearlescent_menu',
                    title = 'Xác nhận sơn ánh kim',
                    options = {
                        { label = 'Xác nhận', args = 'confirm' },
                        { label = 'Hủy', args = 'cancel' },
                    },
                    onSelect = function(choice)
                        if choice.args == 'confirm' then
                            RequestAnimDict('amb@world_human_maid_clean@') while not HasAnimDictLoaded('amb@world_human_maid_clean@') do Citizen.Wait(100) end
                            TaskPlayAnim(playerPed, 'amb@world_human_maid_clean@', 'base', 8.0, -8.0, 5000, 0, 0, false, false, false)
                            PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
                            Citizen.Wait(5000)
                            TriggerServerEvent('vehicle:pearlescent:updateStatus', plate, pearlescentColor)
                            lib.notify({ title = 'Thông báo', description = 'Xe ' .. plate .. ' đã được sơn ánh kim ' .. pearlescentName, type = 'inform' })
                            lib.notify({ title = 'Thành công', description = 'Xe đã được sơn ánh kim!', type = 'success' })
                        else
                            SetVehicleColours(vehicle, originalPrimary, originalSecondary)
                            SetVehicleExtraColours(vehicle, originalPearlescent, 0)
                            lib.notify({ title = 'Đã hủy', description = 'Không thay đổi sơn ánh kim.', type = 'inform' })
                        end
                    end
                })
                lib.showContext('confirm_pearlescent_menu')
            end
        })
        lib.showContext('pearlescent_menu')
    end
end)

-- Hàm chuyển đổi RGB thành mã màu GTA V
function GetVehicleColorIndex(r, g, b)
    if r == 255 and g == 0 and b == 0 then return 27 -- Đỏ
    elseif r == 0 and g == 0 and b == 255 then return 64 -- Xanh dương
    elseif r == 0 and g == 255 and b == 0 then return 50 -- Xanh lá
    elseif r == 255 and g == 255 and b == 255 then return 111 -- Trắng
    elseif r == 0 and g == 0 and b == 0 then return 0 -- Đen
    else return 0 end -- Mặc định đen nếu không khớp
end

-- Hàm lấy tên màu từ mã màu GTA V
function GetColorName(colorIndex)
    if colorIndex == 27 then return 'Đỏ'
    elseif colorIndex == 64 then return 'Xanh dương'
    elseif colorIndex == 50 then return 'Xanh lá'
    elseif colorIndex == 111 then return 'Trắng'
    elseif colorIndex == 0 then return 'Đen'
    else return 'Không xác định' end
end

-- Kiểm tra trạng thái xe bằng phím E
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local playerPed = PlayerPedId()
        if IsControlJustPressed(0, 38) then -- Phím E (mã 38)
            if not IsPedInAnyVehicle(playerPed, false) then
                local vehicle = GetClosestVehicle(GetEntityCoords(playerPed), 5.0, 0, 70)
                if DoesEntityExist(vehicle) then
                    local plate = GetVehicleNumberPlateText(vehicle)
                    local model = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
                    local status = lib.callback.await('vehicle:getUpgradeStatus', false, plate)
                    local plateColorName = status.plate_color == 0 and 'Trắng' or status.plate_color == 1 and 'Đen' or status.plate_color == 2 and 'Xanh dương' or status.plate_color == 3 and 'Vàng' or 'Không xác định'
                    local headlightName = status.headlight_level == 0 and 'Thường' or status.headlight_level == 1 and 'Trắng' or status.headlight_level == 2 and 'Xanh dương' or status.headlight_level == 3 and 'Đỏ' or status.headlight_level == 4 and 'Vàng' or status.headlight_level == 5 and 'Tím' or status.headlight_level == 6 and 'Hồng' or status.headlight_level == 7 and 'Cam' or status.headlight_level == 8 and 'Xanh lá' or status.headlight_level == 9 and 'Xanh nhạt' or status.headlight_level == 10 and 'Xanh ngọc' or status.headlight_level == 11 and 'Xanh nước biển' or status.headlight_level == 12 and 'Vàng nhạt' or 'Không xác định'
                    local turboStatus = status.turbo == 1 and 'Có' or 'Không'
                    local hornName = not status.horn or status.horn == -1 and 'Mặc định' or status.horn == 0 and 'Xe tải' or status.horn == 1 and 'Cảnh sát' or status.horn == 2 and 'Hề' or status.horn == 3 and 'Nhạc 1' or status.horn == 4 and 'Nhạc 2' or status.horn == 5 and 'Nhạc 3' or status.horn == 6 and 'Nhạc 4' or status.horn == 7 and 'Nhạc 5' or status.horn == 8 and 'Buồn 1' or status.horn == 9 and 'Buồn 2' or status.horn == 10 and 'Buồn 3' or status.horn == 11 and 'Buồn 4' or status.horn == 12 and 'Buồn 5' or status.horn == 13 and 'Jazz 1' or status.horn == 14 and 'Jazz 2' or status.horn == 15 and 'Jazz 3' or status.horn == 16 and 'Cổ điển 1' or status.horn == 17 and 'Cổ điển 2' or status.horn == 18 and 'Cổ điển 3' or status.horn == 19 and 'Cổ điển 4' or status.horn == 20 and 'Cổ điển 5' or status.horn == 21 and 'Cổ điển 6' or status.horn == 22 and 'Cổ điển 7' or status.horn == 23 and 'Thang âm 1' or status.horn == 24 and 'Thang âm 2' or status.horn == 25 and 'Thang âm 3' or status.horn == 26 and 'Thang âm 4' or status.horn == 27 and 'Thang âm 5' or status.horn == 28 and 'Thang âm 6' or status.horn == 29 and 'Thang âm 7' or status.horn == 30 and 'Thang âm 8' or status.horn == 31 and 'Vui 1' or status.horn == 32 and 'Vui 2' or status.horn == 33 and 'Vui 3' or status.horn == 34 and 'Vui 4' or status.horn == 35 and 'Vui 5' or status.horn == 36 and 'Vui 6' or status.horn == 37 and 'Vui 7' or status.horn == 38 and 'Vui 8' or status.horn == 39 and 'Vui 9' or status.horn == 40 and 'Vui 10' or status.horn == 41 and 'Vui 11' or status.horn == 42 and 'Vui 12' or status.horn == 43 and 'Vui 13' or status.horn == 44 and 'Vui 14' or status.horn == 45 and 'Vui 15' or status.horn == 46 and 'Vui 16' or status.horn == 47 and 'Vui 17' or status.horn == 48 and 'Vui 18' or status.horn == 49 and 'Vui 19' or status.horn == 50 and 'Vui 20' or status.horn == 51 and 'Vui 21' or 'Không xác định'
                    local pearlescentName = not status.pearlescent or status.pearlescent == -1 and 'Không' or status.pearlescent == 3 and 'Đỏ ánh kim' or status.pearlescent == 61 and 'Xanh dương ánh kim' or status.pearlescent == 49 and 'Xanh lá ánh kim' or status.pearlescent == 89 and 'Vàng ánh kim' or status.pearlescent == 142 and 'Tím ánh kim' or status.pearlescent == 137 and 'Hồng ánh kim' or status.pearlescent == 36 and 'Cam ánh kim' or status.pearlescent == 111 and 'Trắng ánh kim' or status.pearlescent == 0 and 'Đen ánh kim' or 'Không xác định'
                    lib.registerContext({
                        id = 'vehicle_status_menu',
                        title = 'Trạng thái xe ' .. plate .. ' (' .. model .. ')',
                        options = {
                            { label = 'Động cơ: Cấp ' .. status.engine_level },
                            { label = 'Phanh: Cấp ' .. status.brake_level },
                            { label = 'Giảm xóc: Cấp ' .. status.suspension_level },
                            { label = 'Đèn pha: ' .. headlightName },
                            { label = 'Turbo: ' .. turboStatus },
                            { label = 'Còi: ' .. hornName },
                            { label = 'Màu chính: ' .. GetColorName(status.primary_color) },
                            { label = 'Màu phụ: ' .. GetColorName(status.secondary_color) },
                            { label = 'Sơn ánh kim: ' .. pearlescentName },
                            { label = 'Màu biển số: ' .. plateColorName },
                            { label = 'Đóng', args = 'close' }
                        },
                        onSelect = function(selected)
                            if selected.args == 'close' then lib.hideContext('vehicle_status_menu') end
                        end
                    })
                    lib.showContext('vehicle_status_menu')
                end
            end
        end
    end
end)

-- Áp dụng trạng thái xe khi spawn
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        local playerPed = PlayerPedId()
        local vehicle = GetClosestVehicle(GetEntityCoords(playerPed), 5.0, 0, 70)
        if DoesEntityExist(vehicle) then
            local plate = GetVehicleNumberPlateText(vehicle)
            local status = lib.callback.await('vehicle:getUpgradeStatus', false, plate)
            SetVehicleModKit(vehicle, 0)
            SetVehicleMod(vehicle, 11, status.engine_level - 1, false)
            SetVehicleMod(vehicle, 12, status.brake_level - 1, false)
            SetVehicleMod(vehicle, 15, status.suspension_level - 1, false)
            SetVehicleColours(vehicle, status.primary_color, status.secondary_color)
            SetVehicleExtraColours(vehicle, status.pearlescent or -1, 0)
            SetVehicleNumberPlateTextIndex(vehicle, status.plate_color)
            if status.headlight_level > 0 then SetVehicleMod(vehicle, 22, 0, false) SetVehicleHeadlightsColour(vehicle, status.headlight_level - 1) else SetVehicleMod(vehicle, 22, -1, false) end
            ToggleVehicleMod(vehicle, 18, status.turbo == 1)
            SetVehicleMod(vehicle, 14, status.horn or -1, false)
        end
    end
end)