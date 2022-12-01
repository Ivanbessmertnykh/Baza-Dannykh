--
-- Скрипт сгенерирован Devart dbForge Studio 2020 for MySQL, Версия 9.0.304.0
-- Домашняя страница продукта: http://www.devart.com/ru/dbforge/mysql/studio
-- Дата скрипта: 25.11.2022 20:51:23
-- Версия сервера: 5.6.20
-- Версия клиента: 4.1
--

-- 
-- Отключение внешних ключей
-- 
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;

-- 
-- Установить режим SQL (SQL mode)
-- 
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

-- 
-- Установка кодировки, с использованием которой клиент будет посылать запросы на сервер
--
SET NAMES 'utf8';

--
-- Установка базы данных по умолчанию
--
USE `travel agency`;

--
-- Удалить функцию `age`
--
DROP FUNCTION IF EXISTS age;

--
-- Удалить функцию `is_number_correct`
--
DROP FUNCTION IF EXISTS is_number_correct;

--
-- Удалить процедуру `client_sales`
--
DROP PROCEDURE IF EXISTS client_sales;

--
-- Удалить таблицу `sales`
--
DROP TABLE IF EXISTS sales;

--
-- Удалить процедуру `client_phone`
--
DROP PROCEDURE IF EXISTS client_phone;

--
-- Удалить таблицу `clients`
--
DROP TABLE IF EXISTS clients;

--
-- Удалить процедуру `tours_info`
--
DROP PROCEDURE IF EXISTS tours_info;

--
-- Удалить функцию `full_price`
--
DROP FUNCTION IF EXISTS full_price;

--
-- Удалить таблицу `tours`
--
DROP TABLE IF EXISTS tours;

--
-- Удалить таблицу `flights`
--
DROP TABLE IF EXISTS flights;

--
-- Удалить таблицу `types_of_food`
--
DROP TABLE IF EXISTS types_of_food;

--
-- Удалить таблицу `types_of_tours`
--
DROP TABLE IF EXISTS types_of_tours;

--
-- Удалить процедуру `hotel_average_price`
--
DROP PROCEDURE IF EXISTS hotel_average_price;

--
-- Удалить процедуру `hotel_city`
--
DROP PROCEDURE IF EXISTS hotel_city;

--
-- Удалить процедуру `more3_stars_hotels`
--
DROP PROCEDURE IF EXISTS more3_stars_hotels;

--
-- Удалить таблицу `hotels`
--
DROP TABLE IF EXISTS hotels;

--
-- Удалить таблицу `types_of_accommodation`
--
DROP TABLE IF EXISTS types_of_accommodation;

--
-- Удалить таблицу `cities`
--
DROP TABLE IF EXISTS cities;

--
-- Удалить таблицу `countries`
--
DROP TABLE IF EXISTS countries;

--
-- Установка базы данных по умолчанию
--
USE `travel agency`;

--
-- Создать таблицу `countries`
--
CREATE TABLE countries (
  id_country int(11) NOT NULL AUTO_INCREMENT,
  country_name varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (id_country)
)
ENGINE = INNODB,
AUTO_INCREMENT = 5,
AVG_ROW_LENGTH = 4096,
CHARACTER SET utf8,
COLLATE utf8_general_ci;

--
-- Создать таблицу `cities`
--
CREATE TABLE cities (
  id_city int(11) NOT NULL AUTO_INCREMENT,
  id_country int(11) NOT NULL,
  city_name varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (id_city, id_country),
  UNIQUE INDEX UK_cities_id_city (id_city)
)
ENGINE = INNODB,
AUTO_INCREMENT = 5,
AVG_ROW_LENGTH = 4096,
CHARACTER SET utf8,
COLLATE utf8_general_ci;

--
-- Создать индекс `IDX_cities_id_country` для объекта типа таблица `cities`
--
ALTER TABLE cities
ADD INDEX IDX_cities_id_country (id_country);

