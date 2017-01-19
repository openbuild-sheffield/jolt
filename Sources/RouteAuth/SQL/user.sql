CREATE TABLE user (
    user_id int(10) unsigned NOT NULL AUTO_INCREMENT,
    username varchar(255) NOT NULL,
    secret text NOT NULL,
    email text NOT NULL,
    password text NOT NULL,
    passwordUpdate tinyint(1) NOT NULL DEFAULT 0,
    created datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id),
    UNIQUE KEY username_key(username)
) ENGINE=InnoDB DEFAULT CHARSET=utf8