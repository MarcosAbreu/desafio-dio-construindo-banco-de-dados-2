# Desafio DIO - Potência Tech powered by iFood | Ciência de Dados - Construa um Projeto Lógico de Banco de Dados do Zero

Código para certificação DIO Potência Tech powered by iFood | Ciência de Dados. Módulo: Construa um Projeto Lógico de Banco de Dados do Zero

## Desafio
Implementar o projeto lógico de banco de dados para uma oficina de automóveis e desenvolver queries que atendam as seguintes clausulas:

* Recuperações simples com SELECT Statement
* Filtros com WHERE Statement
* Crie expressões para gerar atributos derivados
* Defina ordenações dos dados com ORDER BY
* Condições de filtros aos grupos – HAVING Statement
* Crie junções entre tabelas para fornecer uma perspectiva mais complexa dos dados

Para atender estes requisitos, devem ser elaboradas perguntas os quais as queries responderão.

## Ferramentas
* [MySQL Workbench](https://www.mysql.com/products/workbench/)
* [GitHub](https://github.com)

## Objetivo do Modelo

O modelo representa um sistema de controle e gerenciamento de ordens de serviço para uma oficina de automóveis.

## Modelo EER

O modelo EER foi desenvolvido com base nas vídeo-aulas do desafio, sendo alterado para cumprir as requisições do desafio. Abaixo esta o screenshoot do modelo. O arquivo do modelo esta na localizado em `modelo/auto-repair-dio.mwb`.


![Screenshot do Modelo](https://github.com/MarcosAbreu/desafio-dio-construindo-banco-de-dados-2/blob/main/modelo/auto-repair-dio.png)

## Implementação SQL

O Banco de Dados foi implementado no MySQL Workbench seguindo as diretrizes de criação do Schema, Criação de Tabelas, Inserção de Dados para teste e Teste. As queries estão todas no arquivo `sql/desafio-dio.sql`.

## Resultado do Desafio

A seguir, estão as perguntas realizadas, queries e resultados retornados.


### 1) Quais as ordens de serviços para o cliente 'Ricardo Doe' ?

#### Query: 

~~~sql
SELECT	`auto-repair-dio`.`clients`.`name` as `Client_name`,
        `auto-repair-dio`.`vehicle`.`model` as `Car_model`,
        `auto-repair-dio`.`vehicle`.`brand` as `Car_brand`,
        `auto-repair-dio`.`vehicle`.`license_plate` as `License_plate`,
        `auto-repair-dio`.`service_request`.`description` as `Issue_request`,
        `auto-repair-dio`.`service_order`.`order_date` as `Order_date`,
        `auto-repair-dio`.`service`.`description` as `Fix_description`,
        `auto-repair-dio`.`service_order`.`status` as `Status`,
        `auto-repair-dio`.`service_order`.`estimated_date` as `End_date`,
        `auto-repair-dio`.`service_order`.`service_cost` as `Service_cost`,
        `auto-repair-dio`.`service_order`.`parts_cost` as `Parts_cost`,
        `auto-repair-dio`.`service_order`.`total_cost` as `Total_cost`,
        `auto-repair-dio`.`mechanic`.`name` as `Mechanic`
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
~~~

#### Resultado: 

Client_name | Car_model | Car_brand | License_plate | Issue_request | Order_date | Fix_description | Status | End_date | Service_cost | Parts_cost | Total_cost | Mechanic
:--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | 
Ricardo Doe | Camaro | Chevrolet | J5H211L | Farol esta piscando quando o carro esta em movimento | 2023-09-09 10:26:35 | Troca da fiação do farol | Orçando | 2023-09-12 14:00:00 | 150 | 20.9 | 170.9 | Eduardo Campos |
Ricardo Doe | Charger | Dodge | AJH31O3 | Manutenção de 10.000 Km | 2023-09-09 10:26:35 | Troca de óleo | Em Andamento | 2023-09-13 17:00:00 | 80 | 111.5 | 191.5 | Alisson dos Anjos |
Ricardo Doe | Charger | Dodge | AJH31O3 | Manutenção de 10.000 Km | 2023-09-09 10:26:35 | Substituição do filtro de óleo | Em Andamento | 2023-09-13 17:00:00 | 80 | 111.5 | 191.5 | Alisson dos Anjos |

<br>

### 2) Quais são os fornecedores de peças para a peça 'Filtro de óleo' ?

#### Query: 

~~~sql
SELECT	`auto-repair-dio`.`auto_parts`.`description`,
        GROUP_CONCAT(`auto-repair-dio`.`supplier`.`name`)
    FROM `auto-repair-dio`.`supplier_has_auto_parts`
    INNER JOIN `auto-repair-dio`.`supplier`
        ON `auto-repair-dio`.`supplier_has_auto_parts`.`supplier_idSupplier` = `auto-repair-dio`.`supplier`.`idSupplier`
    INNER JOIN `auto-repair-dio`.`auto_parts`
        ON `auto-repair-dio`.`supplier_has_auto_parts`.`auto_parts_idAuto_parts` = `auto-repair-dio`.`auto_parts`.`idAuto_parts`
    GROUP BY(`auto-repair-dio`.`auto_parts`.`description`)
    HAVING `auto-repair-dio`.`auto_parts`.`description` = 'Filtro de óleo';
~~~

#### Resultado: 

description | GROUP_CONCAT(auto-repair-dio.supplier.name)
:--- | :---: 
Filtro de óleo | Jeffão auto peças,Auto peças do Silva

<br>

### 3) Quais são os fornecedores de peças? 

#### Query: 

~~~sql
SELECT	`auto-repair-dio`.`supplier`.`name`,
        `auto-repair-dio`.`supplier`.`phone`,
        `auto-repair-dio`.`supplier`.`website`,
        `auto-repair-dio`.`supplier`.`address`
    FROM `auto-repair-dio`.`supplier`
    ORDER BY `name` ASC;
~~~


#### Resultado: 

name | phone | website | address
:--- | :---: | :---: | :---:
Auto peças do Silva | 21999885557 | | Av. Joaquim,2123-Santa Amélia,Belford Roxo/RJ
HD auto peças | 16532488777 | https://hdautopecas.com.br | Rua Esteves Jr, 500, Altinópolis/SP
Jeffão auto peças | 11999888777 | https://jeffadaspecas.com.br | Av. 25 de março,522-Centro,São Paulo/SP

<br>
