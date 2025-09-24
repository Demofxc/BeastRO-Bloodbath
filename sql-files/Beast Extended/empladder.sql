CREATE TABLE IF NOT EXISTS `empladder` (
    `char_id` INT(11) UNSIGNED NOT NULL,
    `count` INT(11) NOT NULL DEFAULT '0',
    PRIMARY KEY (`char_id`)
) ENGINE=InnoDB;