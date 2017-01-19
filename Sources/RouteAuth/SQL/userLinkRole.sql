CREATE TABLE IF NOT EXISTS userLinkRole (
    user_id int(10) unsigned NOT NULL,
    role_id int(10) unsigned NOT NULL,
    PRIMARY KEY (user_id, role_id),
    FOREIGN KEY user_id_key (user_id) REFERENCES user(user_id),
    FOREIGN KEY role_id_key (role_id) REFERENCES role(role_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8