--
-- Создать внешний ключ
--
ALTER TABLE cities
ADD CONSTRAINT FK_cities_id_country FOREIGN KEY (id_country)
REFERENCES countries (id_country) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Создать таблицу `types_of_accommodation`
--
CREATE TABLE types_of_accommodation (
  id_accommodation_type int(11) NOT NULL AUTO_INCREMENT,
  accommodation_type varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (id_accommodation_type)
)
ENGINE = INNODB,
AUTO_INCREMENT = 6,
AVG_ROW_LENGTH = 4096,
CHARACTER SET utf8,
COLLATE utf8_general_ci;

--
-- Создать таблицу `hotels`
--
CREATE TABLE hotels (
  id_hotel int(11) NOT NULL AUTO_INCREMENT,
  id_city int(11) NOT NULL,
  id_accommodation_type int(11) NOT NULL,
  hotel_name varchar(255) NOT NULL DEFAULT '',
  stars int(11) NOT NULL,
  room_price float NOT NULL,
  PRIMARY KEY (id_hotel, id_city, id_accommodation_type),
  UNIQUE INDEX UK_hotels_id_hotel (id_hotel)
)
ENGINE = INNODB,
AUTO_INCREMENT = 5,
AVG_ROW_LENGTH = 4096,
CHARACTER SET utf8,
COLLATE utf8_general_ci;

--
-- Создать индекс `IDX_hotels_id_accommodation_type` для объекта типа таблица `hotels`
--
ALTER TABLE hotels
ADD INDEX IDX_hotels_id_accommodation_type (id_accommodation_type);

--
-- Создать индекс `IDX_hotels_id_city` для объекта типа таблица `hotels`
--
ALTER TABLE hotels
ADD INDEX IDX_hotels_id_city (id_city);

--
-- Создать внешний ключ
--
ALTER TABLE hotels
ADD CONSTRAINT FK_hotels_id_accommodation_type FOREIGN KEY (id_accommodation_type)
REFERENCES types_of_accommodation (id_accommodation_type) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Создать внешний ключ
--
ALTER TABLE hotels
ADD CONSTRAINT FK_hotels_id_city FOREIGN KEY (id_city)
REFERENCES cities (id_city) ON DELETE NO ACTION ON UPDATE NO ACTION;

DELIMITER $$

--
-- Создать процедуру `more3_stars_hotels`
--
CREATE DEFINER = 'root'@'localhost'
PROCEDURE more3_stars_hotels ()
BEGIN
  SELECT
    hotels.hotel_name AS "Название отеля",
    cities.city_name AS "Город расположения"
  FROM hotels
    INNER JOIN cities
      ON hotels.id_city = cities.id_city
  WHERE stars > 3;
END
$$

--
-- Создать процедуру `hotel_city`
--
CREATE DEFINER = 'root'@'localhost'
PROCEDURE hotel_city (IN c varchar(255))
BEGIN
  SELECT
    hotels.hotel_name
  FROM hotels
  WHERE id_city = (SELECT
      id_city
    FROM cities
    WHERE city_name = c);
END
$$

--
-- Создать процедуру `hotel_average_price`
--
CREATE DEFINER = 'root'@'localhost'
PROCEDURE hotel_average_price ()
BEGIN
  SELECT
    AVG(hotels.room_price) AS "Средняя стоимость",
    cities.city_name AS "Город"
  FROM hotels
    INNER JOIN cities
      ON hotels.id_city = cities.id_city
  GROUP BY cities.city_name;
END
$$

DELIMITER ;

--
-- Создать таблицу `types_of_tours`
--
CREATE TABLE types_of_tours (
  id_tour_type int(11) NOT NULL AUTO_INCREMENT,
  tour_type varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (id_tour_type)
)
ENGINE = INNODB,
AUTO_INCREMENT = 5,
AVG_ROW_LENGTH = 4096,
CHARACTER SET utf8,
COLLATE utf8_general_ci;

--
-- Создать таблицу `types_of_food`
--
CREATE TABLE types_of_food (
  id_food_type int(11) NOT NULL AUTO_INCREMENT,
  food_type varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (id_food_type)
)
ENGINE = INNODB,
AUTO_INCREMENT = 4,
AVG_ROW_LENGTH = 8192,
CHARACTER SET utf8,
COLLATE utf8_general_ci;

