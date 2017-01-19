#Everyone gets everything
INSERT INTO userLinkRole
(user_id, role_id)
SELECT * FROM
(SELECT user_id FROM user) AS user,
(SELECT role_id FROM role) AS role