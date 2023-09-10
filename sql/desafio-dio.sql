-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema auto-repair-dio
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema auto-repair-dio
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `auto-repair-dio` DEFAULT CHARACTER SET utf8 ;
USE `auto-repair-dio` ;

-- -----------------------------------------------------
-- Create Table `clients`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `auto-repair-dio`.`clients` (
  `idClient` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `CPF` CHAR(11) NULL,
  `CNPJ` CHAR(14) NULL,
  `address` VARCHAR(45) NULL,
  `birthdate` DATE NULL,
  `phone` CHAR(11) NOT NULL,
  `email` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idClient`),
  UNIQUE INDEX `CPF_UNIQUE` (`CPF` ASC) VISIBLE,
  UNIQUE INDEX `CNPJ_UNIQUE` (`CNPJ` ASC) VISIBLE,
  CONSTRAINT CHK_Client CHECK (`CPF` != NULL OR `CNPJ`!= NULL)
);


-- -----------------------------------------------------
-- Create Table `mechanic`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `auto-repair-dio`.`mechanic` (
  `idMechanic` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `especialization` ENUM('Elétrica e Eletrônica', 'Sistemas de Arrefecimento', 'Freios', 'Amortecedores e Suspensões', 'Estética Automotiva', 'Sistema de Transmissão', 'Manutenção de Veículos', 'Geral') NOT NULL DEFAULT 'Geral',
  PRIMARY KEY (`idMechanic`)
);


-- -----------------------------------------------------
-- Create Table `service_order`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `auto-repair-dio`.`service_order` (
  `idService_order` INT NOT NULL AUTO_INCREMENT,
  `status` ENUM('Orçando', 'Aguardando Liberação', 'Em Andamento', 'Concluido', 'Cancelado') NOT NULL,
  `order_date` DATETIME NOT NULL,
  `estimated_date` DATETIME NOT NULL,
  `total_cost` FLOAT NULL,
  `service_cost` FLOAT NULL,
  `parts_cost` FLOAT NULL,
  PRIMARY KEY (`idService_order`)
);


-- -----------------------------------------------------
-- Create Table `mechanic_team`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `auto-repair-dio`.`mechanic_team` (
  `idMechanic_team` INT NOT NULL AUTO_INCREMENT,
  `service_order_idService_order` INT NOT NULL,
  `mechanic_idMechanic` INT NOT NULL,
  PRIMARY KEY (`idMechanic_team`, `service_order_idService_order`, `mechanic_idMechanic`),
  INDEX `fk_mechanic_has_service_order_mechanic1_idx` (`mechanic_idMechanic` ASC) VISIBLE,
  INDEX `fk_mechanic_team_service_order1_idx` (`service_order_idService_order` ASC) VISIBLE,
  CONSTRAINT `fk_mechanic_has_service_order_mechanic1`
    FOREIGN KEY (`mechanic_idMechanic`)
    REFERENCES `auto-repair-dio`.`mechanic` (`idMechanic`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_mechanic_team_service_order1`
    FOREIGN KEY (`service_order_idService_order`)
    REFERENCES `auto-repair-dio`.`service_order` (`idService_order`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);


-- -----------------------------------------------------
-- Create Table `service_request`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `auto-repair-dio`.`service_request` (
  `idService_request` INT NOT NULL AUTO_INCREMENT,
  `description` VARCHAR(100) NOT NULL,
  `type` ENUM('Revisão', 'Conserto') NOT NULL,
  `mechanic_team_idMechanic_team` INT NOT NULL,
  PRIMARY KEY (`idService_request`, `mechanic_team_idMechanic_team`),
  INDEX `fk_service_request_mechanic_team1_idx` (`mechanic_team_idMechanic_team` ASC) VISIBLE,
  CONSTRAINT `fk_service_request_mechanic_team1`
    FOREIGN KEY (`mechanic_team_idMechanic_team`)
    REFERENCES `auto-repair-dio`.`mechanic_team` (`idMechanic_team`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);


-- -----------------------------------------------------
-- Create Table `vehicle`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `auto-repair-dio`.`vehicle` (
  `idVehicle` INT NOT NULL AUTO_INCREMENT,
  `license_plate` VARCHAR(7) NOT NULL,
  `model` VARCHAR(45) NOT NULL,
  `brand` VARCHAR(45) NOT NULL,
  `color` VARCHAR(45) NULL,
  `service_request_idService_request` INT NOT NULL,
  `clients_idClient` INT NOT NULL,
  PRIMARY KEY (`idVehicle`, `service_request_idService_request`, `clients_idClient`),
  INDEX `fk_vehicle_clients1_idx` (`clients_idClient` ASC) VISIBLE,
  INDEX `fk_vehicle_service_request1_idx` (`service_request_idService_request` ASC) VISIBLE,
  CONSTRAINT `fk_vehicle_clients1`
    FOREIGN KEY (`clients_idClient`)
    REFERENCES `auto-repair-dio`.`clients` (`idClient`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_vehicle_service_request1`
    FOREIGN KEY (`service_request_idService_request`)
    REFERENCES `auto-repair-dio`.`service_request` (`idService_request`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);


-- -----------------------------------------------------
-- Create Table `auto_parts`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `auto-repair-dio`.`auto_parts` (
  `idAuto_parts` INT NOT NULL AUTO_INCREMENT,
  `description` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idAuto_parts`)
);


-- -----------------------------------------------------
-- Create Table `supplier`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `auto-repair-dio`.`supplier` (
  `idSupplier` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `phone` CHAR(11) NOT NULL,
  `website` VARCHAR(80) NULL,
  `address` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`idSupplier`)
);


-- -----------------------------------------------------
-- Create Table `services_cost`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `auto-repair-dio`.`services_cost` (
  `idServices_cost` INT NOT NULL AUTO_INCREMENT,
  `description` VARCHAR(45) NOT NULL,
  `cost` FLOAT NOT NULL,
  PRIMARY KEY (`idServices_cost`)
);


-- -----------------------------------------------------
-- Create Table `service`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `auto-repair-dio`.`service` (
  `idService` INT NOT NULL AUTO_INCREMENT,
  `description` VARCHAR(100) NOT NULL,
  `services_cost_idServices_cost` INT NOT NULL,
  PRIMARY KEY (`idService`, `services_cost_idServices_cost`),
  INDEX `fk_service_services_cost1_idx` (`services_cost_idServices_cost` ASC) VISIBLE,
  CONSTRAINT `fk_service_services_cost1`
    FOREIGN KEY (`services_cost_idServices_cost`)
    REFERENCES `auto-repair-dio`.`services_cost` (`idServices_cost`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);


-- -----------------------------------------------------
-- Create Table `auto_parts_has_service`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `auto-repair-dio`.`auto_parts_has_service` (
  `auto_parts_idAuto_parts` INT NOT NULL,
  `service_idService` INT NOT NULL,
  PRIMARY KEY (`auto_parts_idAuto_parts`, `service_idService`),
  INDEX `fk_auto_parts_has_service_service1_idx` (`service_idService` ASC) VISIBLE,
  INDEX `fk_auto_parts_has_service_auto_parts1_idx` (`auto_parts_idAuto_parts` ASC) VISIBLE,
  CONSTRAINT `fk_auto_parts_has_service_auto_parts1`
    FOREIGN KEY (`auto_parts_idAuto_parts`)
    REFERENCES `auto-repair-dio`.`auto_parts` (`idAuto_parts`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_auto_parts_has_service_service1`
    FOREIGN KEY (`service_idService`)
    REFERENCES `auto-repair-dio`.`service` (`idService`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);


-- -----------------------------------------------------
-- Table `supplier_has_auto_parts`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `auto-repair-dio`.`supplier_has_auto_parts` (
  `idSupplier_has_auto_parts` INT NOT NULL AUTO_INCREMENT,
  `supplier_idSupplier` INT NOT NULL,
  `auto_parts_idAuto_parts` INT NOT NULL,
  `value` FLOAT NOT NULL,
  PRIMARY KEY (`idSupplier_has_auto_parts`, `supplier_idSupplier`, `auto_parts_idAuto_parts`),
  INDEX `fk_supplier_has_auto_parts_auto_parts1_idx` (`auto_parts_idAuto_parts` ASC) VISIBLE,
  INDEX `fk_supplier_has_auto_parts_supplier1_idx` (`supplier_idSupplier` ASC) VISIBLE,
  CONSTRAINT `fk_supplier_has_auto_parts_supplier1`
    FOREIGN KEY (`supplier_idSupplier`)
    REFERENCES `auto-repair-dio`.`supplier` (`idSupplier`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_supplier_has_auto_parts_auto_parts1`
    FOREIGN KEY (`auto_parts_idAuto_parts`)
    REFERENCES `auto-repair-dio`.`auto_parts` (`idAuto_parts`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);


-- -----------------------------------------------------
-- Table `service_order_has_service`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `auto-repair-dio`.`service_order_has_service` (
  `service_order_idService_order` INT NOT NULL,
  `service_idService` INT NOT NULL,
  PRIMARY KEY (`service_order_idService_order`, `service_idService`),
  INDEX `fk_service_order_has_service_service1_idx` (`service_idService` ASC) VISIBLE,
  INDEX `fk_service_order_has_service_service_order1_idx` (`service_order_idService_order` ASC) VISIBLE,
  CONSTRAINT `fk_service_order_has_service_service_order1`
    FOREIGN KEY (`service_order_idService_order`)
    REFERENCES `auto-repair-dio`.`service_order` (`idService_order`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_service_order_has_service_service1`
    FOREIGN KEY (`service_idService`)
    REFERENCES `auto-repair-dio`.`service` (`idService`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);

-- -----------------------------------------------------
-- Insert Into Table `clients`
-- -----------------------------------------------------
INSERT INTO `auto-repair-dio`.`clients` 
	(`name`,`CPF`,`address`,`birthdate`,`phone`,`email`)
    VALUES 
		('Ricardo Doe','99999999999','Av. Nowhere, 15','1937-01-01','51998505877','ricardodoe@gmail.com'),
        ('John Doe','11111111111','Av. Nowhere, 16','1937-12-31','51998505877','johndoe@gmail.com'),
        ('Jane Doe','22222222222','Av. Nowhere, 16','1937-06-15','51998505877','janedoe@gmail.com');

-- -----------------------------------------------------
-- Insert Into Table `service_order`
-- -----------------------------------------------------
INSERT INTO `auto-repair-dio`.`service_order` 
	(`status`,`order_date`,`estimated_date`,`total_cost`,`service_cost`,`parts_cost`)
    VALUES 
		('Orçando','2023-09-09 10:26:35','2023-09-12 14:00:00',170.90,150,20.90),
        ('Aguardando Liberação','2023-09-08 11:34:36','2023-09-11 17:00:00',243.97,200,43.97),
        ('Em Andamento','2023-09-09 10:26:35','2023-09-13 17:00:00',191.50,80,111.50),
        ('Em Andamento','2023-09-09 10:26:35','2023-09-13 17:00:00',191.50,80,111.50);

-- -----------------------------------------------------
-- Insert Into Table `mechanic`
-- -----------------------------------------------------
INSERT INTO `auto-repair-dio`.`mechanic` 
	(`name`,`especialization`)
    VALUES 
		('Eduardo Campos','Elétrica e Eletrônica'),
        ('Jael Santos','Sistema de Transmissão'),
        ('Alisson dos Anjos','Geral');

-- -----------------------------------------------------
-- Insert Into Table `mechanic_team`
-- -----------------------------------------------------
INSERT INTO `auto-repair-dio`.`mechanic_team` 
	(`service_order_idService_order`,`mechanic_idMechanic`)
    VALUES 
		(1,1),
        (2,2),
        (3,3),
        (4,3);

-- -----------------------------------------------------
-- Insert Into Table `service_request`
-- -----------------------------------------------------
INSERT INTO `auto-repair-dio`.`service_request` 
	(`description`,`mechanic_team_idMechanic_team`,`type`)
    VALUES 
		('Farol esta piscando quando o carro esta em movimento',1,'Conserto'),
        ('Dificuldade para trocar marchas',2,'Conserto'),
        ('Manutenção de 10.000 Km',3,'Revisão');
            
-- -----------------------------------------------------
-- Insert Into Table `vehicle`
-- -----------------------------------------------------
INSERT INTO `auto-repair-dio`.`vehicle` 
	(`license_plate`,`model`,`brand`,`color`,`service_request_idService_request`,`clients_idClient`)
    VALUES 
		('J5H211L','Camaro','Chevrolet','vermelho',1,1),
        ('A32J2K2','Ka','Ford','prata',2,2),
        ('AJH31O3','Charger','Dodge','preto',3,1);
        
-- -----------------------------------------------------
-- Insert Into Table `services_cost`
-- -----------------------------------------------------
INSERT INTO `auto-repair-dio`.`services_cost` 
	(`description`,`cost`)
    VALUES 
		('Troca da fiação do farol',150),
        ('Subistituição Cabo Marcha',200),
        ('Troca de óleo',30),
        ('Substituição do filtro de óleo',50);
                 
-- -----------------------------------------------------
-- Insert Into Table `auto_parts`
-- -----------------------------------------------------
INSERT INTO `auto-repair-dio`.`auto_parts` 
	(`description`)
    VALUES 
		('Kit Terminal Cabo Marcha Ka 2017'),
		('Filtro de óleo'),
        ('1L de óleo de motor'),
        ('Cabo para farol de neblina');
        
-- -----------------------------------------------------
-- Insert Into Table `supplier`
-- -----------------------------------------------------
INSERT INTO `auto-repair-dio`.`supplier` 
	(`name`,`phone`,`website`,`address`)
    VALUES 
		('Jeffão auto peças','11999888777','https://jeffadaspecas.com.br','Av. 25 de março,522-Centro,São Paulo/SP'),
		('Auto peças do Silva','21999885557',null,'Av. Joaquim,2123-Santa Amélia,Belford Roxo/RJ'),
        ('HD auto peças','16532488777','https://hdautopecas.com.br','Rua Esteves Jr, 500, Altinópolis/SP');
        
-- -----------------------------------------------------
-- Insert Into Table `service`
-- -----------------------------------------------------
INSERT INTO `auto-repair-dio`.`service` 
	(`description`,`services_cost_idServices_cost`)
    VALUES 
		('Troca da fiação do farol',1),
		('Substituição cabo de marcha',2),
        ('Troca de óleo',3),
        ('Substituição do filtro de óleo',4);
        
-- -----------------------------------------------------
-- Insert Into Table `service_order_has_service`
-- -----------------------------------------------------
INSERT INTO `auto-repair-dio`.`service_order_has_service` 
	(`service_order_idService_order`,`service_idService`)
    VALUES 
		(1,1),
        (2,2),
        (3,3),
        (3,4);

-- -----------------------------------------------------
-- Insert Into Table `auto_parts_has_service`
-- -----------------------------------------------------
INSERT INTO `auto-repair-dio`.`auto_parts_has_service` 
	(`auto_parts_idAuto_parts`,`service_idService`)
    VALUES 
		(4,1),
        (1,2),
        (3,3),
        (2,4);
			
-- -----------------------------------------------------
-- Insert Into Table `supplier_has_auto_parts`
-- -----------------------------------------------------
INSERT INTO `auto-repair-dio`.`supplier_has_auto_parts` 
	(`auto_parts_idAuto_parts`,`supplier_idSupplier`,`value`)
    VALUES 
		(4,3,20.90),
        (1,2,43.97),
        (3,1,55),
        (2,2,56.50),
        (4,2,25.90),
        (1,3,46.90),
        (3,2,50),
        (2,1,59.90);


-- =====================================================
-- DESAFIO DIO
-- =====================================================

-- -----------------------------------------------------
-- Pergunta: Quais as ordens de serviços para o cliente 'Ricardo Doe' ?
-- -----------------------------------------------------

SELECT	`auto-repair-dio`.`clients`.`name` 					as `Client_name`,
		`auto-repair-dio`.`vehicle`.`model`					as `Car_model`,
        `auto-repair-dio`.`vehicle`.`brand`					as `Car_brand`,
        `auto-repair-dio`.`vehicle`.`license_plate`			as `License_plate`,
        `auto-repair-dio`.`service_request`.`description`	as `Issue_request`,
        `auto-repair-dio`.`service_order`.`order_date`		as `Order_date`,
        `auto-repair-dio`.`service`.`description`			as `Fix_description`,
        `auto-repair-dio`.`service_order`.`status`			as `Status`,
        `auto-repair-dio`.`service_order`.`estimated_date`	as `End_date`,
        `auto-repair-dio`.`service_order`.`service_cost`	as `Service_cost`,
        `auto-repair-dio`.`service_order`.`parts_cost`		as `Parts_cost`,
        `auto-repair-dio`.`service_order`.`total_cost`		as `Total_cost`,
        `auto-repair-dio`.`mechanic`.`name`					as `Mechanic`
    FROM `auto-repair-dio`.`service_order_has_service`
    INNER JOIN `auto-repair-dio`.`service`
		ON `auto-repair-dio`.`service_order_has_service`.`service_idService` = `auto-repair-dio`.`service`.`idService`
	INNER JOIN `auto-repair-dio`.`service_order`
		ON `auto-repair-dio`.`service_order_has_service`.`service_order_idService_order` = `auto-repair-dio`.`service_order`.`idService_order`
	INNER JOIN `auto-repair-dio`.`mechanic_team`
		ON `auto-repair-dio`.`mechanic_team`.`service_order_idService_order` = `auto-repair-dio`.`service_order`.`idService_order`
	INNER JOIN `auto-repair-dio`.`mechanic`
		ON `auto-repair-dio`.`mechanic_team`.`mechanic_idMechanic` = `auto-repair-dio`.`mechanic`.`idMechanic`
	INNER JOIN `auto-repair-dio`.`service_request`
		ON `auto-repair-dio`.`service_request`.`mechanic_team_idMechanic_team` = `auto-repair-dio`.`mechanic_team`.`idMechanic_team`
	INNER JOIN `auto-repair-dio`.`vehicle`
		ON `auto-repair-dio`.`vehicle`.`service_request_idService_request` = `auto-repair-dio`.`service_request`.`idService_request`
	INNER JOIN `auto-repair-dio`.`clients`
		ON `auto-repair-dio`.`vehicle`.`clients_idClient` = `auto-repair-dio`.`clients`.`idClient`
	WHERE `auto-repair-dio`.`clients`.`name` = 'Ricardo Doe';

-- -----------------------------------------------------
-- Pergunta: Quais são os fornecedores de peças para a peça 'Filtro de óleo' ?
-- -----------------------------------------------------

SELECT	`auto-repair-dio`.`auto_parts`.`description`,
		GROUP_CONCAT(`auto-repair-dio`.`supplier`.`name`)
	FROM `auto-repair-dio`.`supplier_has_auto_parts`
    INNER JOIN `auto-repair-dio`.`supplier`
		ON `auto-repair-dio`.`supplier_has_auto_parts`.`supplier_idSupplier` = `auto-repair-dio`.`supplier`.`idSupplier`
	INNER JOIN `auto-repair-dio`.`auto_parts`
		ON `auto-repair-dio`.`supplier_has_auto_parts`.`auto_parts_idAuto_parts` = `auto-repair-dio`.`auto_parts`.`idAuto_parts`
	GROUP BY(`auto-repair-dio`.`auto_parts`.`description`)
    HAVING `auto-repair-dio`.`auto_parts`.`description` = 'Filtro de óleo';

-- -----------------------------------------------------
-- Pergunta: Quais são os fornecedores de peças?
-- -----------------------------------------------------

SELECT	`auto-repair-dio`.`supplier`.`name`,
		`auto-repair-dio`.`supplier`.`phone`,
        `auto-repair-dio`.`supplier`.`website`,
        `auto-repair-dio`.`supplier`.`address`
	FROM `auto-repair-dio`.`supplier`
	ORDER BY `name` ASC;
