DROP TABLE IF EXISTS `party_queue`;
CREATE TABLE `party_queue` (
  `party_id` INT(11) UNSIGNED NOT NULL,
  `name` VARCHAR(24) NOT NULL DEFAULT '',
  `leader_id` INT(11) UNSIGNED NOT NULL DEFAULT '0',
  `guild_rating` INT NOT NULL DEFAULT '0',
  `active` TINYINT UNSIGNED NOT NULL DEFAULT '0',
  `challenge_party` VARCHAR(24) NOT NULL DEFAULT '',
  PRIMARY KEY (`party_id`),
  UNIQUE INDEX `party_id_UNIQUE` (`party_id` ASC))
ENGINE = MyISAM;

DROP TABLE IF EXISTS `guild_stats`;
CREATE TABLE `guild_stats` (
  `guild_id` INT(11) UNSIGNED NOT NULL,
  `char_id` INT(11) UNSIGNED NOT NULL,
  `name` VARCHAR(24) NOT NULL DEFAULT '',
  `rating` INT NOT NULL DEFAULT '0',
  `wins` INT UNSIGNED NOT NULL DEFAULT '0',
  `loses` INT UNSIGNED NOT NULL DEFAULT '0',
  PRIMARY KEY (`guild_id`))
ENGINE = MyISAM;