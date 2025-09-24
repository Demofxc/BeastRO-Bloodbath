CREATE TABLE `pvpladder` (
	`char_id` INT PRIMARY KEY,
	`name` VARCHAR(24) NOT NULL DEFAULT '',
	`streaks` INT DEFAULT 0,
	`kills` INT DEFAULT 0,
	`deaths` INT DEFAULT 0,
	`streaktime` DATETIME,
	KEY (`kills`),
	KEY (`streaks`)
) ENGINE = MyISAM;

CREATE TABLE `ownladder` (
	`guild_id` INT PRIMARY KEY,
	`name` VARCHAR(24) NOT NULL DEFAULT '',
	`currentown` INT DEFAULT 0,
	`highestown` INT DEFAULT 0,
	`owntime` DATETIME,
	KEY (`highestown`)
) ENGINE = MyISAM; 

CREATE TABLE `pvpladder_reward` (
	`char_id` INT,
	`weekindex` INT,
	`rank` TINYINT UNSIGNED,
	KEY (`char_id`)
) ENGINE = MyISAM;