CREATE TABLE role (
    role_id int(10) unsigned NOT NULL AUTO_INCREMENT,
    role varchar(255) NOT NULL,
    PRIMARY KEY (role_id),
    UNIQUE KEY title_key(role)
) ENGINE=InnoDB DEFAULT CHARSET=utf8