--
-- Создать таблицу `flights`
--
CREATE TABLE flights (
  id_flight int(11) NOT NULL AUTO_INCREMENT,
  departure_city varchar(255) NOT NULL DEFAULT '',
  departure_date date NOT NULL,
  departure_time time NOT NULL,
  arrival_city varchar(255) NOT NULL DEFAULT '',
  arrival_date date NOT NULL,
  arrival_time time NOT NULL,
  flight_price float NOT NULL,
  PRIMARY KEY (id_flight)
)
ENGINE = INNODB,
AUTO_INCREMENT = 7,
AVG_ROW_LENGTH = 2730,
CHARACTER SET utf8,
COLLATE utf8_general_ci;

--
-- Создать таблицу `tours`
--
CREATE TABLE tours (
  id_tour int(11) NOT NULL AUTO_INCREMENT,
  id_flight_there int(11) NOT NULL,
  id_flight_back int(11) NOT NULL,
  id_hotel int(11) NOT NULL,
  id_tour_type int(11) NOT NULL,
  id_food_type int(11) NOT NULL,
  start_date date NOT NULL,
  end_date date NOT NULL,
  PRIMARY KEY (id_tour, id_tour_type, id_food_type, id_hotel, id_flight_there, id_flight_back)
)
ENGINE = INNODB,
AUTO_INCREMENT = 4,
AVG_ROW_LENGTH = 5461,
CHARACTER SET utf8,
COLLATE utf8_general_ci;

--
-- Создать индекс `IDX_tours_id_flight` для объекта типа таблица `tours`
--
ALTER TABLE tours
ADD INDEX IDX_tours_id_flight (id_flight_there);

--
-- Создать индекс `IDX_tours_id_food_type` для объекта типа таблица `tours`
--
ALTER TABLE tours
ADD INDEX IDX_tours_id_food_type (id_food_type);

--
-- Создать индекс `IDX_tours_id_hotel` для объекта типа таблица `tours`
--
ALTER TABLE tours
ADD INDEX IDX_tours_id_hotel (id_hotel);

--
-- Создать индекс `IDX_tours_id_tour_type` для объекта типа таблица `tours`
--
ALTER TABLE tours
ADD INDEX IDX_tours_id_tour_type (id_tour_type);

--
-- Создать внешний ключ
--
ALTER TABLE tours
ADD CONSTRAINT FK_tours_id_flight FOREIGN KEY (id_flight_there)
REFERENCES flights (id_flight);

--
-- Создать внешний ключ
--
ALTER TABLE tours
ADD CONSTRAINT FK_tours_id_flight_back FOREIGN KEY (id_flight_back)
REFERENCES flights (id_flight);

--
-- Создать внешний ключ
--
ALTER TABLE tours
ADD CONSTRAINT FK_tours_id_food_type FOREIGN KEY (id_food_type)
REFERENCES types_of_food (id_food_type) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Создать внешний ключ
--
ALTER TABLE tours
ADD CONSTRAINT FK_tours_id_hotel FOREIGN KEY (id_hotel)
REFERENCES hotels (id_hotel) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Создать внешний ключ
--
ALTER TABLE tours
ADD CONSTRAINT FK_tours_id_tour_type FOREIGN KEY (id_tour_type)
REFERENCES types_of_tours (id_tour_type) ON DELETE NO ACTION ON UPDATE NO ACTION;

DELIMITER $$

--
-- Создать функцию `full_price`
--
CREATE DEFINER = 'root'@'localhost'
FUNCTION full_price (idt int)
RETURNS int(11)
BEGIN
  DECLARE price int;
  SET price = (SELECT
      flight_price
    FROM flights
    WHERE id_flight = (SELECT
        id_flight_there
      FROM tours
      WHERE id_tour = idt)) + (SELECT
      flight_price
    FROM flights
    WHERE id_flight = (SELECT
        id_flight_back
      FROM tours
      WHERE id_tour = idt)) +
  ((SELECT
      room_price
    FROM hotels
    WHERE id_hotel = (SELECT
        id_hotel
      FROM tours
      WHERE id_tour = idt)) *
  DATEDIFF((SELECT
      start_date
    FROM tours
    WHERE id_tour = idt), (SELECT
      end_date
    FROM tours
    WHERE id_tour = idt))
  ) + 20000;

  RETURN price;
