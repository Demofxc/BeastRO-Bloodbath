CREATE TABLE IF NOT EXISTS `vendings` (
  `id` int(10) unsigned NOT NULL,
  `account_id` int(11) unsigned NOT NULL,
  `char_id` int(10) unsigned NOT NULL,
  `sex` enum('F','M') NOT NULL DEFAULT 'M',
  `map` varchar(20) NOT NULL,
  `x` smallint(5) unsigned NOT NULL,
  `y` smallint(5) unsigned NOT NULL,
  `title` varchar(80) NOT NULL,
  `body_direction` CHAR( 1 ) NOT NULL DEFAULT '4',
  `head_direction` CHAR( 1 ) NOT NULL DEFAULT '0',
  `sit` CHAR( 1 ) NOT NULL DEFAULT '1',
  `autotrade` tinyint(4) NOT NULL,
  `vending_item` int(10) unsigned NOT NULL default '0'
) ENGINE=MyISAM;