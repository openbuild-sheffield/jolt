CREATE TABLE cms_page (
    cms_page_id int(10) unsigned NOT NULL AUTO_INCREMENT,
    uri varchar(255) NOT NULL,
    template_path varchar(255) NOT NULL,
    title varchar(255) NOT NULL,
    description TEXT NOT NULL,
    created DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (cms_page_id),
    UNIQUE KEY title_key(uri)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO cms_page (uri, template_path, title, description)
VALUES
(
    "/", "page.html", "Home Page", "Home page meta description"
);

CREATE TABLE cms_page_content (
    cms_page_content_id int(10) unsigned NOT NULL AUTO_INCREMENT,
    cms_page_id int(10) unsigned NOT NULL,
    template_variable varchar(255) NOT NULL,
    is_list tinyint(1) NOT NULL DEFAULT 0,
    PRIMARY KEY (cms_page_content_id),
    UNIQUE KEY title_page_variable_key(cms_page_id, template_variable),
    FOREIGN KEY cms_page_id_key (cms_page_id) REFERENCES cms_page(cms_page_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO cms_page_content (cms_page_id, template_variable)
VALUES
(
    (SELECT cms_page_id FROM cms_page WHERE uri = "/"),
    "header"
),
(
    (SELECT cms_page_id FROM cms_page WHERE uri = "/"),
    "content"
),
(
    (SELECT cms_page_id FROM cms_page WHERE uri = "/"),
    "footer"
);

CREATE TABLE cms_page_content_link_markdown (
    cms_page_content_id int(10) unsigned NOT NULL,
    cms_markdown_id int(10) unsigned NOT NULL,
    UNIQUE KEY cms_page_content_link_markdown_key(cms_page_content_id, cms_markdown_id),
    FOREIGN KEY cms_page_content_id_key (cms_page_content_id) REFERENCES cms_page_content(cms_page_content_id) ON DELETE CASCADE,
    FOREIGN KEY cms_markdown_id_key (cms_markdown_id) REFERENCES cms_markdown(cms_markdown_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO cms_page_content_link_markdown (cms_page_content_id, cms_markdown_id)
VALUES
(
    (
        SELECT cms_page_content.cms_page_content_id
        FROM cms_page_content
        INNER JOIN cms_page ON cms_page_content.cms_page_id = cms_page.cms_page_id
        WHERE cms_page.uri = "/"
        AND cms_page_content.template_variable = "header"
    ),
    (SELECT cms_markdown_id FROM cms_markdown WHERE handle = "header")
),
INSERT INTO cms_page_content_link_markdown (cms_page_content_id, cms_markdown_id)
VALUES
(
    (
        SELECT cms_page_content.cms_page_content_id
        FROM cms_page_content
        INNER JOIN cms_page ON cms_page_content.cms_page_id = cms_page.cms_page_id
        WHERE cms_page.uri = "/"
        AND cms_page_content.template_variable = "content"
    ),
    (SELECT cms_markdown_id FROM cms_markdown WHERE handle = "home_page")
),
INSERT INTO cms_page_content_link_markdown (cms_page_content_id, cms_markdown_id)
VALUES
(
    (
        SELECT cms_page_content.cms_page_content_id
        FROM cms_page_content
        INNER JOIN cms_page ON cms_page_content.cms_page_id = cms_page.cms_page_id
        WHERE cms_page.uri = "/"
        AND cms_page_content.template_variable = "footer"
    ),
    (SELECT cms_markdown_id FROM cms_markdown WHERE handle = "footer")
);

CREATE TABLE cms_page_content_link_words (
    cms_page_content_id int(10) unsigned NOT NULL,
    cms_words_id int(10) unsigned NOT NULL,
    UNIQUE KEY cms_page_content_link_words_key(cms_page_content_id, cms_words_id),
    FOREIGN KEY cms_page_content_id_key (cms_page_content_id) REFERENCES cms_page_content(cms_page_content_id) ON DELETE CASCADE,
    FOREIGN KEY cms_words_id_key (cms_words_id) REFERENCES cms_words(cms_words_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
