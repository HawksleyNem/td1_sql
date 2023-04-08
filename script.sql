CREATE USER 'hawksley'@'localhost' IDENTIFIED by 'secret';
CREATE USER 'nathan'@'localhost' IDENTIFIED by 'secret';

CREATE DATABASE `bank_db` IF NOT EXISTS CHARACTER SET 'UTF8' COLLATE 'utf8_general_ci';

GRANT ALL ON bank_db.* TO 'hawksley'@'localhost';
-- GRANT CREATE, SELECT, DELETE, UPDATE ON `bank_db`.* TO `hawksley`@`localhost`
-- FLUSH PRIVILEGES
-- ^ Nettoyer les privilèges
GRANT SELECT ON bank_db.* TO 'nathan'@'localhost';

SHOW DATABASES;

-- USE `bank_db`

CREATE TABLE  `customers` (
    `customer_id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    -- `id`
    -- ^ Bonne pratique juste `id`
    `first_name` VARCHAR(100) NOT NULL,
    `last_name` VARCHAR(100) NOT NULL,
    `address` LONGTEXT NOT NULL,
    `phone_number1` INT NOT NULL,
    `phone_number2` INT
);

DESCRIBE TABLE `customers`;

CREATE TABLE `accounts` (
    `account_id` INT NOT NULL AUTO_INCREMENT,
    `account_type` VARCHAR(100) NOT NULL,
    `balance` FLOAT NOT NULL DEFAULT 0.00,
    -- `balance` FLOAT NOT NULL DEFAULT '0.00',
    `customer_id` INT,
    PRIMARY KEY (`account_id`),
    FOREIGN KEY (`customer_id`) REFERENCES `customers`(`customer_id`)
    -- CONSTRAINT FK_customers_accounts FOREIGN KEY (`customer_id`) REFERENCES `customers`(`customer_id`),
    -- CONSTRAINT CHK_balance CHECK (`balance` >= 0)
);

SHOW TABLES;

ALTER TABLE `customers`
   	CHANGE `phone_number1` `phone` VARCHAR(14)
    MODIFY COLUMN `phone` VARCHAR(14),
    DROP COLUMN `phone_number2`,
    ADD COLUMN `email` VARCHAR(255) NOT NULL,
    CONSTRAINT CHECK(LENGTH(`phone`) >= 10 AND LENGTH(`phone`) <= 14)
    -- ADD CONSTRAINT CHK_phone CHECK(LENGTH(`phone`) >= 10 AND LENGTH(`phone`) <= 14)

ALTER TABLE `accounts`
    MODIFY COLUMN `balance` DECIMAL(7,2)

-- mysqldump -u root bank_db > path\save_db.sql

DROP TABLE `accounts`, `customers`;
-- Faire attention à l'ordre avec les FOREIGN KEY


-- Partie 3

SELECT * FROM `customers`;

SELECT * FROM `customers`
WHERE `last_name` = 'Duval';

SELECT * FROM `customers`
WHERE `first_name` LIKE 'M%';

SELECT
`customers`.`first_name` AS 'Prénom',
`customers`.`last_name` AS 'Nom',
`accounts`.`account_type` AS 'Type_de_compte'
FROM `customers`
JOIN `accounts` ON `customers`.`customer_id` = `accounts`.`customer_id`
WHERE `account_type` LIKE 'Plan Epargne%';

SELECT COUNT(`account_id`) AS 'Nombre de comptes' FROM `accounts`;
SELECT
`customers`.`first_name` AS 'Prénom',
`customers`.`last_name` AS 'Nom',
COUNT(`accounts`.`account_id`) AS `Nombre de comptes`
FROM `customers`
JOIN `accounts` ON `customers`.`customer_id` = `accounts`.`customer_id`
GROUP BY `customers`.`customer_id`;

SELECT SUM(`balance`) AS 'Total dépôt client'
FROM `accounts`;

SELECT
`customers`.`first_name` AS 'Prénom',
`customers`.`last_name` AS 'Nom',
SUM(`accounts`.`balance`) AS `Solde total`
FROM `customers`
JOIN `accounts` ON `customers`.`customer_id` = `accounts`.`customer_id`
GROUP BY `customers`.`customer_id`;

SELECT
`customers`.`first_name` AS 'Prénom',
`customers`.`last_name` AS 'Nom',
SUM(`accounts`.`balance`) AS `Solde total`
FROM `customers`
JOIN `accounts` ON `customers`.`customer_id` = `accounts`.`customer_id`
WHERE `accounts`.`balance` >= 10000
GROUP BY `customers`.`customer_id`;

SELECT AVG(`balance`) AS 'Solde moyen des comptes bancaires'
FROM `accounts`;

-- SELECT `balance`
-- FROM `accounts`
-- WHERE `customer_id` = 9 AND `account_type` = 'Livret A'

UPDATE `accounts`
SET `balance` = `balance` + (
    SELECT `balance`
    FROM `accounts`
    WHERE `customer_id` = 9 AND `account_type` = 'Livret A'
)
WHERE `customer_id` = 9 AND `account_type` = 'Compte courant'