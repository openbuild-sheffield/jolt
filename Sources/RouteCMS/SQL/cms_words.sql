CREATE TABLE cms_words (
    cms_words_id int(10) unsigned NOT NULL AUTO_INCREMENT,
    handle varchar(255) NOT NULL,
    words TEXT NOT NULL,
    PRIMARY KEY (cms_words_id),
    UNIQUE KEY title_key(handle)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;