END
$$

--
-- Создать процедуру `tours_info`
--
CREATE DEFINER = 'root'@'localhost'
PROCEDURE tours_info ()
BEGIN
  SELECT
    tours.id_tour AS "Номер тура",
    cities.city_name AS "Куда летим",
    tours.start_date AS "Когда вылет",
    tours.end_date AS "Когда возвращаемся",
    hotels.hotel_name AS "Отель проживания",
    types_of_food.food_type AS "Питание"
  FROM tours
    INNER JOIN hotels
      ON tours.id_hotel = hotels.id_hotel
    INNER JOIN cities
      ON hotels.id_city = cities.id_city
    INNER JOIN types_of_food
      ON tours.id_food_type = types_of_food.id_food_type
  ORDER BY `Номер тура`;
END
$$

DELIMITER ;

--
-- Создать таблицу `clients`
--
CREATE TABLE clients (
  id_client int(11) NOT NULL AUTO_INCREMENT,
  second_name varchar(255) NOT NULL DEFAULT '',
  first_name varchar(255) NOT NULL DEFAULT '',
  patronymic varchar(255) NOT NULL DEFAULT '',
  date_of_birth date NOT NULL,
  address varchar(255) NOT NULL DEFAULT '',
  phone_number varchar(11) NOT NULL DEFAULT '',
  PRIMARY KEY (id_client)
)
ENGINE = INNODB,
AUTO_INCREMENT = 5,
AVG_ROW_LENGTH = 4096,
CHARACTER SET utf8,
COLLATE utf8_general_ci;

DELIMITER $$

--
-- Создать процедуру `client_phone`
--
CREATE DEFINER = 'root'@'localhost'
PROCEDURE client_phone (IN idCl int)
BEGIN
  IF (ISNULL(idCl)) THEN
    SELECT
      second_name AS "Фамилия",
      first_name AS "Имя",
      CONCAT(
      '+',
      SUBSTRING(clients.phone_number, 1, 1),
      '(',
      SUBSTRING(clients.phone_number, 2, 3),
      ')',
      SUBSTRING(clients.phone_number, 5, 3),
      '-',
      SUBSTRING(clients.phone_number, 8, 2),
      '-',
      SUBSTRING(clients.phone_number, 10, 2)
      ) AS "Номер телефона"
    FROM clients;
  ELSE
    SELECT
      second_name AS "Фамилия",
      first_name AS "Имя",
      CONCAT(
      '+',
      SUBSTRING(clients.phone_number, 1, 1),
      '(',
      SUBSTRING(clients.phone_number, 2, 3),
      ')',
      SUBSTRING(clients.phone_number, 5, 3),
      '-',
      SUBSTRING(clients.phone_number, 8, 2),
      '-',
      SUBSTRING(clients.phone_number, 10, 2)
      ) AS "Номер телефона"
    FROM clients
    WHERE id_client = idCl;
  END IF;
END
$$

DELIMITER ;

--
-- Создать таблицу `sales`
--
CREATE TABLE sales (
  id_sale int(11) NOT NULL AUTO_INCREMENT,
  id_client int(11) NOT NULL,
  id_tour int(11) NOT NULL,
  sale_date datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  price float NOT NULL,
  PRIMARY KEY (id_sale, id_client, id_tour)
)
ENGINE = INNODB,
AUTO_INCREMENT = 6,
AVG_ROW_LENGTH = 3276,
CHARACTER SET utf8,
COLLATE utf8_general_ci;

--
-- Создать индекс `IDX_sales_id_client` для объекта типа таблица `sales`
--
ALTER TABLE sales
ADD INDEX IDX_sales_id_client (id_client);

--
-- Создать индекс `IDX_sales_id_tour` для объекта типа таблица `sales`
--
ALTER TABLE sales
ADD INDEX IDX_sales_id_tour (id_tour);

