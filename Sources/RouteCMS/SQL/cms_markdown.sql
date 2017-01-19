CREATE TABLE cms_markdown (
    cms_markdown_id int(10) unsigned NOT NULL AUTO_INCREMENT,
    handle varchar(255) NOT NULL,
    markdown TEXT NOT NULL,
    html TEXT NOT NULL,
    PRIMARY KEY (cms_markdown_id),
    UNIQUE KEY title_key(handle)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;