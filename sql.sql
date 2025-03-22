CREATE TABLE IF NOT EXISTS `vehicle_upgrades` (
    `plate` VARCHAR(8) PRIMARY KEY,
    `engine_level` INT DEFAULT 0,
    `brake_level` INT DEFAULT 0,
    `suspension_level` INT DEFAULT 0,
    `primary_color` INT DEFAULT 0,
    `secondary_color` INT DEFAULT 0,
    `plate_color` INT DEFAULT 0,
    `headlight_level` INT DEFAULT 0,
    `turbo` INT DEFAULT 0,
    `horn` INT DEFAULT -1,
    `pearlescent` INT DEFAULT -1
);