--
-- Создать внешний ключ
--
ALTER TABLE sales
ADD CONSTRAINT FK_sales_id_client FOREIGN KEY (id_client)
REFERENCES clients (id_client) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Создать внешний ключ
--
ALTER TABLE sales
ADD CONSTRAINT FK_sales_tours_id_tour FOREIGN KEY (id_tour)
REFERENCES tours (id_tour) ON DELETE NO ACTION ON UPDATE NO ACTION;

DELIMITER $$

--
-- Создать процедуру `client_sales`
--
CREATE DEFINER = 'root'@'localhost'
PROCEDURE client_sales ()
BEGIN
  SELECT
    sales.id_tour AS "Код тура",
    clients.second_name AS "Фамилия",
    clients.first_name AS "Имя",
    clients.patronymic AS "Отчество"
  FROM clients
    INNER JOIN sales
      ON clients.id_client = sales.id_client
  ORDER BY sales.id_tour;
END
$$

--
-- Создать функцию `is_number_correct`
--
CREATE DEFINER = 'root'@'localhost'
FUNCTION is_number_correct (ph varchar(11))
RETURNS tinyint(1)
BEGIN
  IF (ph LIKE '7%')
    AND (ph REGEXP '^[0-9]+$') THEN
    RETURN TRUE;
  ELSE
    RETURN FALSE;
  END IF;
END
$$

--
-- Создать функцию `age`
--
CREATE DEFINER = 'root'@'localhost'
FUNCTION age (datebirth date)
RETURNS int(11)
BEGIN
  DECLARE age int;
  SET age = YEAR(CURRENT_DATE) - YEAR(datebirth);
  IF (DATE_FORMAT(CURRENT_DATE, '%m%d') < DATE_FORMAT(datebirth, '%m%d')) THEN
    SET age = age - 1;
  END IF;
  RETURN (age);
END
$$

DELIMITER ;

-- 
-- Вывод данных для таблицы countries
--
INSERT INTO countries VALUES
(1, 'Австралия'),
(2, 'Казахстан'),
(3, 'Китай'),
(4, 'Германия');

-- 
-- Вывод данных для таблицы types_of_accommodation
--
INSERT INTO types_of_accommodation VALUES
(1, 'SGL'),
(2, 'DBL'),
(3, 'TRPL'),
(4, 'QDPL'),
(5, 'Child');

-- 
-- Вывод данных для таблицы cities
--
INSERT INTO cities VALUES
(1, 1, 'Сидней'),
(2, 2, 'Актау'),
(3, 3, 'Гуйлинь'),
(4, 4, 'Мюнхен');

-- 
-- Вывод данных для таблицы types_of_tours
--
INSERT INTO types_of_tours VALUES
(1, 'Business tours'),
(2, 'Bus tours'),
(3, 'Educational tours'),
(4, 'Tours on burning vouchers');

-- 
-- Вывод данных для таблицы types_of_food
--
INSERT INTO types_of_food VALUES
(1, 'Half board'),
(2, 'Full board'),
(3, 'All inclusive');

-- 
-- Вывод данных для таблицы hotels
--
INSERT INTO hotels VALUES
(1, 1, 4, 'The Grace Hotel', 4, 17500),
(2, 2, 2, 'Caspian Riviera Grand Palace', 5, 5870),
(3, 3, 5, 'Holiday Inn Express Guilin City Center, an IHG Hotel', 4, 2046),
(4, 4, 1, 'Hotel Am Moosfeld', 4, 3587);

-- 
-- Вывод данных для таблицы flights
--
INSERT INTO flights VALUES
(1, 'Одинцово', '2023-01-15', '21:45:00', 'Сидней', '2023-01-16', '13:45:00', 120000),
(2, 'Сидней', '2023-01-24', '09:30:00', 'Одинцово', '2023-01-25', '02:08:00', 120000),
(3, 'Серпухов', '2022-12-20', '15:00:00', 'Актау', '2022-12-20', '20:10:00', 15000),
(4, 'Актау', '2022-12-27', '21:20:00', 'Серпухов', '2022-12-27', '22:35:00', 15000),
(5, 'Шатура', '2022-11-25', '13:20:00', 'Гуйлинь', '2022-11-26', '19:25:00', 70000),
(6, 'Гайлинь', '2022-11-28', '13:00:00', 'Шатура', '2022-11-29', '18:05:00', 70000);

