CREATE TABLE `woeladder` (
	`char_id` INT PRIMARY KEY,
	`name` VARCHAR(24) NOT NULL DEFAULT '',
	`streaks` INT DEFAULT 0,
	`kills` INT DEFAULT 0,
	`deaths` INT DEFAULT 0,
	`streaktime` DATETIME,
	KEY (`kills`),
	KEY (`streaks`)
) ENGINE = MyISAM;

CREATE TABLE `ownwoeladder` (
	`guild_id` INT PRIMARY KEY,
	`name` VARCHAR(24) NOT NULL DEFAULT '',
	`currentown` INT DEFAULT 0,
	`highestown` INT DEFAULT 0,
	`owntime` DATETIME,
	KEY (`highestown`)
) ENGINE = MyISAM; 