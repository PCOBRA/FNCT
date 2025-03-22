
["engine_upgrade"] = {
    label = "Bộ nâng cấp động cơ",
    weight = 1000,
    stack = false,
    close = true,
    description = "Dùng để nâng cấp động cơ xe.",
    client = {
        event = "vehicle:upgrade",
        args = { type = "engine" }
    }
},
["brake_upgrade"] = {
     label = "Bộ nâng cấp phanh",
     weight = 800,
     stack = false,
     close = true,
     description = "Dùng để nâng cấp phanh xe.",
     client = {
        event = "vehicle:upgrade",
        args = { type = "brakes" }
    }
},
["suspension_upgrade"] = {
    label = "Bộ nâng cấp giảm xóc",
    weight = 900,
    stack = false,
    close = true,
    description = "Dùng để nâng cấp giảm xóc xe.",
    client = {
        event = "vehicle:upgrade",
        args = { type = "suspension" }
    }
},
["headlight_upgrade"] = { 
    label = "Bộ nâng cấp đèn pha",
    weight = 600, stack = false,
    close = true,
    description = "Dùng để thay đổi màu đèn pha.",
    client = {
        event = "vehicle:headlight" 
    } 
},
["turbo_kit"] = {
    label = "Bộ turbo", 
    weight = 1200, 
    stack = false, 
    close = true, 
    description = "Dùng để lắp turbo cho xe.", 
    client = { 
        event = "vehicle:turbo" 
    } 
},
["horn_kit"] = { 
    label = "Bộ còi xe", 
    weight = 500, 
    stack = false, 
    close = true, 
    description = "Dùng để thay đổi còi xe.", 
    client = { 
        event = "vehicle:horn" 
    } 
},
["pearlescent_paint"] = { 
    label = "Sơn ánh kim", 
    weight = 300, 
    stack = false, 
    close = true, 
    description = "Dùng để thêm lớp sơn ánh kim cho xe.", 
    client = { 
        event = "vehicle:pearlescent" 
    } 
},
["paint_kit"] = { 
    label = "Bộ sơn xe", 
    weight = 400, 
    stack = false, 
    close = true, 
    description = "Dùng để đổi màu xe.", 
    client = { 
        event = "vehicle:paint" 
    } 
},
["plate_paint"] = { 
    label = "Sơn biển số", 
    weight = 200, 
    stack = false, 
    close = true, 
    description = "Dùng để đổi màu biển số xe.", 
    client = { 
        event = "vehicle:plate" 
    } 
},

["engine_reset"] = { 
    label = "Bộ reset động cơ", 
    weight = 800, 
    stack = false, 
    close = true, 
    description = "Dùng để reset động cơ về cấp 0.", 
    client = { 
        event = "vehicle:reset", 
        args = { type = "engine" } 
    } 
},
["brake_reset"] = { 
    label = "Bộ reset phanh", 
    weight = 700, 
    stack = false, 
    close = true, 
    description = "Dùng để reset phanh về cấp 0.", 
    client = { 
        event = "vehicle:reset", 
        args = { type = "brakes" } 
    } 
},
["suspension_reset"] = { 
    label = "Bộ reset giảm xóc", 
    weight = 750, 
    stack = false, 
    close = true, 
    description = "Dùng để reset giảm xóc về cấp 0.", 
    client = { 
        event = "vehicle:reset", 
        args = { type = "suspension" } 
    } 
},
["headlight_reset"] = { 
    label = "Bộ reset đèn pha", 
    weight = 600, 
    stack = false, 
    close = true, 
    description = "Dùng để reset đèn pha về trạng thái thường.", 
    client = { 
        event = "vehicle:reset", 
        args = { type = "headlights" } 
    } 
},
["turbo_remover"] = { 
    label = "Dụng cụ tháo turbo", 
    weight = 1000, 
    stack = false, 
    close = true, 
    description = "Dùng để tháo turbo khỏi xe.", 
    client = { 
        event = "vehicle:reset", 
        args = { type = "turbo" } 
    } 
},
["horn_reset"] = { 
    label = "Bộ reset còi", 
    weight = 400, 
    stack = false, 
    close = true, 
    description = "Dùng để reset còi về mặc định.", 
    client = { 
        event = "vehicle:reset", 
        args = { type = "horn" } 
    } 
},
["pearlescent_reset"] = { 
    label = "Bộ xóa sơn ánh kim", 
    weight = 250, 
    stack = false, 
    close = true, 
    description = "Dùng để xóa lớp sơn ánh kim về mặc định.", 
    client = { 
        event = "vehicle:reset", 
        args = { type = "pearlescent" } 
    } 
},