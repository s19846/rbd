SELECT
    CONCAT(u.first_name, ' ', u.last_name) as full_name,
    gt.name as grave_type
FROM
    user u
INNER JOIN slot s on u.slot_id = s.id
INNER JOIN grave_type gt on s.grave_type_id = gt.id;

INSERT INTO grave_type (name, capacity) VALUES ('temp_name', 9999);
UPDATE grave_type SET capacity = 61 WHERE name = 'temp_name';
DELETE FROM grave_type where name = 'temp_name';