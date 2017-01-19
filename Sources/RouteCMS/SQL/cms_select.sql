SELECT 'markdown' AS type, cms_page_content_link_markdown.cms_markdown_id AS id, cms_markdown.handle
FROM cms_page_content_link_markdown
INNER JOIN cms_markdown ON cms_markdown.cms_markdown_id = cms_page_content_link_markdown.cms_markdown_id
WHERE cms_page_content_id = ?
UNION
SELECT 'words' AS type, cms_page_content_link_words.cms_words_id AS id, cms_words.handle
FROM cms_page_content_link_words
INNER JOIN cms_words ON cms_words.cms_words_id = cms_page_content_link_words.cms_words_id
WHERE cms_page_content_id = ?