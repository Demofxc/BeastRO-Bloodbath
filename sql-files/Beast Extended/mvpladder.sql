CREATE TABLE `mvpladder` (
	`id` int(11) NOT NULL AUTO_INCREMENT,
	`char_id` int(11) unsigned NOT NULL default '0',
	`mob_id` INT NOT NULL,
	`kills` INT DEFAULT 0,
  	PRIMARY KEY (`id`),
	INDEX (`char_id`),
	INDEX (`mob_id`),
	INDEX (`kills`)
) ENGINE=MyISAM AUTO_INCREMENT=1;