-- 
-- Вывод данных для таблицы tours
--
INSERT INTO tours VALUES
(1, 5, 6, 3, 1, 1, '2022-11-25', '2022-11-28'),
(2, 1, 2, 1, 3, 3, '2023-01-15', '2023-01-24'),
(3, 3, 4, 2, 4, 2, '2022-12-20', '2022-11-27');

-- 
-- Вывод данных для таблицы clients
--
INSERT INTO clients VALUES
(1, 'Островерх', 'София', 'Юлиановна', '1979-06-13', 'Новосибирская область, город Одинцово, спуск Космонавтов, 98', '79614820351'),
(2, 'Алексахин', 'Герасим', 'Валерианович', '1972-12-01', 'Иркутская область, город Серпухов, пер. Чехова, 08', '76540223069'),
(3, 'Лощилова', 'Клавдия', 'Макаровна', '1991-12-13', 'Орловская область, город Шатура, пл. Балканская, 63', '79949401163'),
(4, 'Хорошилов', 'Савва', 'Васильевич', '1984-02-23', 'Ярославская область, город Павловский Посад, бульвар Чехова, 96', '73111245245');

-- 
-- Вывод данных для таблицы sales
--
INSERT INTO sales VALUES
(1, 1, 2, '2022-10-28 00:00:00', 102500),
(2, 2, 3, '2022-11-10 00:00:00', 185010),
(3, 3, 1, '2022-07-23 00:00:00', 153862),
(4, 1, 3, '2022-11-24 00:00:00', 185010),
(5, 2, 1, '2022-11-25 03:01:09', 153862);

--
-- Установка базы данных по умолчанию
--
USE `travel agency`;

--
-- Удалить триггер `delete_client`
--
DROP TRIGGER IF EXISTS delete_client;

--
-- Удалить триггер `insert_clients`
--
DROP TRIGGER IF EXISTS insert_clients;

--
-- Удалить триггер `insert_sales`
--
DROP TRIGGER IF EXISTS insert_sales;

--
-- Удалить триггер `insert_tour`
--
DROP TRIGGER IF EXISTS insert_tour;

--
-- Установка базы данных по умолчанию
--
USE `travel agency`;

DELIMITER $$

--
-- Создать триггер `insert_tour`
--
CREATE
DEFINER = 'root'@'localhost'
TRIGGER insert_tour
BEFORE INSERT
ON tours
FOR EACH ROW
BEGIN
  SET new.start_date = (SELECT
      departure_date
    FROM flights
    WHERE id_flight = new.id_flight_there);
  SET new.end_date = (SELECT
      arrival_date
    FROM flights
    WHERE id_flight = new.id_flight_back);

  IF (new.start_date >= new.end_date) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Тур не может позже завершения. Исправьте даты!";
  END IF;
END
$$

--
-- Создать триггер `insert_sales`
--
CREATE
DEFINER = 'root'@'localhost'
TRIGGER insert_sales
BEFORE INSERT
ON sales
FOR EACH ROW
BEGIN
  SET NEW.price = (full_price(NEW.id_tour));
END
$$

--
-- Создать триггер `insert_clients`
--
CREATE
DEFINER = 'root'@'localhost'
TRIGGER insert_clients
BEFORE INSERT
ON clients
FOR EACH ROW
BEGIN
  IF (age(new.date_of_birth) < 18) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "К сожалению наши клиенты должны быть старше 18 лет.";
  END IF;
  IF (is_number_correct(NEW.phone_number) = FALSE) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Номер телефона введен неправильно. Попробуйте так '7**********'";
  END IF;
END
$$

--
-- Создать триггер `delete_client`
--
CREATE
DEFINER = 'root'@'localhost'
TRIGGER delete_client
BEFORE DELETE
ON clients
FOR EACH ROW
BEGIN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Нельзя удалять данные клиентов";
END
$$

DELIMITER ;

-- 
-- Восстановить предыдущий режим SQL (SQL mode)
--
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;

-- 
-- Включение внешних ключей
-- 
/*!40014 SET FOREIGN_KEY_CHECKS = @OLD_FOREIGN_KEY_CHECKS */;