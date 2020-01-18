CREATE DATABASE IF NOT EXISTS `cemetery`;

CREATE TABLE `maintaining_company` (
  `id` INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `contract_start` DATETIME,
  `contract_end` DATETIME,
  `contact_phone` VARCHAR(14),
  `contact_mail` VARCHAR(40),
  `created_at` DATETIME NOT NULL DEFAULT (now())
);

CREATE TABLE `sector` (
  `id` INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `code` VARCHAR(20) NOT NULL,
  `capacity` INT NOT NULL,
  `maintaining_company_id` INT,
  `created_at` DATETIME NOT NULL DEFAULT (now())
);

CREATE TABLE `grave_type` (
  `id` INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(30) NOT NULL,
  `capacity` INT,
  `created_at` DATETIME NOT NULL DEFAULT (now())
);

CREATE TABLE `slot` (
  `id` INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `price` FLOAT(30, 2),
  `sector_id` INT NOT NULL,
  `grave_type_id` INT NOT NULL,
  `created_at` DATETIME NOT NULL DEFAULT (now())
);

CREATE TABLE `user_family_member` (
  `id` INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `user_id` INT NOT NULL,
  `family_member_id` INT NOT NULL
);

CREATE TABLE `family_member` (
  `id` INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `first_name` VARCHAR(30) NOT NULL,
  `last_name` VARCHAR(40) NOT NULL,
  `contact_phone` VARCHAR(14),
  `contact_mail` VARCHAR(40),
  `marketing_consent` TINYINT DEFAULT 0,
  `created_at` DATETIME NOT NULL DEFAULT (now())
);

CREATE TABLE `user` (
  `id` INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `first_name` VARCHAR(30) NOT NULL,
  `last_name` VARCHAR(40) NOT NULL,
  `additional_names` VARCHAR(70),
  `start_date` DATE,
  `paid_from` DATE,
  `paid_until` DATE,
  `passing_date` DATE,
  `slot_id` INT NOT NULL,
  `created_at` DATETIME NOT NULL DEFAULT (now())
);

CREATE TABLE `log` (
  `id` INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `created_at` DATETIME NOT NULL DEFAULT (now())
);

ALTER TABLE `sector` ADD FOREIGN KEY (`maintaining_company_id`) REFERENCES `maintaining_company` (`id`);

ALTER TABLE `slot` ADD FOREIGN KEY (`sector_id`) REFERENCES `sector` (`id`);

ALTER TABLE `slot` ADD FOREIGN KEY (`grave_type_id`) REFERENCES `grave_type` (`id`);

ALTER TABLE `user_family_member` ADD FOREIGN KEY (`user_id`) REFERENCES `user` (`id`);

ALTER TABLE `user_family_member` ADD FOREIGN KEY (`family_member_id`) REFERENCES `family_member` (`id`);

ALTER TABLE `user` ADD FOREIGN KEY (`slot_id`) REFERENCES `slot` (`id`);


DELIMITER #

CREATE TRIGGER `log_date_after_insert_on_user` AFTER INSERT ON `user`
    FOR EACH ROW
BEGIN
    INSERT INTO log () VALUES ();
END#

delimiter ;

CREATE PROCEDURE SelectAllFamilyMembersIdsOnRelativePassingDay (OUT id INT)
    BEGIN
        SELECT
            f.id
        FROM
            family_member f
                INNER JOIN user_family_member ufm ON f.id = ufm.family_member_id
                INNER JOIN user u ON ufm.user_id = u.id
        WHERE MONTH(u.passing_date)=MONTH(CURDATE())
          AND DAY(u.passing_date)=DAY(CURDATE());
    END;

CALL SelectAllFamilyMembersIdsOnRelativePassingDay(@id);