CREATE TABLE `class_reward` (
  `job_id` mediumint(6) NOT NULL DEFAULT '0',
  `min` mediumint(6) NOT NULL DEFAULT '0',
  `max` mediumint(6) NOT NULL DEFAULT '0'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

INSERT INTO `class_reward` (`job_id`, `min`, `max`) VALUES
(4008, 0, 3),
(4009, 0, 3),
(4010, 0, 3),
(4011, 0, 3),
(4012, 0, 3),
(4013, 0, 3),
(4014, 0, 3),
(4015, 0, 3),
(4016, 0, 3),
(4017, 0, 3),
(4018, 0, 3),
(4019, 0, 3),
(4020, 0, 3),
(4021, 0, 3);

ALTER TABLE `class_reward` ADD PRIMARY KEY (`job_id`);

INSERT INTO `class_reward_setting` (`item_id`, `amount`, `zeny`) VALUES
(0, 501, 10);

ALTER TABLE `class_reward_setting` ADD PRIMARY KEY (`item_id`);