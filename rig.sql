-- User Accounts

CREATE TABLE IF NOT EXISTS `users` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `unique_id` VARCHAR(255) NOT NULL,
    `username` VARCHAR(255) DEFAULT NULL,
    `name` VARCHAR(255) NOT NULL,
    `license` VARCHAR(255) NOT NULL,
    `discord` VARCHAR(255) DEFAULT NULL,
    `tokens` JSON NOT NULL,
    `ip` VARCHAR(255) NOT NULL,
    `banned` TINYINT(1) NOT NULL DEFAULT 0,
    `muted` TINYINT(1) NOT NULL DEFAULT 0,
    `deleted` TINYINT(1) NOT NULL DEFAULT 0,
    `metadata` JSON NOT NULL,
    `last_login` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `created` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`unique_id`),
    KEY `id_idx` (`id`),
    KEY `license_idx` (`license`),
    KEY `banned_idx` (`banned`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `user_bans` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `unique_id` VARCHAR(255) NOT NULL,
    `banned_by` VARCHAR(255) NOT NULL DEFAULT 'rig',
    `reason` TEXT DEFAULT NULL,
    `expires_at` TIMESTAMP NULL DEFAULT NULL,
    `expired` TINYINT(1) NOT NULL DEFAULT 0,
    `appealed` TINYINT(1) NOT NULL DEFAULT 0,
    `appealed_by` VARCHAR(255) DEFAULT NULL,
    `created` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `unique_id_idx` (`unique_id`),
    KEY `expired_idx` (`expired`),
    FOREIGN KEY (`unique_id`) REFERENCES `users` (`unique_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `user_warnings` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `unique_id` VARCHAR(255) NOT NULL,
    `warned_by` VARCHAR(255) NOT NULL DEFAULT 'rig',
    `reason` TEXT DEFAULT NULL,
    `created` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `unique_id_idx` (`unique_id`),
    FOREIGN KEY (`unique_id`) REFERENCES `users` (`unique_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Groups

CREATE TABLE IF NOT EXISTS `groups` (
    `name` VARCHAR(50) NOT NULL,
    `label` VARCHAR(100) NOT NULL,
    `type` VARCHAR(32) NOT NULL DEFAULT 'group',
    `parent_name` VARCHAR(50) DEFAULT NULL,
    `metadata` JSON NOT NULL,
    PRIMARY KEY (`name`),
    KEY `type_idx` (`type`),
    FOREIGN KEY (`parent_name`) REFERENCES `groups` (`name`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `group_roles` (
    `group_name` VARCHAR(50) NOT NULL,
    `name` VARCHAR(50) NOT NULL,
    `label` VARCHAR(100) NOT NULL,
    `grade` INT NOT NULL DEFAULT 0,
    `permissions` JSON NOT NULL,
    PRIMARY KEY (`group_name`, `name`),
    KEY `grade_idx` (`grade`),
    FOREIGN KEY (`group_name`) REFERENCES `groups` (`name`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `group_members` (
    `group_name` VARCHAR(50) NOT NULL,
    `unique_id` VARCHAR(255) NOT NULL,
    `char_id` INT NOT NULL DEFAULT 0,
    `role_name` VARCHAR(50) NOT NULL,
    `is_primary` TINYINT(1) NOT NULL DEFAULT 0,
    `metadata` JSON NOT NULL,
    `created` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`group_name`, `unique_id`, `char_id`),
    FOREIGN KEY (`group_name`) REFERENCES `groups` (`name`) ON DELETE CASCADE,
    FOREIGN KEY (`group_name`, `role_name`) REFERENCES `group_roles` (`group_name`, `name`) ON DELETE CASCADE,
    FOREIGN KEY (`unique_id`) REFERENCES `users` (`unique_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;